//
//  RewardsViewController.swift
//  AppLovin Test Demo
//
//  Created by HaiboZhou on 2021/8/28.
//


/* The settings of reward amount per video is "20", currency is "Coin".
    Game logic:
        1. When game is over, the user earn 1 coin.
        2. After the user has watched a reward video, he/she would earn 20 coins
*/

import UIKit

class RewardsViewController: UIViewController {
    
    enum GameState: NSInteger {
        case notStarted
        case playing
        case paused
        case ended
    }
    
    // Constant for coin rewards.
    let gameOverReward = 1
    
    // Starting time for game counter.
    let gameLength = 10
    
    // Number of coins the user has earned.
    var coinCount: Int = 0 {
        didSet {
            coinCountLabel.text = "Coins: \(self.coinCount)"
        }
    }
    
    // The countdown timer.
    var timer: Timer?
    
    // The game counter.
    var counter = 10
    
    // The state of the game.
    var gameState = GameState.notStarted
    
    // The date that the timer was paused.
    var pauseDate: Date?
    
    // The last fire date before a pause.
    var previousFireDate: Date?
    
    // game header label
    lazy var gameHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your game end in:"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // The countdown timer label.
    lazy var gameText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 52, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // The play again button.
    lazy var playAgainButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Play Again", for: .normal)
        btn.backgroundColor = .myBlue
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.addTarget(self, action: #selector(playAgainButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    // Text that indicates current coin count.
    lazy var coinCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myGreen
        title = (RewardedAdService.shared.rewardUnitIDType == ConstantNames.typeA) ? ConstantNames.rewardVCTitleA :
            ConstantNames.rewardVCTitleB
        
        // Set UI layout
        setViews()
        
        // Pause game when application is backgrounded.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidEnterBackground(_:)),
            name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // Resume game when application is returned to foreground.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(_:)),
            name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // Update coins amount when receive valid reward
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveValidReward),
            name: .sendRewardToUser, object: nil)
        
        startNewGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playAgainButton.layer.cornerRadius = playAgainButton.frame.height / 2
        playAgainButton.layer.cornerCurve = .continuous
    }
    
    @objc func receiveValidReward() {
        if let reward = RewardedAdService.shared.reward {
            print("👠 Reward received with Coins \(reward.amount)")
            self.earnCoins(reward.amount)
        }
    }
    
    // MARK: - setup UI layout
    
    func setViews() {
        view.addSubview(gameText)
        view.addSubview(gameHeader)
        view.addSubview(playAgainButton)
        view.addSubview(coinCountLabel)
        
        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            gameText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gameText.widthAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            
            gameHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameHeader.bottomAnchor.constraint(equalTo: gameText.topAnchor, constant: -20),
            gameHeader.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            playAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playAgainButton.topAnchor.constraint(equalTo: gameText.bottomAnchor, constant: 26),
            playAgainButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.42),
            playAgainButton.heightAnchor.constraint(equalTo: playAgainButton.widthAnchor, multiplier: 0.25),
            
            coinCountLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20),
            coinCountLabel.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -20),
            coinCountLabel.widthAnchor.constraint(equalTo: g.widthAnchor, multiplier: 0.5),
            coinCountLabel.heightAnchor.constraint(equalTo: coinCountLabel.widthAnchor, multiplier: 0.25)
        ])
    }
    
    // MARK: - Game logic
    
    fileprivate func startNewGame() {
        gameState = .playing
        counter = gameLength
        playAgainButton.isHidden = true
        
        // Load Reward ad
        RewardedAdService.shared.createRewardedAd()
        
        gameText.text = String(counter)
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerFireMethod(_:)),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func applicationDidEnterBackground(_ notification: Notification) {
        // Pause the game if it is currently playing.
        if gameState != .playing {
            return
        }
        gameState = .paused
        
        // Record the relevant pause times.
        pauseDate = Date()
        previousFireDate = timer?.fireDate
        
        // Prevent the timer from firing while app is in background.
        timer?.fireDate = Date.distantFuture
    }
    
    @objc func applicationDidBecomeActive(_ notification: Notification) {
        // Resume the game if it is currently paused.
        if gameState != .paused {
            return
        }
        gameState = .playing
        
        // Calculate amount of time the app was paused.
        let pauseTime = (pauseDate?.timeIntervalSinceNow)! * -1
        
        // Set the timer to start firing again.
        timer?.fireDate = (previousFireDate?.addingTimeInterval(pauseTime))!
    }
    
    @objc func timerFireMethod(_ timer: Timer) {
        counter -= 1
        if counter > 0 {
            gameText.text = String(counter)
        } else {
            endGame()
        }
    }
    
    fileprivate func earnCoins(_ coins: Int) {
        coinCount += coins
    }
    
    fileprivate func endGame() {
        gameState = .ended
        gameText.text = "Game over!"
        playAgainButton.isHidden = false
        timer?.invalidate()
        timer = nil
        earnCoins(gameOverReward)
    }
    
    // MARK: - Button actions
    
    @objc func playAgainButtonTapped(_ sender: Any?) {
        if let ad = RewardedAdService.shared.rewardedAd,
           ad.isReady
        {
            // Show Reward ad
            ad.show()
        } else {
            let alert = UIAlertController(
                title: "Rewarded ad isn't available yet.",
                message: "The rewarded ad cannot be shown at this time",
                preferredStyle: .alert)
            let alertAction = UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: { [weak self] action in
                    self?.startNewGame()
                })
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}
