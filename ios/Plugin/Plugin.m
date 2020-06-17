#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(PaystackCapacitor, "PaystackCapacitor",
           CAP_PLUGIN_METHOD(initialize, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(addCard, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(validateCard, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(addChargeParameters, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getCardType, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(putChargeMetadata, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(putChargeCustomFields, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setChargeEmail, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setChargeAmount, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setAccessCode, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(chargeCard, CAPPluginReturnPromise);

)
