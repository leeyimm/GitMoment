//
//  GTMReposListViewController.swift
//  GitMoment
//
//  Created by liying on 20/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMReposListViewController: UIViewController{
    
    var scrollView = UIScrollView()
    var trendingReposListController = GTMTrendingRepoListController()
    var populerReposListController = GTMPopularRepoListViewController()
    var titleControl : GTMNavigationBarSwitchControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.edgesForExtendedLayout = []
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Language", style: .plain, target: self, action: #selector(changeLanguage))
        
        let titleControlFrame = CGRect(x: 0, y: 0, width: 192.0 / 375.0 * UIScreen.main.bounds.width, height: 25)
        self.titleControl = GTMNavigationBarSwitchControl(frame: titleControlFrame, leftTitle: "Trending", rightTitle: "Popular")
        self.navigationItem.titleView = self.titleControl
        self.titleControl.delegate = self
        
        self.addChildViewController(trendingReposListController)
        self.addChildViewController(populerReposListController)
        
        self.setupView()
        
        self.trendingReposListController.didMove(toParentViewController: self)
        self.populerReposListController.didMove(toParentViewController: self)

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.delegate = self
        self.scrollView.addSubview(self.trendingReposListController.view)
        self.scrollView.addSubview(self.populerReposListController.view)
        self.scrollView.isPagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        //self.scrollView.contentSize = CGSize(width: 2 * UIScreen.main.bounds.width, height: 455)
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.trendingReposListController.view.snp.makeConstraints { (make) in
            make.size.equalTo(self.scrollView)
            make.left.top.bottom.equalTo(self.scrollView)
        }
        
        self.populerReposListController.view.snp.makeConstraints { (make) in
            make.size.equalTo(self.scrollView)
            make.left.equalTo(self.trendingReposListController.view.snp.right)
            make.right.top.bottom.equalTo(self.scrollView)
        }
        
        
    }
    
    @objc func changeLanguage() {
        let chosenlanguage = UserDefaults.standard.value(forKey: GTMConstantValue.userChosenLanguageKey) as? String
        let changeLanguageViewController = GTMLanguageChosenController(chosenLanguage: chosenlanguage)
        self.navigationController?.pushViewController(changeLanguageViewController, animated: true)
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

extension GTMReposListViewController : GTMNavigateBarSwitchControlDelegate {
    func leftSelected() {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func rightSelected() {
        self.scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
    }
}
extension GTMReposListViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.titleControl.slideBackgroundView(percentage: scrollView.contentOffset.x / UIScreen.main.bounds.width)
    }
}
