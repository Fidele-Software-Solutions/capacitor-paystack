# Paystack Capacitor Plugin
A Paystack capacitor plugin for Android and iOS

## Getting Started

This plugin enables seamless integration of the [Paystack SDK](https://github.com/PaystackHQ/paystack-android) into a [Capacitor](https://capacitor.ionicframework.com/) application.

The project is still under active development and will soon be available on iOS. Also, pull requests are welcome.

### Installation

To install this plugin, run the NPM command below in your Capacitor project's root folder
```
npm i capacitor-paystack-plugin
```

Then open your project in Android Studio with
```
npx cap open android
```

or XCode with
```
npx cap open ios
```

### Configuration
In your Android Studio project, add the following line to the list of plugins in your project, if any
```
...
add(PaystackCapacitor.class);
```

In your project folder, run the command below to update your Android Studio/XCode project
```
npx cap sync
```

Setup complete!

### Code example
To charge a card, 
```
//Import the paystack plugin
import { PaystackPlugin } from '@bot101/capacitor-paystack-plugin';

//Create a paystack object
const paystack: PaystackPlugin; = new PaystackPlugin();

//Initialize the SDK with your Paystack public key (found in your account dashboard)
await this.paystack.initialize({publicKey: "pk_public key here"});

//Add customer card information
await this.paystack.addCard({
  cardNumber: String(cardNumber),
  expiryMonth: String(expiryMonth),
  expiryYear: String(expiryYear),
  cvv: String(cvv)
});

//Add the email to charge
await this.paystack.setChargeEmail("email@address.com");

//Set the amount to charge the card (in kobo)
await this.paystack.setChargeAmount({amount: '1000000'});

//Optionally add custom fields, metadata and charge parameters (more information in the Paystack docs)
await this.paystack.putChargeCustomFields({customField1: "field1", customField2: "field2"});
await this.paystack.putChargeMetadata({metaData1: "meta1", metaData2: "meta2"});
await this.paystack.addChargeParameters({param1: "param1", param2: "param2"});

//Call chargeCard to charge the card
const chargeResponse = await this.paystack.chargeCard();
return chargeResponse.reference;
```

To charge an access code

```
//After initializing the plugin as detailed above

//Add customer card information
await this.paystack.addCard(cardNum, expiryMonth, expiryYear, cvv);

//Set the access code retrieved from your web server
await this.paystack.setAccessCode({accessCode});

//Call chargeCard to charge the card
const chargeResponse = await this.paystack.chargeCard();
return chargeResponse.reference;
```

To get a card type
```
const cardInfo = await this.paystack.getCardType()
console.log(cardInfo.card_type) //"Visa", "Mastercard", e.t.c
```
## Note
`validateCard()` is currently unavailable on iOS

## Running the tests
Tests are not yet setup

## Deployment
Build your application and you are good to go!

## Versioning
Yet to setup

## Author

* **Okafor Ikenna** - [Github](https://bot101.github.io)
## License

This project is licensed under the MIT License

