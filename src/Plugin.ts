import { PaystackCapacitorPlugin, Transaction } from './definitions';
import { Plugins } from '@capacitor/core';

const { PaystackCapacitor } = Plugins;

export class PaystackPlugin implements PaystackCapacitorPlugin {

    addChargeParameters(parameters: { [key: string]: string; }): void {
        return PaystackCapacitor.addChargeParameters(parameters);
    }

    getCardType(): Promise<{ card_type: string; }> {
        return PaystackCapacitor.getCardType();
    }

    putChargeMetadata(metadata: { [key: string]: string; }): void {
        return PaystackCapacitor.putChargeMetadata(metadata);
    }

    putChargeCustomFields(customFields: { [key: string]: string; }): void {
        return PaystackCapacitor.putChargeCustomFields(customFields);
    }

    setChargeEmail(email: string): void {
        return PaystackCapacitor.setChargeEmail({email});
    }

    setAccessCode(accessCode: string): void {
        return PaystackCapacitor.setAccessCode({accessCode});
    }

    setChargeAmount(amount: string): void {
        return PaystackCapacitor.setChargeAmount({amount});
    }

    initialize(publicKey: string): Promise<{ initialized: boolean; }> {
        return PaystackCapacitor.initialize({publicKey});
    }

    validateCard(cardNumber: string, expiryMonth: string, expiryYear: string, cvv: string): Promise<{ is_valid: boolean; }> {
        const cardData = {
            cardNumber,
            expiryMonth,
            expiryYear,
            cvv
        }
        return PaystackCapacitor.validateCard(cardData);
    }

    chargeCard(): Promise<{ reference: Transaction; }> { 
        return PaystackCapacitor.chargeCard();
    }

}
