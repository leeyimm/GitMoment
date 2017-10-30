//
//  GTMTrendingRepoListController.swift
//  GitMoment
//
//  Created by liying on 10/08/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import MJRefresh

class GTMTrendingRepoListController: GTMBaseViewController{
    var language: String?
    
    let tableViewCellIdentifier = "trendingRepoCell"
    
    var periodSegmentControl = UISegmentedControl(items: GTMConstantValue.periods)
    var separateLine = UIView()
    var tableView : UITableView = UITableView()
    
    var repos = [GTMRepository]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.addSubview(self.periodSegmentControl)
        self.periodSegmentControl.addTarget(self, action: #selector(periodSegmentChange(sender:)), for: .valueChanged)
        self.periodSegmentControl.tintColor = UIColor(hex: "#239BE7")
        
        self.separateLine.backgroundColor = UIColor(hex: "#cccccc")
        self.contentView.addSubview(self.separateLine)
        self.contentView.layer.masksToBounds = true
        
        self.contentView.addSubview(self.tableView)
        self.tableView.register(GTMRepoCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let refreshHeader = MJRefreshNormalHeader(refreshingBlock: {
            [weak self] in
            self?.fetchRepoTrending(checkCache: false)
        })
        refreshHeader?.lastUpdatedTimeLabel.isHidden = true
        self.tableView.mj_header = refreshHeader
        
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.periodSegmentControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(2)
            make.left.equalTo(self.contentView).offset(8)
            make.right.equalTo(self.contentView).offset(-8)
            make.height.equalTo(32)
        }
        
        self.separateLine.snp.makeConstraints { (make) in
            make.top.equalTo(self.periodSegmentControl.snp.bottom).offset(3)
            make.height.equalTo(1/UIScreen.main.scale)
            make.left.right.equalTo(self.contentView)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.separateLine.snp.bottom)
            make.left.right.bottom.equalTo(self.contentView)
        }
        
        self.periodSegmentControl.selectedSegmentIndex = 0 //default daily
        self.language = UserDefaults.standard.value(forKey: GTMConstantValue.userChosenLanguageKey) as? String
        self.fetchRepoTrending(checkCache: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let chosenLanguage = UserDefaults.standard.value(forKey: GTMConstantValue.userChosenLanguageKey) as? String
        if self.language != chosenLanguage {
            self.language = chosenLanguage
            self.fetchRepoTrending(checkCache: true)
        }
    }
    
    func fetchRepoTrending(checkCache: Bool) {
        let languageString = self.language ?? ""
        let since = GTMConstantValue.periods[self.periodSegmentControl.selectedSegmentIndex]
        self.showLoadingIndicator(toView: tableView)
        GTMAPIManager.sharedInstance.fetchTrendingRepos(checkCache: checkCache, language: languageString, since: since.lowercased()) { (result) in
            self.dismissLoadingIndicator()
            self.tableView.mj_header.endRefreshing()
            guard result.error == nil else {
                let error  = result.error! as! GTMAPIManagerError
                switch error {
                case .network:
                    self.showNetworkErrorViewWith(title: "Network Error")
                default:
                    break
                }
                self.showToast(text: error.descripiton)
                return
            }
            
            self.repos = result.value!
            if self.repos.count == 0 {
                self.showNocontentViewWith(title: "No items")
            } else {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func periodSegmentChange(sender: UISegmentedControl) {
        
        fetchRepoTrending(checkCache: true)
    }
    
    override func refreshAction() {
        fetchRepoTrending(checkCache: false)
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

extension GTMTrendingRepoListController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! GTMRepoCell
        let repo = self.repos[indexPath.row]
        cell.updateUIWithRepo(repo: repo)
        return cell
    }
}

extension GTMTrendingRepoListController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let repo = self.repos[indexPath.row]
        return repo.heightForCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = self.repos[indexPath.row]
        let repoDetailController = GTMRepoDetailViewController(repo: repo)
        self.navigationController?.pushViewController(repoDetailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let languageLabel = UILabel(fontSize: 14)
        languageLabel.text = "  Languge: " + (self.language ?? "All languages")
        languageLabel.backgroundColor = UIColor(hex: "#f5f5f5")
        return languageLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

