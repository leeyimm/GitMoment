//
//  GTMPopularRepoListViewController.swift
//  GitMoment
//
//  Created by liying on 15/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMPopularRepoListViewController: GTMBaseViewController {
    
    var language: String!
    let tableViewCellIdentifier = "trendingRepoCell"
    
    var tableView : UITableView = UITableView()
    
    var repos = [GTMRepository]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.addSubview(self.tableView)
        self.tableView.register(GTMRepoCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        self.language = UserDefaults.standard.value(forKey: GTMConstantValue.userChosenLanguageKey) as? String
        
        self.fetchPopulerRepos(language: self.language)
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
            self.fetchPopulerRepos(language: self.language)
        }
    }
    
    func fetchPopulerRepos(language: String?) {
        let languageString = language ?? ""
        self.showLoadingIndicator(toView: tableView)
        GTMAPIManager.sharedInstance.fetchPopularRepos(language: languageString) { (result) in
            self.dismissLoadingIndicator()
            
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
}

