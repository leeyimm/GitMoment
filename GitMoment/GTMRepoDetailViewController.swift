//
//  GTMRepoDetailViewController.swift
//  GitMoment
//
//  Created by liying on 28/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import Ono


class GTMRepoDetailViewController: UIViewController {
    var repo : GTMRepository!
    var scrollView = UIScrollView()
    var threeButtonView : GTMThreeButtonView!
    var repoInfoView : GTMRepoInfoView!
    var readmeView : GTMRepoReadMeView!
    static let HTMLHeader = "<style type=\"text/css\">body { font-family: \"Helvetica Neue\", Helvetica, \"Segoe UI\", Arial, freesans, sans-serif;}</style> <meta name=\"viewport\" content=\"initial-scale=0.7\" />"
    
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
        
        self.readmeView = GTMRepoReadMeView()
        self.scrollView.addSubview(self.readmeView)
        self.readmeView.snp.makeConstraints { (make) in
            make.width.equalTo(self.scrollView)
            make.left.equalTo(self.scrollView)
            make.top.equalTo(self.repoInfoView.snp.bottom).offset(8)
            make.bottom.equalTo(self.scrollView)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GTMAPIManager.sharedInstance.fetchReadMe(ownername: (repo.owner?.login!)!, reponame: repo.name!, branch: repo.defaultBranch!) { (result) in
            guard result.error == nil else {
                return
            }
            
            let readmeHTML = self.extractReadmeHTMLFrom(readmeHTML: result.value!)
            self.readmeView.webView.loadHTMLString(readmeHTML, baseURL: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func extractReadmeHTMLFrom(readmeHTML: String) -> String {
        var resultHTML = GTMRepoDetailViewController.HTMLHeader
        
        if let document = try? ONOXMLDocument(string: readmeHTML, encoding: String.Encoding.utf8.rawValue) {
            let XPath = "//article/*"
            document.enumerateElements(withXPath: XPath, using: { (element, idx, stop) in
                if idx < 3 {
                    resultHTML = resultHTML.appending((element?.description)!)
                }
            })
            if resultHTML == GTMRepoDetailViewController.HTMLHeader {
                let CSS = "div#readme"
                document.enumerateElements(withCSS: CSS, using: { (element, idx, stop) in
                    if idx < 3 {
                        resultHTML = resultHTML.appending((element?.description)!)
                    }
                })
            }
        }
        
        return resultHTML
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


