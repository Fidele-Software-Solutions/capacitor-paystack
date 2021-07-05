import { PaystackCapacitorPlugin, Transaction } from './definitions';
import { registerPlugin } from '@capacitor/core';

const PaystackCapacitor = registerPlugin<PaystackCapacitorPlugin>('PaystackCapacitorPlugin', {
    // web: () => import('./web').then(m => new m.MyCoolPluginWeb()),
    // electron: () => ("./electron").then(m => new m.MyCoolPluginElectron())
  });
// const { PaystackCapacitor } = Plugins;

export class PaystackPlugin implements PaystackCapacitorPlugin {

    addChargeParameters(parameters: { [key: string]: string; }): Promise<any> {
        return PaystackCapacitor.addChargeParameters(parameters);
    }

    getCardType(): Promise<{ card_type: string; }> {
        return PaystackCapacitor.getCardType();
    }

    putChargeMetadata(metadata: { [key: string]: string; }): Promise<any> {
        return PaystackCapacitor.putChargeMetadata(metadata);
    }

    putChargeCustomFields(customFields: { [key: string]: string; }): Promise<any> {
        return PaystackCapacitor.putChargeCustomFields(customFields);
    }

    setChargeEmail(payload: {email: string}): Promise<any> {
        return PaystackCapacitor.setChargeEmail(payload);
    }

    setAccessCode(payload: {accessCode: string}): Promise<any> {
        return PaystackCapacitor.setAccessCode(payload);
    }

    setChargeAmount(payload: {amount: string}): Promise<any> {
        return PaystackCapacitor.setChargeAmount(payload);
    }

    initialize(payload: {publicKey: string}): Promise<{ initialized: boolean; }> {
        return PaystackCapacitor.initialize(payload);
    }

    addCard(payload: {cardNumber: string, expiryMonth: string, expiryYear: string, cvv: string}): Promise<any> {
        const cardData = {
            cardNumber: payload.cardNumber,
            expiryMonth: payload.expiryMonth,
            expiryYear: payload.expiryYear,
            cvv: payload.cvv
        }
        return PaystackCapacitor.addCard(cardData);
    }
    
    validateCard(): Promise<{ is_valid: boolean; }> {
        return PaystackCapacitor.validateCard();
    }

    chargeCard(): Promise<Transaction> { 
        return PaystackCapacitor.chargeCard();
    }

    chargeToken(): Promise<Transaction> { 
        return PaystackCapacitor.chargeToken();
    }

}
