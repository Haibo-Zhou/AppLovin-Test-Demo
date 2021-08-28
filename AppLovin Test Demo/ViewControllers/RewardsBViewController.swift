//
//  RewardsBViewController.swift
//  AppLovin Test Demo
//
//  Created by HaiboZhou on 2021/8/28.
//

import UIKit
import AppLovinSDK

class RewardsBViewController: UIViewController, ALAdDisplayDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Set the display delegate so we can receive the "ad:wasHiddenIn:" callback for preloading the next ad
        ALIncentivizedInterstitialAd.shared().adDisplayDelegate = self
        
        // If you want to use a load delegate, set it here. For this example, we will use nil
        ALIncentivizedInterstitialAd.preloadAndNotify(nil)
    }
    
    // Method called to show a rewarded video
    func showRewardedVideo()
    {
        if ALIncentivizedInterstitialAd.isReadyForDisplay()
        {
            // If you want to use a reward delegate, set it here. For this example, we will use nil.
            ALIncentivizedInterstitialAd.showAndNotify(nil)
        }
        else
        {
            // No rewarded video is ready. Perform failover logic, etc.
            ALIncentivizedInterstitialAd.shared().preloadAndNotify(nil)
        }
    }
    
    // MARK: - ALAdDisplayDelegate Methods
    
    func ad(_ ad: ALAd, wasClickedIn view: UIView) {}
    func ad(_ ad: ALAd, wasDisplayedIn view: UIView) {}
    
    func ad(_ ad: ALAd, wasHiddenIn view: UIView)
    {
        // The user has closed the ad. We must preload the next rewarded video.
        ALIncentivizedInterstitialAd.preloadAndNotify(nil)
    }
}
