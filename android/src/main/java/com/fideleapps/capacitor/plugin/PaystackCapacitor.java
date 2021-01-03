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
        try {
            this.publicKey = call.getString("publicKey");
            PaystackSdk.initialize(getContext());
            PaystackSdk.setPublicKey(publicKey);
            this.card = null;
            this.charge = null;
            JSObject ret = new JSObject();
            ret.put("initialized", true);
            call.success(ret);
        } catch (Exception ex) {
            call.errorCallback(ex.getMessage());
        }
    }

    @PluginMethod()
    public void addCard(PluginCall call) {
        try {
            String cardNumber = call.getString("cardNumber");
            int expiryMonth = Integer.parseInt(call.getString("expiryMonth"));
            int expiryYear = Integer.parseInt(call.getString("expiryYear"));
            String cvv = call.getString("cvv");
            this.charge = new Charge();
            this.card = new Card(cardNumber, expiryMonth, expiryYear, cvv);
            call.success();
        } catch (Exception ex) {
            call.errorCallback(ex.getMessage());
        }

    }

    @PluginMethod()
    public void validateCard(PluginCall call) {
        try {
            JSObject ret = new JSObject();
            ret.put("is_valid", card.isValid());
            call.success(ret);
        } catch (Exception ex) {
            call.errorCallback(ex.getMessage());
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @PluginMethod()
    public void addChargeParameters(PluginCall call) {
        final JSObject params = call.getData();
        params.keys().forEachRemaining(new Consumer<String>() {
            @Override
            public void accept(String paramKey) {
                try {
                    PaystackCapacitor.this.charge.addParameter(paramKey, params.getString(paramKey));
                } catch (NullPointerException ex) {
                    call.errorCallback(ex.getMessage());
                    return;
                }

            }
        });
        call.success();
    }

    @PluginMethod()
    public void getCardType(PluginCall call) {
        try {
            JSObject ret = new JSObject();
            ret.put("card_type", card.getType());
            call.success(ret);
        } catch (NullPointerException ex) {
            call.errorCallback(ex.getMessage());
        }

    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @PluginMethod()
    public void putChargeMetadata(final PluginCall call) {
        final JSObject params = call.getData();
        params.keys().forEachRemaining(new Consumer<String>() {
            @Override
            public void accept(String paramKey) {
                try {
                    PaystackCapacitor.this.charge.putMetadata(paramKey, params.getString(paramKey));
                } catch (Exception e) {
                    call.errorCallback(e.getMessage());
                }
            }
        });
        call.success();
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @PluginMethod()
    public void putChargeCustomFields(final PluginCall call) {
        final JSObject params = call.getData();
        params.keys().forEachRemaining(new Consumer<String>() {
            @Override
            public void accept(String paramKey) {
                try {
                    PaystackCapacitor.this.charge.putCustomField(paramKey, params.getString(paramKey));
                } catch (Exception e) {
                    call.errorCallback(e.getMessage());
                }
            }
        });
        call.success();
    }

    @PluginMethod()
    public void setChargeEmail(PluginCall call) {
        try {
            this.email = call.getString("email");
            call.success();
        } catch (Exception ex) {
            call.errorCallback(ex.getMessage());
        }
    }

    @PluginMethod()
    public void setChargeAmount(PluginCall call) {
        try {
            this.amount = Integer.parseInt(call.getString("amount"));
            call.success();
        } catch (Exception ex) {
            call.errorCallback(ex.getMessage());
        }
    }

    @PluginMethod()
    public void setAccessCode(PluginCall call) {
        try {
            String accessCode = call.getString("accessCode");
            charge.setAccessCode(accessCode);
            call.success();
        } catch (NullPointerException ex) {
            call.errorCallback(ex.getMessage());
        }

    }

    @PluginMethod()
    public void chargeCard(final PluginCall call) {
        try {
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
                    call.errorCallback(error.getMessage());
                }
            });
        } catch (Exception ex) {
            call.errorCallback(ex.getMessage());
        }
    }

    @PluginMethod()
    public void chargeToken(final PluginCall call) {
        try {
            charge.setCard(this.card); //sets the card to charge
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
                    call.errorCallback(error.getMessage());
                }
            });
        } catch (Exception ex) {
            call.errorCallback(ex.getMessage());
        }
    }
}
