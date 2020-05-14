import { Plugins } from "@capacitor/core";
import { PaystackCharge } from "./definitions";

const { PaystackChargeImpl } = Plugins;

export class PaystackChargeModel extends PaystackCharge {
    addParameter(key: string, value: string): void {
        return PaystackChargeImpl.addParameter();
    }
    getAdditionalParameters(): Map<string, string> {
        return PaystackChargeImpl.getAdditionalParameters();
    }
    getAccessCode(): string {
        return PaystackChargeImpl.getAccessCode();
    }
    setAccessCode(accessCode: string): PaystackCharge {
        return PaystackChargeImpl.setAccessCode();
    }
    getCurrency(): string {
        return PaystackChargeImpl.getCurrency();
    }
    setCurrency(currency: string): PaystackCharge {
        return PaystackChargeImpl.setCurrency();
    }
    getPlan(): string {
        return PaystackChargeImpl.getPlan();
    }
    setPlan(plan: string): PaystackCharge {
        return PaystackChargeImpl.setPlan();
    }
    getTransactionCharge(): number {
        return PaystackChargeImpl.getTransactionCharge();
    }
    setTransactionCharge(transactionCharge: number): PaystackCharge {
        return PaystackChargeImpl.setTransactionCharge();
    }
    getSubAccount(): string {
        return PaystackChargeImpl.getSubAccount();
    }
    setSubaccount(subaccount: string): PaystackCharge {
        return PaystackChargeImpl.setSubaccount();
    }
    getReference(): string {
        return PaystackChargeImpl.getReference();
    }
    setReference(reference: string): PaystackCharge {
        return PaystackChargeImpl.setReference();
    }
    getBearer(): import("./definitions").BearerEnum {
        return PaystackChargeImpl.getBearer();
    }
    setBearer(bearer: import("./definitions").BearerEnum): PaystackCharge {
        return PaystackChargeImpl.setBearer();
    }
    getCard(): import("./definitions").PaystackCard {
        return PaystackChargeImpl.getCard();
    }
    setCard(card: import("./definitions").PaystackCard): PaystackCharge {
        return PaystackChargeImpl.setCard();
    }
    putMetadata(name: string, value: string): PaystackCharge;
    putMetadata(name: string, value: import("./definitions").JSONObject): PaystackCharge;
    putMetadata(name: any, value: any) {
        return PaystackChargeImpl.putMetadata();
    }
    putCustomField(displayName: string, value: string): PaystackCharge {
        return PaystackChargeImpl.putCustomField();
    }
    getMetaData(): string {
        return PaystackChargeImpl.getMetaData();
    }
    getEmail(): string {
        return PaystackChargeImpl.getEmail();
    }
    setEmail(email: string): PaystackCharge {
        return PaystackChargeImpl.setEmail();
    }
    getAmount(): number {
        return PaystackChargeImpl.getAmount();
    }
    setAmount(amount: number): PaystackCharge {
        return PaystackChargeImpl.setAmount();
    }

}