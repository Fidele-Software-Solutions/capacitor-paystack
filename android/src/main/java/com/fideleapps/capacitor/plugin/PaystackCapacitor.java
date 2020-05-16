package com.fideleapps.capacitor.plugin;

import android.os.Build;

import androidx.annotation.RequiresApi;

import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

import org.json.JSONException;

import java.util.function.Consumer;

import co.paystack.android.Paystack;
import co.paystack.android.PaystackSdk;
import co.paystack.android.Transaction;
import co.paystack.android.model.Card;
import co.paystack.android.model.Charge;

@NativePlugin()
public class PaystackCapacitor extends Plugin {

    Card card;
    String publicKey;
    private String email;
    private int amount;
    private Charge charge;

    @PluginMethod()
    public void initialize(PluginCall call) {
        this.publicKey = call.getString("publicKey");
        this.card = null;
        this.charge = new Charge();
        PaystackSdk.initialize(getContext());
        PaystackSdk.setPublicKey(publicKey);

        JSObject ret = new JSObject();
        ret.put("initialized", true);
        call.success(ret);
    }

    @PluginMethod()
    public void validateCard(PluginCall call) {
        String cardNumber = call.getString("cardNumber");
        int expiryMonth = Integer.parseInt(call.getString("expiryMonth"));
        int expiryYear = Integer.parseInt(call.getString("expiryYear"));
        String cvv = call.getString("cvv");

        this.card = new Card(cardNumber, expiryMonth, expiryYear, cvv);
        JSObject ret = new JSObject();
        ret.put("is_valid", card.isValid());
        call.success(ret);
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @PluginMethod()
    public void addChargeParameters(PluginCall call) throws NullPointerException {
        final JSObject params = call.getData();
        params.keys().forEachRemaining(new Consumer<String>() {
            @Override
            public void accept(String paramKey) {
                PaystackCapacitor.this.charge.addParameter(paramKey, params.getString(paramKey));
            }
        });
        call.success();
    }

    @PluginMethod()
    public void getCardType(PluginCall call) throws NullPointerException {
        if(this.card == null) {
            throw new NullPointerException();
        }
        JSObject ret = new JSObject();
        ret.put("card_type", card.getType());
        call.success(ret);
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @PluginMethod()
    public void putChargeMetadata(final PluginCall call) throws JSONException, NullPointerException {
        final JSObject params = call.getData();
        params.keys().forEachRemaining(new Consumer<String>() {
            @Override
            public void accept(String paramKey) {
                try {
                    PaystackCapacitor.this.charge.putMetadata(paramKey, params.getString(paramKey));
                } catch (JSONException e) {
                    call.errorCallback(e.getMessage());
                }
            }
        });
        call.success();
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @PluginMethod()
    public void putChargeCustomFields(final PluginCall call) throws JSONException, NullPointerException {
        final JSObject params = call.getData();
        params.keys().forEachRemaining(new Consumer<String>() {
            @Override
            public void accept(String paramKey) {
                try {
                    PaystackCapacitor.this.charge.putCustomField(paramKey, params.getString(paramKey));
                } catch (JSONException e) {
                    call.errorCallback(e.getMessage());
                }
            }
        });
        call.success();
    }

    @PluginMethod()
    public void setChargeEmail(PluginCall call) {
        this.email = call.getString("email");
        call.success();
    }

    @PluginMethod()
    public void setChargeAmount(PluginCall call) {
        this.amount = Integer.parseInt(call.getString("amount"));
        call.success();
    }

    @PluginMethod()
    public void chargeCard(final PluginCall call) throws NullPointerException {
        if(this.card == null) {
            throw new NullPointerException();
        }
        this.charge = new Charge();
        charge.setCard(this.card); //sets the card to charge
        charge.setAmount(this.amount);
        charge.setEmail(this.email);
        PaystackSdk.chargeCard(getActivity(), charge, new Paystack.TransactionCallback() {
            @Override
            public void onSuccess(Transaction transaction) {
                JSObject ret = new JSObject();
                ret.put("reference", transaction.getReference());
                call.success(ret);
            }

            @Override
            public void beforeValidate(Transaction transaction) {
            }

            @Override
            public void onError(Throwable error, Transaction transaction) {
                call.errorCallback(error.toString());
            }
        });
    }
}
