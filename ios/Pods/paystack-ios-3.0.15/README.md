# Paystack iOS SDK
<!-- [![Travis](https://img.shields.io/travis/paystackhq/paystack-ios/master.svg?style=flat)](https://travis-ci.org/paystackhq/paystack-ios) -->
[![CocoaPods](https://img.shields.io/cocoapods/v/Paystack.svg?style=flat)](https://cocoapods.org/pods/Paystack)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/l/Paystack.svg?style=flat)](https://github.com/paystackhq/paystack-ios/blob/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/p/Paystack.svg?style=flat)](https://github.com/paystackhq/paystack-ios#)

The Paystack iOS SDK make it easy to collect your users' credit card details inside your iOS app. By charging the card immediately on our
servers, Paystack handles the bulk of PCI compliance by preventing sensitive card data from hitting your server.

This library helps collect card details on iOS, completing a charge. This shoulders the burden of PCI compliance by helping you avoid the 
need to send card data directly to your server. Instead you send to Paystack's server and get a reference which you can verify in your 
server-side code. The verify call returns an `authorization_code`. Subsequent charges can then be made using the `authorization_code`.


## Requirements
Our SDK is compatible with iOS apps supporting iOS 8.0 and above. It requires Xcode 8.0+ to build the source.

**You will also need to add Keychain Sharing entitlements for your app.**

## Integration

We've written a [guide](GUIDE.md) that explains everything from installation, to charging cards and more.

## Example app

There is an example app included in the repository:
- Paystack iOS Example shows a minimal Swift integration with our iOS SDK using PSTCKPaymentCardTextField, a native credit card UI form component we provide. It uses a small example backend to make charges.

To build and run the example apps, open `Paystack.xcworkspace` and choose the appropriate scheme.

### Getting started with the Simple iOS Example App

Note: The example app requires Xcode 8.0 to build and run.

Before you can run the app, you need to provide it with your Paystack public key.

1. If you haven't already, sign up for a [Paystack account](https://dashboard.paystack.com/#/signup) (it takes seconds). Then go to https://dashboard.paystack.co/#/settings/developer.
2. Replace the `paystackPublicKey` constant in ViewController.swift (for the Sample app) with your Test Public Key.
3. Head to https://github.com/paystackhq/sample-charge-card-backend and click "Deploy to Heroku" (you may have to sign up for a Heroku account as part of this process). Provide your Paystack test secret key for the `PAYSTACK_TEST_SECRET_KEY` field under 'Env'. Click "Deploy for Free".
4. Replace the `backendURLString` variable in the example iOS app with the app URL Heroku provides you with (e.g. "https://my-example-app.herokuapp.com") **WITHOUT THE TRAILING '/'**

### Making a test Charge

After completing the steps required above, you can (and should) test your implementation of the Paystack iOS library in your iOS app. You need the details of an actual debit/credit card to do this, so we provide ##_test cards_## for your use instead of using your own debit/credit cards. 

You will find test cards on [this Paystack documentation page](https://developers.paystack.co/docs/test-cards).

To try out the OTP flow, we have provided a test "verve" card:

```
50606 66666 66666 6666
CVV: 123
PIN: 1234
TOKEN: 123456
```

You can then view the payments in your Paystack Dashboard!

## Misc. notes

### Handling errors

See [PaystackError.h](https://github.com/paystackhq/paystack-ios/blob/master/Paystack/PublicHeaders/PaystackError.h) for a list of error codes that may be returned from the Paystack API.


