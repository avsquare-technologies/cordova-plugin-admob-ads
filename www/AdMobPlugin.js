var exec = require('cordova/exec');

var AdMobPlugin = {
    showBannerAd: function(adSize, position, successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'AdMobPlugin', 'showBannerAd', [adSize, position]);
    },
    showInterstitialAd: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'AdMobPlugin', 'showInterstitialAd', []);
    }
};

module.exports = AdMobPlugin;
