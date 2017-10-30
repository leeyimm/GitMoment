//
//  GTMUserRankingListController.swift
//  GitMoment
//
//  Created by liying on 10/08/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMUserRankingListController: UIViewController, GTMLocationChosenDelegate {
    
    var chosenLanguage : String?
    var chosenLocation : GTMConstantValue.GTMLocationType = .GTMLocationWorld { willSet(newValue) {
        self.fetchUserRanking(language: self.chosenLanguage, location: newValue)
        }
    }
    
    let tableViewCellIdentifier = "userRankingCell"
    var contentView = UIView()
    
    var tableView : UITableView = UITableView()
    
    var users = [GTMUserRankingInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        self.navigationItem.title = "Popular"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Language", style: .plain, target: self, action: #selector(changeLanguage))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Location", style: .plain, target: self, action: #selector(changeLocation))
        
        self.view.addSubview(self.contentView)
        
        self.contentView.addSubview(self.tableView)
        self.tableView.register(GTMUserRankingCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchUserRanking(language: self.chosenLanguage, location: self.chosenLocation)
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
    
    func fetchUserRanking(language: String?, location : GTMConstantValue.GTMLocationType) {
        GTMAPIManager.sharedInstance.fetchPopularUsers(language: language, location: location) { (result) in
            guard result.error == nil else {
                return
            }
            if let users = result.value {
                self.users = users
                self.tableView.reloadData()
                if users.count > 0 {
                    self.navigationItem.leftBarButtonItem?.title = self.chosenLocation.description()
                } else {
                    self.navigationItem.leftBarButtonItem?.title = "Location"
                }
            }
            
            self.users = result.value!
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
}

extension GTMUserRankingListController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let dialogPresentationController = GTMDialogPresentationController(presentedViewController: presented, presenting: presenting)
        return dialogPresentationController
    }
}
