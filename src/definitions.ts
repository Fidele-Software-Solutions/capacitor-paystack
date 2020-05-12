declare module "@capacitor/core" {
  interface PluginRegistry {
    PaystackCapacitor: PaystackCapacitorPlugin;
  }
}

interface Transaction {
  [key: string]: any;
}

export interface PaystackCapacitorPlugin {
  initialize(publicKey: string): Promise<{initialized: boolean}>;
  validateCard(publicKey: string): Promise<{is_valid: boolean}>;
  chargeCard(): Promise<{transaction: Transaction}>;
}
