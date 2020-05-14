import { WebPlugin } from '@capacitor/core';
import { PaystackCapacitorPlugin } from './definitions';

export class PaystackCapacitorWeb extends WebPlugin implements PaystackCapacitorPlugin {
  constructor() {
    super({
      name: 'PaystackCapacitor',
      platforms: ['web']
    });
  }
  initialize(publicKey: string): Promise<{ initialized: boolean; }> {
    throw new Error("Method not implemented.");
  }
  validateCard(cardNumber: string, expiryMonth: string, expiryYear: string, cvv: string): Promise<{ is_valid: boolean; }> {
    throw new Error("Method not implemented.");
  }
  chargeCard(): Promise<{ reference: import("./definitions").Transaction; }> {
    throw new Error("Method not implemented.");
  }

  async echo(options: { value: string }): Promise<{value: string}> {
    console.log('ECHO', options);
    return options;
  }
}

const PaystackCapacitor = new PaystackCapacitorWeb();

export { PaystackCapacitor };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(PaystackCapacitor);
