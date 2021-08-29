//
//  BannerViewController.swift
//  AppLovin Test Demo
//
//  Created by HaiboZhou on 2021/8/28.
//

import AppLovinSDK
import UIKit

class BannerViewController: UIViewController {
    
    lazy var adView: MAAdView = {
        let adView = MAAdView(adUnitIdentifier: ConstantNames.bannerAdUnit_ID)
        adView.translatesAutoresizingMaskIntoConstraints = false
        return adView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = ConstantNames.bannerVCTitle
        setBackgroundImage(imageName: ConstantNames.bannerVCBgImage)
        adView.delegate = self
        
        // configure UI layout
        setViews()
        
        // load banner ad
        adView.loadAd()
        // show banner ad and set it to auto refresh mode
        adView.isHidden = false
        adView.startAutoRefresh()
    }
    
    func setViews() {
        view.addSubview(adView)
        
        // give banner view height per device type, aka iPad or iPhone.
        let height: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90.0 : 50.0
        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            adView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
            adView.bottomAnchor.constraint(equalTo: g.bottomAnchor),
            adView.widthAnchor.constraint(equalTo: g.widthAnchor),
            adView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}

extension BannerViewController: MAAdViewAdDelegate {
    // MARK: MAAdDelegate Protocol
    
    func didLoad(_ ad: MAAd) {
        print("🍎 Banner ad is loaded")
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        print("🍎 Failed to load ad, \(error), \(error.debugDescription)")
    }
    
    func didClick(_ ad: MAAd) {
        print("🍎 A user click on this ad")
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        print("🍎 Failed to display ad, \(error), \(error.debugDescription)")
    }
    
    
    // MARK: MAAdViewAdDelegate Protocol
    
    func didExpand(_ ad: MAAd) {
        print("🍎 Current banner ad is expanded")
    }
    
    func didCollapse(_ ad: MAAd) {
        print("🍎 Current banner ad is collapsed")
    }
    
    
    // MARK: Deprecated Callbacks
    
    func didDisplay(_ ad: MAAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }
    func didHide(_ ad: MAAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }
}
