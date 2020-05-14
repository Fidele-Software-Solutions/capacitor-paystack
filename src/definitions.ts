// @ts-ignore
declare module "@capacitor/core" {
  interface PluginRegistry {
    PaystackCapacitor: PaystackCapacitorPlugin;
    // PaystackCharge: PaystackCharge;
  }
}

export enum BearerEnum {
  ACCOUNT = "ACCOUNT",
  SUBACCOUNT = "SUBACCOUNT"
}

export interface Transaction {
  reference: string;
}

export interface PaystackCard {
  // TODO: Implement public fields and methods
  [key: string]: any;
}

export interface JSONObject {
  [key: string]: any;
}

export abstract class PaystackCharge {
  abstract addParameter(key: string, value: string): void;
  abstract getAdditionalParameters(): Map<string, string>;
  abstract getAccessCode(): string;
  abstract setAccessCode(accessCode: string): PaystackCharge;
  abstract getCurrency(): string;
  abstract setCurrency(currency: string): PaystackCharge;
  abstract getPlan(): string;
  abstract setPlan(plan: string): PaystackCharge;
  abstract getTransactionCharge(): number;
  abstract setTransactionCharge(transactionCharge: number): PaystackCharge;
  abstract getSubAccount(): string;
  abstract setSubaccount(subaccount: string): PaystackCharge;
  abstract getReference(): string;
  abstract setReference(reference: string): PaystackCharge;
  abstract getBearer(): BearerEnum;
  abstract setBearer(bearer: BearerEnum): PaystackCharge;
  abstract getCard(): PaystackCard;
  abstract setCard(card: PaystackCard): PaystackCharge;
  abstract putMetadata(name: string, value: string): PaystackCharge;
  abstract putMetadata(name: string, value: JSONObject): PaystackCharge;
  abstract putCustomField(displayName: string, value: string): PaystackCharge;
  abstract getMetaData(): string;
  abstract getEmail(): string;
  abstract setEmail(email: string): PaystackCharge;
  abstract getAmount(): number;
  abstract setAmount(amount: number): PaystackCharge;
}

export interface PaystackCapacitorPlugin {
  initialize(publicKey: string): Promise<{initialized: boolean}>;
  validateCard(cardNumber: string, expiryMonth: string, expiryYear: string, cvv: string): Promise<{is_valid: boolean}>;
  chargeCard(): Promise<{reference: Transaction}>;
  addChargeParameters(parameters: {[key: string]: string}): void;
  getCardType(): Promise<{card_type: string}>;
  putChargeMetadata(metadata: {[key: string]: string}): void;
  putChargeCustomFields(customFields: {[key: string]: string}): void;
  setChargeEmail(email: string): void;
  setChargeAmount(amount: string): void;
}
