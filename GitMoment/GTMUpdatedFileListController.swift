//
//  GTMUpdatedFileListController.swift
//  GitMoment
//
//  Created by liying on 05/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMUpdatedFileListController: GTMRefreshableListViewController {
    var repo : GTMRepository
    var pullRequest : GTMPullRequest
    var files = [GTMUpdatedFileInfo]()
    
    init(repo: GTMRepository, pullRequest: GTMPullRequest) {
        self.repo = repo
        self.pullRequest = pullRequest
        super.init(pageEnabled: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(GTMUpdatedFileInfoCell.self, forCellReuseIdentifier: GTMConstantValue.updatedFileInfoCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        self.tableView.mj_header.refreshingBlock = {
            [weak self] in
            self?.fetchUpdatedFiles(page: 1)
        }
        
        self.tableView.mj_footer.refreshingBlock = {
            [weak self] in
            self?.fetchUpdatedFiles(page: (self?.page)! + 1)
        }
        // Do any additional setup after loading the view.
        self.fetchUpdatedFiles(page:1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUpdatedFiles(page: Int) {
        GTMAPIManager.sharedInstance.fetchPullRequestFiles(ownername: (self.repo.owner?.login)!, reponame: self.repo.name!, pullNum:self.pullRequest.number!,  page: page) { (result) in
            self.dismissLoadingIndicator()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            guard result.error == nil else {
                let error  = result.error! as! GTMAPIManagerError
                self.processError(error: error)
                return
            }
            
            self.processData(list: &self.files, fetchedList: result.value!.0, page: result.value!.1, expectedPageCount: GTMConstantValue.githubPerpageCount)
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

extension GTMUpdatedFileListController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.updatedFileInfoCellIdentifier, for: indexPath) as! GTMUpdatedFileInfoCell
        let file = self.files[indexPath.row]
        cell.updateUIWith(fileInfo: file)
        return cell
    }
}

extension GTMUpdatedFileListController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = self.files[indexPath.row]
        var nextViewController : UIViewController!
        switch file.status! {
        case .modified:
            nextViewController = GTMFilePatchViewController(fileInfo: file)
            
        default:
            nextViewController = GTMFileContentViewController(filePath: file.blobUrl)
        }
        
        if nextViewController != nil {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}
