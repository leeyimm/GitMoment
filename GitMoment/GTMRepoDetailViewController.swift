//
//  GTMRepoDetailViewController.swift
//  GitMoment
//
//  Created by liying on 28/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit


class GTMRepoDetailViewController: UIViewController {
    var repo : GTMRepository!
    var scrollView = UIScrollView()
    var threeButtonView : GTMThreeButtonView!
    var repoInfoView : GTMRepoInfoView!
    //var readmeView : GTMRepoReadMeView!
    
    var infoTableView = UITableView()
    var infoCellHeight = 45.0
    var infoCellIdentifier = "repoInfoCell"
    
    init(repo: GTMRepository) {
        super.init(nibName: nil, bundle: nil)
        self.repo = repo
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationItem.title = self.repo.name!
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = UIColor(hex: "#f5f5f5")
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.threeButtonView = GTMThreeButtonView(leftTitle: "watch", middleTitle: "star", rightTitle: "fork")
        self.threeButtonView.delegate = self
        self.scrollView.addSubview(self.threeButtonView)
        self.threeButtonView.snp.makeConstraints { (make) in
            make.top.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
            make.left.equalTo(self.scrollView)
            make.height.equalTo(60)
        }
        self.threeButtonView.updateButtonsUpperTitle(left: "\(repo.watchersCount ?? 0)", middle: "\(repo.stargazersCount ?? 0)", right: "\(repo.forksCount ?? 0)")
        
        self.repoInfoView = GTMRepoInfoView(repo: self.repo)
        self.scrollView.addSubview(self.repoInfoView)
        self.repoInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.threeButtonView.snp.bottom).offset(8)
            make.left.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
        }
        
        self.scrollView.addSubview(self.infoTableView)
        self.infoTableView.register(GTMInfoCell.self, forCellReuseIdentifier: infoCellIdentifier)
        self.infoTableView.dataSource = self
        self.infoTableView.delegate = self
        
        self.infoTableView.snp.makeConstraints { (make) in
            make.width.equalTo(self.scrollView)
            make.left.equalTo(self.scrollView)
            make.top.equalTo(self.repoInfoView.snp.bottom).offset(8)
            make.height.equalTo(45 * 6)
            make.bottom.equalTo(self.scrollView).offset(-15)
        }
        
        GTMAPIManager.sharedInstance.fetchRepoTopics(ownername: (self.repo.owner?.login)!, reponame: self.repo.name!) { (result) in
            guard result.error == nil else {
                return
            }
            let topic = result.value!
            self.repoInfoView.topicsView.setTopics(topics: topic)
        }
        
        GTMAPIManager.sharedInstance.fetchRepoLanguages(ownername: (self.repo.owner?.login)!, reponame: self.repo.name!) { (result) in
            guard result.error == nil else {
                return
            }
            let languagesDict = result.value!
            var languages = [String]()
            for (language, number) in languagesDict {
                languages.append(language)
            }
            self.repoInfoView.languagesView.setTopics(topics: languages)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension GTMRepoDetailViewController : GTMThreeButtonViewDelegate {
    func leftButtonTapped() {
        let watchersListController = GTMInterestedUserListController(type: .watching, ownername: (self.repo.owner?.login!)!, reponame: self.repo.name!)
        self.navigationController?.pushViewController(watchersListController, animated: true)
    }
    func middleButtonTapped() {
        let stargazersListController = GTMInterestedUserListController(type: .starred, ownername: (self.repo.owner?.login!)!, reponame: self.repo.name!)
        self.navigationController?.pushViewController(stargazersListController, animated: true)

    }
    func rightButtonTapped() {
        let forksListController = GTMUserReposListController(type: .forkedRepos, ownername: (self.repo.owner?.login!)!, reponame: self.repo.name!)
        self.navigationController?.pushViewController(forksListController, animated: true)
    }
}

extension GTMRepoDetailViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifier, for: indexPath) as! GTMInfoCell
            switch (indexPath.row) {
            case (0):
                cell.setCellType(type: .owner, title: self.repo.owner?.login)
                cell.setSeparatedLine(type: .upper, indent: 0)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (1):
                cell.setCellType(type: .readme, title: nil)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (2):
                cell.setCellType(type: .code, title: nil)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (3):
                cell.setCellType(type: .contributer, title: nil)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (4):
                cell.setCellType(type: .issue, title: nil)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (5):
                cell.setCellType(type: .pr, title: nil)
                cell.setSeparatedLine(type: .lower, indent: 0)
            default:
                break
        }
        return cell
    }
}

extension GTMRepoDetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell is GTMInfoCell {
            var nextViewController : UIViewController!
            switch (cell as! GTMInfoCell).type! {
            case .owner:
                nextViewController = GTMUserDetailViewController(username: (self.repo.owner?.login)!)
            case .readme:
                nextViewController = GTMREADMEViewController(repo: self.repo)
            case .code:
                let rootPath = "repos/" + (self.repo.owner?.login!)! + "/" + self.repo.name! + "/contents"
                nextViewController = GTMFileListViewController(filePath: rootPath, branch: self.repo.defaultBranch!)
            case .contributer:
                nextViewController = GTMInterestedUserListController(type: .contributors, ownername: (self.repo.owner?.login!)!, reponame: self.repo.name!)
            case .issue:
                nextViewController = GTMIssueListViewController(repo: self.repo, type: .issue)
            case .pr:
                nextViewController = GTMIssueListViewController(repo: self.repo, type: .pull_request)
            default:
                break
            }
            if nextViewController != nil {
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
    }
}


