#import <Cordova/CDV.h>
@import GoogleMobileAds;

@interface AdMobPlugin : CDVPlugin <GADBannerViewDelegate, GADInterstitialDelegate>

@property(nonatomic, strong) GADBannerView *bannerView;
@property(nonatomic, strong) GADInterstitialAd *interstitialAd;

- (void)showBannerAd:(CDVInvokedUrlCommand*)command;
- (void)showInterstitialAd:(CDVInvokedUrlCommand*)command;

@end

@implementation AdMobPlugin

- (void)pluginInitialize {
    [GADMobileAds.sharedInstance startWithCompletionHandler:nil];
}

- (void)showBannerAd:(CDVInvokedUrlCommand*)command {
    NSString *adSize = [command.arguments objectAtIndex:0];
    NSString *position = [command.arguments objectAtIndex:1];

    [self.commandDelegate runInBackground:^{
        [self showBannerAdWithSize:adSize position:position];
    }];
}

- (void)showInterstitialAd:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        [self showInterstitialAd];
    }];
}

- (void)showBannerAdWithSize:(NSString *)adSize position:(NSString *)position {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.bannerView) {
            [self.bannerView removeFromSuperview];
            self.bannerView = nil;
        }

        self.bannerView = [[GADBannerView alloc] initWithAdSize:[self getAdSizeFromString:adSize]];
        self.bannerView.adUnitID = @"YOUR_BANNER_AD_UNIT_ID";
        self.bannerView.delegate = self;
        
        GADRequest *request = [GADRequest request];
        [self.bannerView loadRequest:request];

        // Add bannerView to the view based on the position parameter
        // Handle positions like "TOP", "BOTTOM", "CENTER", etc.
        // Add code to position the bannerView within the view

        // For example, if position is "TOP":
        // [self.webView.superview addSubview:self.bannerView];
    });
}

- (void)showInterstitialAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.interstitialAd && self.interstitialAd.isReady) {
            [self.interstitialAd presentFromRootViewController:self.viewController];
        } else {
            self.interstitialAd = [[GADInterstitialAd alloc] initWithAdUnitID:@"YOUR_INTERSTITIAL_AD_UNIT_ID"];
            [self.interstitialAd loadRequest:[GADRequest request]];
        }
    });
}

- (GADAdSize)getAdSizeFromString:(NSString *)adSize {
    if ([adSize isEqualToString:@"BANNER"]) {
        return kGADAdSizeBanner;
    } else if ([adSize isEqualToString:@"LARGE_BANNER"]) {
        return kGADAdSizeLargeBanner;
    } else if ([adSize isEqualToString:@"MEDIUM_RECTANGLE"]) {
        return kGADAdSizeMediumRectangle;
    }
    // Add more ad sizes as needed
    else {
        return kGADAdSizeBanner;
    }
}

@end
