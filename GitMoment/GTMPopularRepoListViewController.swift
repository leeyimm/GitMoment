//
//  GTMPopularRepoListViewController.swift
//  GitMoment
//
//  Created by liying on 15/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import MJRefresh

class GTMPopularRepoListViewController: GTMRefreshableListViewController {
    
    var language: String!
    let tableViewCellIdentifier = "trendingRepoCell"
    var repos = [GTMRepository]()


    init() {
        super.init(pageEnabled: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(GTMRepoCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        self.tableView.mj_header.refreshingBlock = {
            [weak self] in
            self?.fetchPopulerRepos(language: self?.language, page: 1)
        }
        
        self.tableView.mj_footer.refreshingBlock = {
            [weak self] in
            self?.fetchPopulerRepos(language: self?.language, page: (self?.page)! + 1)
        }
        
        self.language = UserDefaults.standard.value(forKey: GTMConstantValue.userChosenLanguageKey) as? String
        
        self.fetchPopulerRepos(language: self.language, page: 1)
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
            self.fetchPopulerRepos(language: self.language, page: 1)
        }
    }
    
    func fetchPopulerRepos(language: String?, page: Int) {
        let languageString = language ?? ""
        self.showLoadingIndicator(toView: tableView)
        GTMAPIManager.sharedInstance.fetchPopularRepos(language: languageString, page: page) { (result) in
            self.dismissLoadingIndicator()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            guard result.error == nil else {
                let error  = result.error! as! GTMAPIManagerError
                self.processError(error: error)
                return
            }
            
            self.processData(list: &self.repos, fetchedResult: result.value!, expectedPageCount: GTMConstantValue.githubPerpageCount)

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

extension GTMPopularRepoListViewController : UITableViewDataSource {
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

extension GTMPopularRepoListViewController : UITableViewDelegate {
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

