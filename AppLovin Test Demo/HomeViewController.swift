//
//  ViewController.swift
//  AppLovin Test Demo
//
//  Created by HaiboZhou on 2021/8/27.
//

import SafariServices
import UIKit

// MARK: - Data Model for tableView cell
struct Section {
    let title: String
    let options: [HomeOption]
}

struct HomeOption {
    let title: String
    let titleColor: UIColor?
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: ( () -> Void )
}

class HomeViewController: UIViewController, SFSafariViewControllerDelegate {
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        return table
    }()
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCells()
        view.backgroundColor = .systemBackground
        self.title = ConstantNames.appLovinTestDemo
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: - Configure static cell
    func configureCells() {
        models.append(Section(title: ConstantNames.interstitialAndBanner, options: [
            HomeOption(title: ConstantNames.interstitials, titleColor: .label, icon: UIImage(systemName: ConstantNames.crown), iconBackgroundColor: .systemPink) { [weak self] in
                print("show interstitials Ad")
                let vc = InterstitialViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            HomeOption(title: ConstantNames.banners, titleColor: .label, icon: UIImage(systemName: ConstantNames.crown), iconBackgroundColor: .systemPink) { [weak self] in
                print("Tapped Upgrade to Pro")
                //                let vc = PremiumViewController()
                //                self?.present(vc, animated: true)
            },
            HomeOption(title: ConstantNames.rewarded, titleColor: .label, icon: UIImage(systemName: ConstantNames.crown), iconBackgroundColor: .systemPink) { [weak self] in
                print("Tapped Upgrade to Pro")
                //                let vc = PremiumViewController()
                //                self?.present(vc, animated: true)
            }
        ]))
        
        models.append(Section(title: ConstantNames.rewards, options: [
            HomeOption(title: "Rate app", titleColor: .label, icon: UIImage(systemName: "star.leadinghalf.fill"), iconBackgroundColor: .myGreen) { [weak self] in
                self?.rateApp(id: "1579505526")
            },
            HomeOption(title: "Contact us", titleColor: .label, icon: UIImage(systemName: "envelope.fill"), iconBackgroundColor: .myEmailBlue) { [weak self] in
                self?.contactMe()
            },
            HomeOption(title: "Twitter page", titleColor: .label, icon: UIImage(systemName: "envelope.fill"), iconBackgroundColor: .myEmailBlue) { [weak self] in
                self?.openTwitter()
            },
        ]))
        
        models.append(Section(title: ConstantNames.support, options: [
            HomeOption(title: ConstantNames.supportSite, titleColor: .label, icon: UIImage(systemName: "hand.raised.fill"), iconBackgroundColor: .myEmailBlue) { [weak self] in
                guard let url = URL(string: "https://www.haibosfashion.com/products/ohmusic/oh-music-privacy-policy/") else { return }
                self?.openMyURL(webURL: url)
            },
            HomeOption(title: "Terms Of Service", titleColor: .label, icon: UIImage(systemName: "doc.plaintext.fill"), iconBackgroundColor: .myEmailBlue) { [weak self] in
                guard let url = URL(string: "https://www.haibosfashion.com/products/ohmusic/oh-music-terms-of-services/") else { return }
                self?.openMyURL(webURL: url)
            },
        ]))
        
        models.append(Section(title: "", options: [
            HomeOption(title: "TBD...", titleColor: .label, icon: UIImage(systemName: "bahtsign.circle"), iconBackgroundColor: .systemPink) {
                
            }
        ]))
    }
    
    func rateApp(id : String) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/id\(id)?mt=8&action=write-review") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func contactMe() {
        let email = "chuckzhb@hotmail.com"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func openTwitter() {
        let screenName =  "HaiboZhou2"
        let appURL = URL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = URL(string: "https://twitter.com/\(screenName)")!
        
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL) // open url with twitter app
        } else {
            print("twitter page")
            openMyURL(webURL: webURL) // open url with in-app safari
        }
    }
    
    func openMyURL(webURL: URL) {
        // open an in-app safari
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: webURL, configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: - TableView data source and delegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // tableView data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return models[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            fatalError("Cell initialize failed")
        }
        let model = models[indexPath.section].options[indexPath.row]
        cell.configure(with: model)
        
        // custom Restore purchase section
//        if indexPath.section == 3 {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    // tableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        model.handler()
    }
}

