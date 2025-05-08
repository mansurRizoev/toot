package com.mycompany.plugins.example;


import android.app.Activity;
import android.content.Intent;

import androidx.activity.result.ActivityResult;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.ActivityCallback;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "Tooti")
public class TootiPlugin extends Plugin {

    private Tooti implementation = new Tooti();

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");
        String fromGallery = call.getString("fromGallery");
        Intent intent = new Intent(getActivity(), bmQR.class);
        intent.putExtra("LNG", value);
        intent.putExtra("fromGallery", fromGallery);

        startActivityForResult(call, intent, "handleQrResult");
    }
    @ActivityCallback
    private void handleQrResult(PluginCall call,  ActivityResult result) {
        if (result.getResultCode() == Activity.RESULT_OK) {
              Intent data = result.getData();
            String qrCode = data.getStringExtra("QrResult");

            JSObject ret = new JSObject();
            ret.put("result", qrCode);
            call.resolve(ret);
        } else {
            call.reject("bmQr Activity было отменено");
        }
    }
}
