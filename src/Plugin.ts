import { PaystackCapacitorPlugin, Transaction } from './definitions';
import { Plugins } from '@capacitor/core';

const { PaystackCapacitor } = Plugins;

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

    setChargeEmail(email: string): Promise<any> {
        return PaystackCapacitor.setChargeEmail({email});
    }

    setAccessCode(accessCode: string): Promise<any> {
        return PaystackCapacitor.setAccessCode({accessCode});
    }

    setChargeAmount(amount: string): Promise<any> {
        return PaystackCapacitor.setChargeAmount({amount});
    }

    initialize(publicKey: string): Promise<{ initialized: boolean; }> {
        return PaystackCapacitor.initialize({publicKey});
    }

    addCard(cardNumber: string, expiryMonth: string, expiryYear: string, cvv: string): Promise<any> {
        const cardData = {
            cardNumber,
            expiryMonth,
            expiryYear,
            cvv
        }
        return PaystackCapacitor.addCard(cardData);
    }
    
    validateCard(): Promise<{ is_valid: boolean; }> {
        return PaystackCapacitor.validateCard();
    }

    chargeCard(): Promise<Transaction> { 
        return PaystackCapacitor.chargeCard();
    }

}
