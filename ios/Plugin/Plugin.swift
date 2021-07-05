import Foundation
import Capacitor
import Paystack

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(PaystackCapacitor)
public class PaystackCapacitor: CAPPlugin {
    
    var publicKey: String!
    var email: String!
    var amount: UInt!
    
    var cardParams: PSTCKCardParams! //.init()
    var charge: PSTCKTransactionParams!
    
    func getCallValue<T>(_ name: String, _ call: CAPPluginCall, _ type: T) -> T? {
        return nil
    }
    
    @objc func initialize(_ call: CAPPluginCall) {
        self.publicKey = call.getString("publicKey", "");
        Paystack.setDefaultPublicKey(self.publicKey)
        self.cardParams = nil
        self.charge = nil
        call.resolve([
            "initialized": true
        ])
    }
    
    @objc func addCard(_ call: CAPPluginCall) {
        let cardNumber = call.getString("cardNumber")
        let expiryMonth = UInt(call.getString("expiryMonth")!) ?? 0
        let expiryYear = UInt(call.getString("expiryYear")!) ?? 0
        let cvv = call.getString("cvv")
        self.charge = PSTCKTransactionParams.init()
        self.cardParams = PSTCKCardParams.init()
        self.cardParams.number = cardNumber
        self.cardParams.expMonth = expiryMonth
        self.cardParams.expYear = expiryYear
        self.cardParams.cvc = cvv
        call.resolve()
    }
    
    @objc func validateCard(_ call: CAPPluginCall) {
        // TODO: Fix issue
        let validationState = PSTCKCardValidator.validationState(forCard: cardParams)
        switch validationState {
             case .valid:
                call.resolve(["is_valid": true])
                break
             case .invalid:
                call.resolve(["is_valid": false])
                break
             case .incomplete:
                call.resolve(["is_valid": false])
                break
             default:
                call.resolve(["is_valid": false])
        }
    }
    
    @objc func addChargeParameters(_ call: CAPPluginCall) {
        let params = call.options as NSDictionary? as? NSMutableDictionary
        do {
            if params != nil {
                try self.charge.setMetadataValueDict(params!, forKey: "custom_filters")
            }
            call.resolve()
        } catch {
            call.reject("\(error)")
        }
    }
    
    @objc func getCardType(_ call: CAPPluginCall) {
        let card = PSTCKCard();
        card.number = self.cardParams.number
        card.cvc = self.cardParams.cvc
        card.expYear = self.cardParams.expYear
        card.expMonth = self.cardParams.expMonth
        call.resolve([
            "card_type": card.type
        ])
    }
    
    @objc func putChargeMetadata(_ call: CAPPluginCall) {
        let params = call.options
        params?.forEach { arg in
            let (key, value) = arg
            do {
                print(key as! String)
                try self.charge.setMetadataValue(value as! String, forKey: key as! String)
            } catch {
                call.reject("\(error)")
            }
        }
        call.resolve()
    }
    
    @objc func putChargeCustomFields(_ call: CAPPluginCall) {
        let params = call.options
        params?.forEach { arg in
            let (key, value) = arg
            do {
                print(key as! String)
                try self.charge.setCustomFieldValue(value as! String, displayedAs: key as! String)
            } catch {
                call.reject("\(error)")
                return
            }
        }
        call.resolve()
    }
    
    @objc func setChargeEmail(_ call: CAPPluginCall) {
        self.email = call.getString("email", "");
        call.resolve()
    }
    
    @objc func setChargeAmount(_ call: CAPPluginCall) {
        self.amount = UInt(call.getString("amount", "0"));
        call.resolve()
    }
    
    @objc func setAccessCode(_ call: CAPPluginCall) {
        self.charge.access_code = call.getString("accessCode", "");
        call.resolve()
    }
    
    @objc func chargeCard(_ call: CAPPluginCall) {
        self.charge.amount = self.amount
        self.charge.email = self.email
        self.charge.currency = "NGN"
        PSTCKAPIClient.shared().chargeCard(self.cardParams, forTransaction: self.charge, on: (self.bridge?.viewController)!,
               didEndWithError: { (error, reference) -> Void in
                call.reject("\(error)")
            }, didRequestValidation: { (reference) -> Void in
                // an OTP was requested, transaction has not yet succeeded
            }, didTransactionSuccess: { (reference) -> Void in
                // transaction may have succeeded, please verify on backend
                call.resolve(["reference": reference])
        })
    }

    @objc func chargeToken(_ call: CAPPluginCall) {
        self.charge.email = self.email
        self.charge.currency = "NGN"
        PSTCKAPIClient.shared().chargeCard(self.cardParams, forTransaction: self.charge, on: (self.bridge?.viewController)!,
               didEndWithError: { (error, reference) -> Void in
                call.reject("\(error)")
            }, didRequestValidation: { (reference) -> Void in
                // an OTP was requested, transaction has not yet succeeded
            }, didTransactionSuccess: { (reference) -> Void in
                // transaction may have succeeded, please verify on backend
                call.resolve(["reference": reference])
        })
    }
}
