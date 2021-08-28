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
            HomeOption(title: ConstantNames.interstitials, titleColor: .label, icon: UIImage(systemName: ConstantNames.starHalfFill), iconBackgroundColor: .myGreen) { [weak self] in
                let vc = InterstitialViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            HomeOption(title: ConstantNames.banners, titleColor: .label, icon: UIImage(systemName: ConstantNames.starFill), iconBackgroundColor: .myBlue) { [weak self] in
                let vc = BannerViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
        ]))
        
        models.append(Section(title: ConstantNames.rewards, options: [
            HomeOption(title: ConstantNames.rewardA, titleColor: .label, icon: UIImage(systemName: ConstantNames.letterA), iconBackgroundColor: .systemPink) { [weak self] in
                let vc = RewardsViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            HomeOption(title: ConstantNames.rewardB, titleColor: .label, icon: UIImage(systemName: ConstantNames.letterB), iconBackgroundColor: .myPuple) { [weak self] in
                let vc = RewardsBViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        ]))
        
        models.append(Section(title: ConstantNames.support, options: [
            HomeOption(title: ConstantNames.supportSite, titleColor: .label, icon: UIImage(named: "logo"), iconBackgroundColor: .AppLovinBlue) { [weak self] in
                guard let url = URL(string: ConstantNames.supportSiteURL) else { return }
                self?.openMyURL(webURL: url)
            },
            HomeOption(title: "TBD...", titleColor: .label, icon: UIImage(systemName: ConstantNames.tbd), iconBackgroundColor: .systemGray3) {
                
            },
        ]))
        
        models.append(Section(title: "", options: [
            HomeOption(title: "TBD...", titleColor: .label, icon: UIImage(systemName: ConstantNames.tbd), iconBackgroundColor: .systemGray3) {
                
            }
        ]))
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
        
        return cell
    }
    
    // tableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        model.handler()
    }
}

