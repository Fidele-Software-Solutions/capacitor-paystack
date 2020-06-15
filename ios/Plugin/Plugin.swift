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
    var cardParams: PSTCKCardParams! //.init()
    var charge: PSTCKTransactionParams!
    
    func getCallValue<T>(_ name: String, _ call: CAPPluginCall, _ type: T) -> T? {
//        return call.get(name, MyAny(), nil) as? T
        return nil
    }
    
    @objc func initialize(_ call: CAPPluginCall) {
        self.publicKey = call.getString("publicKey", "");
        Paystack.setDefaultPublicKey(self.publicKey)
        self.cardParams = nil
        self.charge = nil
        call.success([
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
        call.success()
    }
    
    @objc func validateCard(_ call: CAPPluginCall) {
        // TODO: Fix issue
        return call.error("This functionality is currently not available on iOS")
//        call.success([
//            "is_valid": false // self.cardParams.validateCardReturningError() //self.card
//        ])
    }
    
    @objc func addChargeParameters(_ call: CAPPluginCall) {
        let params = call.options as NSDictionary? as? NSMutableDictionary
        do {
            try self.charge.setMetadataValueDict(params!, forKey: "custom_filters")
            call.success()
        } catch {
            call.error("\(error)")
        }
    }
    
    @objc func getCardType(_ call: CAPPluginCall) {
        let card = PSTCKCard();
        card.number = self.cardParams.number
        card.cvc = self.cardParams.cvc
        card.expYear = self.cardParams.expYear
        card.expMonth = self.cardParams.expMonth
        call.success([
            "card_type": card.type
        ])
    }
    
    @objc func putChargeMetadata(_ call: CAPPluginCall) {
        let params = call.options
        params?.forEach { arg in
            let (key, value) = arg
            do {
                try self.charge.setMetadataValue(value as! String, forKey: key as! String)
                    call.success()
            } catch {
                call.error("\(error)")
            }
        }
    }
    
    @objc func putChargeCustomFields(_ call: CAPPluginCall) {
        let params = call.options
        params?.forEach { arg in
            let (key, value) = arg
            do {
                try self.charge.setCustomFieldValue(key as! String, displayedAs: value as! String)
                    call.success()
            } catch {
                call.error("\(error)")
            }
        }
    }
    
    
}

struct MyAny: Any {}
