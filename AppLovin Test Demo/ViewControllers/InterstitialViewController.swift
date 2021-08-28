//
//  InterstitialViewController.swift
//  AppLovin Test Demo
//
//  Created by HaiboZhou on 2021/8/28.
//


import UIKit

class InterstitialViewController: UIViewController {
    
    enum GameState: NSInteger {
        case notStarted
        case playing
        case paused
        case ended
    }
    
    // The game length.
    static let gameLength = 5
    
    // The countdown timer.
    var timer: Timer?
    
    // The amount of time left in the game.
    var timeLeft: Int = gameLength {
        didSet {
            gameText.text = "\(timeLeft)"
        }
    }
    
    // The state of the game.
    var gameState = GameState.notStarted
    
    // The date that the timer was paused.
    var pauseDate: Date?
    
    // The last fire date before a pause.
    var previousFireDate: Date?
    
    lazy var gameHeader: UILabel = {
        let label = UILabel()
        label.text = "Your game end in:"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // The countdown timer label.
    lazy var gameText: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 72, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myGreen
        title = "Welcome to my Game"
        
        // Set UI layout
        setViews()
        
        // Pause game when application enters background.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pauseGame),
            name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // Resume game when application becomes active.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resumeGame),
            name: UIApplication.didBecomeActiveNotification, object: nil)
        
        startNewGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playAgainButton.layer.cornerRadius = playAgainButton.frame.height / 2
        playAgainButton.layer.cornerCurve = .continuous
    }
    
    func setViews() {
        view.addSubview(gameText)
        view.addSubview(gameHeader)
        view.addSubview(playAgainButton)
        
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
            playAgainButton.heightAnchor.constraint(equalTo: playAgainButton.widthAnchor, multiplier: 0.25)
        ])
    }
    
    // MARK: - Game Logic
    
    fileprivate func startNewGame() {
        loadInterstitial()
        
        gameState = .playing
        timeLeft = InterstitialViewController.gameLength
        playAgainButton.isHidden = true
//        updateTimeLeft()
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(decrementTimeLeft(_:)),
            userInfo: nil,
            repeats: true)
    }
    
    fileprivate func loadInterstitial() {
        // load ad
        InterstitialAdService.shared.createInterstitialAd()
    }
    
//    fileprivate func updateTimeLeft() {
//        gameText.text = "\(timeLeft) secs left!"
//    }
    
    @objc func decrementTimeLeft(_ timer: Timer) {
        timeLeft -= 1
//        updateTimeLeft()
        if timeLeft == 0 {
            endGame()
        }
    }
    
    @objc func pauseGame() {
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
    
    @objc func resumeGame() {
        if gameState != .paused {
            return
        }
        gameState = .playing
        
        // Calculate amount of time the app was paused.
        let pauseTime = (pauseDate?.timeIntervalSinceNow)! * -1
        
        // Set the timer to start firing again.
        timer?.fireDate = (previousFireDate?.addingTimeInterval(pauseTime))!
    }
    
    fileprivate func endGame() {
        gameState = .ended
        timer?.invalidate()
        timer = nil
        
        let alert = UIAlertController(
            title: "Game Over",
            message: "You lasted \(InterstitialViewController.gameLength) seconds",
            preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: { [weak self] action in
                // Show interstitial ad
                if let ad = InterstitialAdService.shared.interstitialAd {
                    ad.show()
                } else {
                    print("interstitial ad wasn't ready")
                }
                self?.playAgainButton.isHidden = false
            })
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func playAgainButtonTapped(_ sender: Any?) {
        startNewGame()
    }
    
    // MARK: - deinit
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}
