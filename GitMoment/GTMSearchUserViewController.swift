//
//  GTMSearchUserViewController.swift
//  GitMoment
//
//  Created by liying on 19/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

fileprivate let leftMargin = 10
fileprivate let spaceMargin = 8

class GTMSearchUserViewController: UIViewController {

    var scrollView = TPKeyboardAvoidingScrollView()
    
    var typeLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var typeSeletionView = GTMSelectionSegmentView(options: ["user", "org"], fontSize: 15, allowMultiSelection: false)
    
    var keywordLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var keywordTextField = UITextField()
    var keywordInLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var keywordSelectionView = GTMSelectionSegmentView(options: ["login", "email", "fullname"], fontSize: 15, allowMultiSelection: false)
    
    var languageLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var languageTextField = UITextField()
    
    var loctionLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var loctionTextField = UITextField()
    
    var reposLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var reposNumberRangeView = GTMNumberRangeField()
    
    var followersLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var followersNumberRangeView = GTMNumberRangeField()
    
    var sortLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var sortSelectionView = GTMSelectionSegmentView(options: ["followers", "repos", "joined"], fontSize: 15, allowMultiSelection: false)
    
    var searchButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.edgesForExtendedLayout = []
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        //type
        self.scrollView.addSubview(typeLabel)
        typeLabel.text = "Type"
        self.scrollView.addSubview(typeSeletionView)
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftMargin)
            make.top.equalTo(10)
        }
        
        typeSeletionView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
            make.height.equalTo(25)
            make.top.equalTo(typeLabel.snp.bottom).offset(spaceMargin)
        }
        
        self.putSeparateLineUnderView(view: typeSeletionView)
        //keyword
        self.scrollView.addSubview(keywordLabel)
        keywordLabel.text = "Keyword"
        self.scrollView.addSubview(keywordTextField)
        self.keywordTextField.borderStyle = .roundedRect
        self.scrollView.addSubview(keywordInLabel)
        keywordInLabel.text = "Search In"
        self.scrollView.addSubview(keywordSelectionView)
        
        keywordLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftMargin)
            make.top.equalTo(typeSeletionView.snp.bottom).offset(15)
        }
        
        keywordTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(keywordLabel.snp.bottom).offset(spaceMargin)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
        }
        
        keywordInLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(keywordTextField.snp.bottom).offset(spaceMargin)
        }
        
        keywordSelectionView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(keywordInLabel.snp.bottom).offset(spaceMargin)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
        }
        
        self.putSeparateLineUnderView(view: keywordSelectionView)
        
        //language
        self.scrollView.addSubview(languageLabel)
        languageLabel.text = "Language"
        self.scrollView.addSubview(languageTextField)
        languageTextField.borderStyle = .roundedRect
        
        languageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftMargin)
            make.top.equalTo(keywordSelectionView.snp.bottom).offset(15)
        }
        languageTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(languageLabel.snp.bottom).offset(spaceMargin)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
        }
        self.putSeparateLineUnderView(view: languageTextField)
        
        //location
        
        self.scrollView.addSubview(loctionLabel)
        loctionLabel.text = "Location"
        self.scrollView.addSubview(loctionTextField)
        loctionTextField.borderStyle = .roundedRect
        loctionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftMargin)
            make.top.equalTo(languageTextField.snp.bottom).offset(15)
        }
        loctionTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(loctionLabel.snp.bottom).offset(spaceMargin)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
        }
        self.putSeparateLineUnderView(view: loctionTextField)
        //repos
        self.scrollView.addSubview(reposLabel)
        reposLabel.text = "Repos Range"
        self.scrollView.addSubview(reposNumberRangeView)
        reposLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftMargin)
            make.top.equalTo(loctionTextField.snp.bottom).offset(15)
        }
        
        reposNumberRangeView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(reposLabel.snp.bottom).offset(spaceMargin)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
        }
        self.putSeparateLineUnderView(view: reposNumberRangeView)
        //followers
        self.scrollView.addSubview(followersLabel)
        followersLabel.text = "Followers Range"
        self.scrollView.addSubview(followersNumberRangeView)
        followersLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftMargin)
            make.top.equalTo(reposNumberRangeView.snp.bottom).offset(15)
        }
        followersNumberRangeView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(followersLabel.snp.bottom).offset(spaceMargin)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
        }
        self.putSeparateLineUnderView(view: followersNumberRangeView)
        //sort
        
        self.scrollView.addSubview(sortLabel)
        sortLabel.text = "Sort Result"
        self.scrollView.addSubview(sortSelectionView)
        sortLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftMargin)
            make.top.equalTo(followersNumberRangeView.snp.bottom).offset(15)
        }
        
        sortSelectionView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(sortLabel.snp.bottom).offset(15)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
            
        }
        self.putSeparateLineUnderView(view: sortSelectionView)
        
        self.scrollView.addSubview(searchButton)
        searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = UIColor(hex: "#42a5f5")
        searchButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(sortSelectionView.snp.bottom).offset(25)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
            make.bottom.equalTo(self.scrollView).offset(-25)
        }
        
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        self.addKeyboardDismissGesture()
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func searchButtonTapped() {
        var searchString = ""
        if let keyword = keywordTextField.text {
            searchString.append(keyword)
        }
        if let type = typeSeletionView.selectedString {
            searchString.append(" in:" + type)
        }
        let location = loctionTextField.text ?? ""
        if !location.isEmpty {
            searchString.append(" location:" + location)
        }
        let language = languageTextField.text ?? ""
        if !language.isEmpty {
            searchString.append(" language:" + language)
        }
        if let repos = reposNumberRangeView.rangeString {
            searchString.append(" repos:" + repos)
        }
        if let followers = followersNumberRangeView.rangeString {
            searchString.append(" followers" + followers)
        }
        
        let searchResultController = GTMUserSearchResultsViewController(searchString: searchString, sort: sortSelectionView.selectedString)
        self.navigationController?.pushViewController(searchResultController, animated: true)
    }
    
    
    func putSeparateLineUnderView(view: UIView) {
        let separateLine = UIView()
        separateLine.backgroundColor = UIColor(hex: "#dddddd")
        
        self.scrollView.addSubview(separateLine)
        separateLine.snp.makeConstraints { (make) in
            make.height.equalTo(1/UIScreen.main.scale)
            make.centerX.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView).offset(-20)
            make.top.equalTo(view.snp.bottom).offset(8)
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
