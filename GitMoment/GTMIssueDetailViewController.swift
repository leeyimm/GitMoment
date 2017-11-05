//
//  GTMIssueDetailViewController.swift
//  GitMoment
//
//  Created by liying on 02/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import DTCoreText

class GTMIssueDetailViewController: GTMRefreshableListViewController {

    let issue : GTMIssueBase
    let repo : GTMRepository
    var sectionModels = [GTMSectionModel]()
    var comments = [GTMComment]()
    init(repo: GTMRepository, issue : GTMIssueBase) {
        self.repo = repo
        self.issue = issue
        super.init(pageEnabled: true)
        
        
    }
    
    func prepareFirstSectionModel() {
        if self.issue is GTMIssue {
            sectionModels.append(GTMIssueSectionModel(issue: self.issue as! GTMIssue))
        }
        if self.issue is GTMPullRequest {
            sectionModels.append(GTMPullRequestSectionModel(pullRequest: self.issue as! GTMPullRequest))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(GTMIssueHeaderCell.self, forCellReuseIdentifier: GTMConstantValue.issueHeaderCellIdentifier)
        self.tableView.register(GTMCommentAuthorCell.self, forCellReuseIdentifier: GTMConstantValue.authorInfoCellIdentifier)
        self.tableView.register(DTAttributedTextCell.self, forCellReuseIdentifier: GTMConstantValue.attributedContentCellIdentifier)
        self.tableView.register(GTMTableViewCell.self, forCellReuseIdentifier: GTMConstantValue.baseCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        self.tableView.mj_header.refreshingBlock = {
            [weak self] in
            self?.fetchIssueComments(page: 1)
        }
        
        self.tableView.mj_footer.refreshingBlock = {
            [weak self] in
            self?.fetchIssueComments(page: (self?.page)! + 1)
        }
        
        
        self.fetchIssueComments(page: 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchIssueComments(page: Int) {
        self.showLoadingIndicator(toView: tableView)
        GTMAPIManager.sharedInstance.fetchIssueComments(ownername: (self.repo.owner?.login)!, reponame: self.repo.name!, issueNum:self.issue.number!,  page: page)  { (result) in
            self.dismissLoadingIndicator()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            guard result.error == nil else {
                let error  = result.error! as! GTMAPIManagerError
                self.processError(error: error)
                return
            }
            
            let fetchedList = (result.value?.0)!
            let currentPage = (result.value?.1)!
            self.page = currentPage
            if currentPage == 1 {
                self.comments = fetchedList
                if fetchedList.count < GTMConstantValue.githubPerpageCount {
                    self.tableView.mj_footer.removeFromSuperview()
                }
            } else {
                if fetchedList.count < GTMConstantValue.githubPerpageCount {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.comments.append(contentsOf: fetchedList)
            }
            
            self.sectionModels.removeAll()
            self.prepareFirstSectionModel()
            for comment in self.comments {
                let commentSectionModel = GTMCommentSectionModel(comment: comment)
                self.sectionModels.append(commentSectionModel)
            }
            
            self.tableView.reloadData()
            
        }
    }

}

extension GTMIssueDetailViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionModels.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionModels[section].numberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.sectionModels[indexPath.section].cellForRow(at: indexPath, tableView: tableView)
        return cell
    }
}

extension GTMIssueDetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.sectionModels[indexPath.section].heightForRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionModel = self.sectionModels[indexPath.section]
        if let controller = sectionModel.nextViewController(forRow: indexPath.row) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
