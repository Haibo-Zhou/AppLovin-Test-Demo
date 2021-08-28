//
//  RewardedViewController.swift
//  AppLovin Test Demo
//
//  Created by HaiboZhou on 2021/8/28.
//

import AppLovinSDK
import UIKit

class RewardedAdService: NSObject {
    
    // Singleton
    static let shared = RewardedAdService()
    private override init() {}
    
    // Properties
    var rewardedAd: MARewardedAd?
    var retryAttempt = 0.0
    var reward: MAReward?
    
    func createRewardedAd()
    {
        rewardedAd = MARewardedAd.shared(withAdUnitIdentifier: ConstantNames.rewardAd_A_Unit_ID)
        guard let rewardedAd = rewardedAd else { return }
        rewardedAd.delegate = self
        
        // Load the first ad
        rewardedAd.load()
    }
}

extension RewardedAdService: MARewardedAdDelegate {
    // MARK: MAAdDelegate Protocol
    
    func didLoad(_ ad: MAAd)
    {
        // Rewarded ad is ready to be shown. '[self.rewardedAd isReady]' will now return 'YES'
        
        // Reset retry attempt
        retryAttempt = 0
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError)
    {
        // Rewarded ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        
        retryAttempt += 1
        let delaySec = pow(2.0, min(6.0, retryAttempt))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) {
            self.rewardedAd?.load()
        }
    }
    
    func didDisplay(_ ad: MAAd) {
        print("👠 Rewarded ad is displayed")
    }
    
    func didClick(_ ad: MAAd) {
        print("👠 A user click on Rewarded ad page")
    }
    
    func didHide(_ ad: MAAd)
    {
        // Rewarded ad is hidden. Pre-load the next ad
        rewardedAd?.load()
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError)
    {
        // Rewarded ad failed to display. We recommend loading the next ad
        rewardedAd?.load()
    }
    
    // MARK: MARewardedAdDelegate Protocol
    
    func didStartRewardedVideo(for ad: MAAd) {
        print("👠 Rewarded video start to play")
    }
    
    func didCompleteRewardedVideo(for ad: MAAd) {
        print("👠 Rewarded video complete play back")
    }
    
    func didRewardUser(for ad: MAAd, with reward: MAReward)
    {
        // Rewarded ad was displayed and user should receive the reward
        print("👠 Give user reward coins")
        self.reward = reward
        NotificationCenter.default.post(name: .sendRewardToUser, object: nil)
    }
}
