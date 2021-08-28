//
//  ALAdMob.swift
//  AppLovin Test Demo
//
//  Created by HaiboZhou on 2021/8/28.
//

import AppLovinSDK
import UIKit

class InterstitialAdService: NSObject {
    
    // Singleton
    static let shared = InterstitialAdService()
    private override init() {}
    
    // Properties
    var interstitialAd: MAInterstitialAd?
    var retryAttempt = 0.0
    
    func createInterstitialAd() {
        interstitialAd = MAInterstitialAd(adUnitIdentifier: ConstantNames.interstitialAdUnit_ID)
        guard let interstitialAd = interstitialAd else { return }
        interstitialAd.delegate = self
        
        // Load the first ad
        interstitialAd.load()
    }
    
    func showMobileAd(from vc: UIViewController) {
        if let ad = self.interstitialAd {
            ad.show()
        } else {
            print("Ad wasn't ready")
        }
    }
}

extension InterstitialAdService: MAAdDelegate {
    // MARK: MAAdDelegate Protocol
    
    func didLoad(_ ad: MAAd)
    {
        // Interstitial ad is ready to be shown. 'interstitialAd.isReady' will now return 'true'
        
        // Reset retry attempt
        retryAttempt = 0
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError)
    {
        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        
        retryAttempt += 1
        let delaySec = pow(2.0, min(6.0, retryAttempt))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) {
            self.interstitialAd?.load()
        }
    }
    
    func didDisplay(_ ad: MAAd) {
        print("🌈 interstitial ad is displayed")
    }
    
    func didClick(_ ad: MAAd) {
        print("🌈 A user has clicked on the ad page")
    }
    
    func didHide(_ ad: MAAd)
    {
        // Interstitial ad is hidden. Pre-load the next ad
        interstitialAd?.load()
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError)
    {
        // Interstitial ad failed to display. We recommend loading the next ad
        interstitialAd?.load()
    }
}
