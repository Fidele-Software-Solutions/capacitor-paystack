package com.fideleapps.capacitor.plugin;

import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

@NativePlugin()
public class PaystackCapacitor extends Plugin {

    Card card;

    @PluginMethod()
    public void initialize(PluginCall call) {
        String publicKey = call.getString("publicKey");

        this.card = null;
        PaystackSdk.initialize(getApplicationContext());
        PaystackSdk.setPublicKey(publicKey);

        JSObject ret = new JSObject();
        ret.put("initialized", true);
        call.success(ret);
    }

    @PluginMethod()
    public void validateCard(PluginCall call) {
        // This sets up the card and check for validity
        String cardNumber = call.getString("cardNumber");
        int expiryMonth = Integer.parseInt(call.getString("expiryMonth")); // 11; //any month in the future
        int expiryYear = Integer.parseInt(call.getString("expiryYear")); // 18; // any year in the future. '2018' would work also! 
        String cvv = call.getString("cvv"); // "408";  // cvv of the test card
    
        Card card = new Card(cardNumber, expiryMonth, expiryYear, cvv);
        JSObject ret = new JSObject();
        ret.put("is_valid", card.isValid());
        call.success(ret);
    }

    @PluginMethod()
    public void chargeCard(PluginCall call) {

        //create a Charge object
        Charge charge = new Charge(); 
        charge.setCard(this.card); //sets the card to charge
  
        PaystackSdk.chargeCard(MainActivity.this, charge, new Paystack.TransactionCallback() {
            @Override
            public void onSuccess(Transaction transaction) {
                // This is called only after transaction is deemed successful.
                // Retrieve the transaction, and send its reference to your server
                // for verification.
                JSObject ret = new JSObject();
                ret.put("transaction", transaction.toString());
                call.success(ret);
            }

            @Override
            public void beforeValidate(Transaction transaction) {
                // This is called only before requesting OTP.
                // Save reference so you may send to server. If
                // error occurs with OTP, you should still verify on server.
            }

            @Override
            public void onError(Throwable error, Transaction transaction) {
                //handle error here
                JSObject ret = new JSObject();
                ret.put("error", error.toString());
                call.error(err)
            }
        }
    }
}
