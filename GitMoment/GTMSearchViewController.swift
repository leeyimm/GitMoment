//
//  GTMSearchController.swift
//  GitMoment
//
//  Created by liying on 10/08/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit


class GTMSearchViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var searchUserViewController = GTMSearchUserViewController()
    var searchRepoViewController = GTMSearchRepoViewController()
    var titleControl : GTMNavigationBarSwitchControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        
        let titleControlFrame = CGRect(x: 0, y: 0, width: 192.0 / 375.0 * UIScreen.main.bounds.width, height: 25)
        self.titleControl = GTMNavigationBarSwitchControl(frame: titleControlFrame, leftTitle: "User", rightTitle: "Repo")
        self.navigationItem.titleView = self.titleControl
        self.titleControl.delegate = self
        
        self.addChildViewController(searchUserViewController)
        self.addChildViewController(searchRepoViewController)
        
        self.setupView()
        
        self.searchUserViewController.didMove(toParentViewController: self)
        self.searchRepoViewController.didMove(toParentViewController: self)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.delegate = self
        self.scrollView.addSubview(self.searchUserViewController.view)
        self.scrollView.addSubview(self.searchRepoViewController.view)
        self.scrollView.isPagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        //self.scrollView.contentSize = CGSize(width: 2 * UIScreen.main.bounds.width, height: 455)
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.searchUserViewController.view.snp.makeConstraints { (make) in
            make.size.equalTo(self.scrollView)
            make.left.top.bottom.equalTo(self.scrollView)
        }
        
        self.searchRepoViewController.view.snp.makeConstraints { (make) in
            make.size.equalTo(self.scrollView)
            make.left.equalTo(self.searchUserViewController.view.snp.right)
            make.right.top.bottom.equalTo(self.scrollView)
        }
        
        
    }
    

}

extension GTMSearchViewController : GTMNavigateBarSwitchControlDelegate {
    func leftSelected() {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func rightSelected() {
        self.scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
    }
}
extension GTMSearchViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.titleControl.slideBackgroundView(percentage: scrollView.contentOffset.x / UIScreen.main.bounds.width)
    }
}
