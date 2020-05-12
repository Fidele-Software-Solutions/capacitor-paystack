import { WebPlugin } from '@capacitor/core';
import { PaystackCapacitorPlugin } from './definitions';

export class PaystackCapacitorWeb extends WebPlugin implements PaystackCapacitorPlugin {
  constructor() {
    super({
      name: 'PaystackCapacitor',
      platforms: ['web']
    });
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
