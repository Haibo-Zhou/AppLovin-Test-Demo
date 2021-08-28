////
////  BannerAdService.swift
////  AppLovin Test Demo
////
////  Created by HaiboZhou on 2021/8/28.
////
//
//import AppLovinSDK
//import UIKit
//
//class BannerAdService: NSObject {
//    
//    // Singleton
//    static let shared = BannerAdService()
//    private override init() {}
//    
//    // Properties
//    var adView: MAAdView?
//    
//    func createBannerAd() {
//        adView = MAAdView(adUnitIdentifier: ConstantNames.bannerAdUnit_ID)
//        guard let adView = adView else { return }
//        adView.delegate = self
//        
//        // Load the first ad
//        adView.loadAd()
//    }
//    
//    func showMobileAd(from vc: UIViewController) {
//        if let ad = self.adView {
////            ad.show()
//        } else {
//            print("Ad wasn't ready")
//        }
//    }
//}
//
//extension BannerAdService: MAAdViewAdDelegate {
//    // MARK: MAAdDelegate Protocol
//    
//    func didLoad(_ ad: MAAd) {
//        print("🍎 Banner ad is loaded")
//    }
//    
//    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
//        print("🍎 Failed to load ad, \(error), \(error.debugDescription)")
//    }
//    
//    func didClick(_ ad: MAAd) {
//        print("🍎 A user click on this ad")
//    }
//    
//    func didFail(toDisplay ad: MAAd, withError error: MAError) {
//        print("🍎 Failed to display ad, \(error), \(error.debugDescription)")
//    }
//    
//    
//    // MARK: MAAdViewAdDelegate Protocol
//    
//    func didExpand(_ ad: MAAd) {
//        print("🍎 Current banner ad is expanded")
//    }
//    
//    func didCollapse(_ ad: MAAd) {
//        print("🍎 Current banner ad is collapsed")
//    }
//    
//    
//    // MARK: Deprecated Callbacks
//    
//    func didDisplay(_ ad: MAAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }
//    func didHide(_ ad: MAAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }
//}
