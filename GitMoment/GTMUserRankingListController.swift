//
//  GTMUserRankingListController.swift
//  GitMoment
//
//  Created by liying on 10/08/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import MJRefresh

class GTMUserRankingListController: GTMPagedListViewController, GTMLocationChosenDelegate {
    
    var chosenLanguage : String?
    var chosenLocation : GTMConstantValue.GTMLocationType = .GTMLocationWorld { didSet(newValue) {
        self.fetchUserRanking(page: 1)
        }
    }
    
    let tableViewCellIdentifier = "userRankingCell"
    
    var users = [GTMUserRankingInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Popular"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Language", style: .plain, target: self, action: #selector(changeLanguage))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Location", style: .plain, target: self, action: #selector(changeLocation))
        
        self.tableView.register(GTMUserRankingCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        self.tableView.mj_header.refreshingBlock = {
            [weak self] in
            self?.fetchUserRanking(page: 1)
        }
        
        self.tableView.mj_footer.refreshingBlock = {
            [weak self] in
            self?.fetchUserRanking(page: (self?.page)! + 1)
        }
        
        self.chosenLanguage = UserDefaults.standard.value(forKey: GTMConstantValue.userChosenLanguageKey) as? String
        
        self.fetchUserRanking(page: 1)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let chosenLanguage = UserDefaults.standard.value(forKey: GTMConstantValue.userChosenLanguageKey) as? String
        if self.chosenLanguage != chosenLanguage {
            self.chosenLanguage = chosenLanguage
            self.fetchUserRanking(page: 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeLanguage() {
        let changeLanguageViewController = GTMLanguageChosenController(chosenLanguage: self.chosenLanguage)
        self.navigationController?.pushViewController(changeLanguageViewController, animated: true)
    }
    
    func changeLocation() {
        let locationSettingController = GTMLocationSettingController()
        locationSettingController.locationDelegate = self
        locationSettingController.modalPresentationStyle = .custom
        
        locationSettingController.transitioningDelegate = self
        self.present(locationSettingController, animated: true, completion: nil)
    }
    
    func fetchUserRanking(page: Int) {
        self.showLoadingIndicator(toView: tableView)
        GTMAPIManager.sharedInstance.fetchPopularUsers(language: self.chosenLanguage, location: self.chosenLocation, page: page) { (result) in
            self.dismissLoadingIndicator()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            guard result.error == nil else {
                let error  = result.error! as! GTMAPIManagerError
                self.processError(error: error)
                return
            }
            
            self.processData(list: &self.users, fetchedResult: result.value!, expectedPageCount: GTMConstantValue.rankingPerpageCount)
            self.tableView.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GTMUserRankingListController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! GTMUserRankingCell
        let userRankingInfo = self.users[indexPath.row]
        cell.nameLabel.text = userRankingInfo.login
        cell.starCountLabel.text = "\(userRankingInfo.starsCount!)"
        cell.worldRankingLabel.text = "\(userRankingInfo.worldRank!)"
        if let urlString = userRankingInfo.gravatarUrl {
            cell.avatarImageView.kf.setImage(with: URL(string: urlString))
        }
        
        return cell
    }

}

extension GTMUserRankingListController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userRankingInfo = self.users[indexPath.row]
        let userDetailViewController = GTMUserDetailViewController(username: userRankingInfo.login!)
        self.navigationController?.pushViewController(userDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let languageAndLocationLabel = UILabel(fontSize: 14)
        languageAndLocationLabel.text = "  Location: " + self.chosenLocation.description() + " Languge: " + (self.chosenLanguage ?? "All languages")
        languageAndLocationLabel.backgroundColor = UIColor(hex: "#f5f5f5")
        return languageAndLocationLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension GTMUserRankingListController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let dialogPresentationController = GTMDialogPresentationController(presentedViewController: presented, presenting: presenting)
        return dialogPresentationController
    }
}
