package com.example.admob;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.InterstitialAd;

public class AdMobPlugin extends CordovaPlugin {

    private AdView adView;
    private InterstitialAd interstitialAd;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("showBannerAd")) {
            String adSize = args.getString(0); // e.g., "BANNER"
            String position = args.getString(1); // e.g., "TOP"
            showBannerAd(adSize, position);
            callbackContext.success("Banner Ad shown successfully");
            return true;
        } else if (action.equals("showInterstitialAd")) {
            showInterstitialAd();
            callbackContext.success("Interstitial Ad shown successfully");
            return true;
        }
        return false;
    }

    private void showBannerAd(String adSize, String position) {
        cordova.getActivity().runOnUiThread(() -> {
            if (adView != null) {
                adView.destroy();
            }

            adView = new AdView(cordova.getActivity());
            adView.setAdSize(getAdSize(adSize));
            adView.setAdUnitId("YOUR_BANNER_AD_UNIT_ID");

            AdRequest adRequest = new AdRequest.Builder().build();
            adView.loadAd(adRequest);

            // Add adView to the layout based on the position parameter
            // Handle positions like "TOP", "BOTTOM", "CENTER", etc.
            // Add code to position the adView within the layout

            // For example, if position is "TOP":
            // ((ViewGroup) webView.getView().getParent()).addView(adView, params);
        });
    }

    private void showInterstitialAd() {
        cordova.getActivity().runOnUiThread(() -> {
            if (interstitialAd != null && interstitialAd.isLoaded()) {
                interstitialAd.show();
            } else {
                interstitialAd = new InterstitialAd(cordova.getActivity());
                interstitialAd.setAdUnitId("YOUR_INTERSTITIAL_AD_UNIT_ID");

                AdRequest adRequest = new AdRequest.Builder().build();
                interstitialAd.loadAd(adRequest);
            }
        });
    }

    private AdSize getAdSize(String adSize) {
        switch (adSize) {
            case "BANNER":
                return AdSize.BANNER;
            case "LARGE_BANNER":
                return AdSize.LARGE_BANNER;
            case "MEDIUM_RECTANGLE":
                return AdSize.MEDIUM_RECTANGLE;
            // Add more ad sizes as needed
            default:
                return AdSize.BANNER;
        }
    }
}
