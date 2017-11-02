//
//  GTMSearchRepoViewController.swift
//  GitMoment
//
//  Created by liying on 19/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

fileprivate let leftMargin = 10
fileprivate let spaceMargin = 8

class GTMSearchRepoViewController: UIViewController {

    var scrollView = TPKeyboardAvoidingScrollView()
    
    var keywordLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var keywordTextField = UITextField()
    var keywordInLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var keywordSelectionView = GTMSelectionSegmentView(options: ["name", "description", "readme"], fontSize: 15, allowMultiSelection: false)
    
    var languageLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var languageTextField = UITextField()
    
    var topicLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var topicTextField1 = UITextField()
    var topicTextField2 = UITextField()
    var topicTextField3 = UITextField()
    
    var forksLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var forksNumberRangeView = GTMNumberRangeField()
    
    var starsLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var starsNumberRangeView = GTMNumberRangeField()
    
    var sortLabel = UILabel(fontSize: 16, textColor: UIColor(hex: "#2196f3"), backgroundColor: UIColor.clear)
    var sortSelectionView = GTMSelectionSegmentView(options: ["stars", "forks", "updated"], fontSize: 15, allowMultiSelection: false)
    
    var searchButton = UIButton(type:.system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
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
            make.top.equalTo(15)
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
        
        //topics
        
        self.scrollView.addSubview(topicLabel)
        topicLabel.text = "Topic(s)"
        self.scrollView.addSubview(topicTextField1)
        topicTextField1.borderStyle = .roundedRect
        self.scrollView.addSubview(topicTextField2)
        topicTextField2.borderStyle = .roundedRect
        self.scrollView.addSubview(topicTextField3)
        topicTextField3.borderStyle = .roundedRect
        topicLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftMargin)
            make.top.equalTo(languageTextField.snp.bottom).offset(15)
        }
        topicTextField1.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(topicLabel.snp.bottom).offset(spaceMargin)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
        }
        topicTextField2.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(topicTextField1.snp.bottom).offset(spaceMargin)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
        }
        topicTextField3.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(topicTextField2.snp.bottom).offset(spaceMargin)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
        }
        self.putSeparateLineUnderView(view: topicTextField3)
        //forks
        self.scrollView.addSubview(forksLabel)
        forksLabel.text = "Forks Range"
        self.scrollView.addSubview(forksNumberRangeView)
        forksLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftMargin)
            make.top.equalTo(topicTextField3.snp.bottom).offset(15)
        }
        
        forksNumberRangeView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(forksLabel.snp.bottom).offset(spaceMargin)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
        }
        self.putSeparateLineUnderView(view: forksNumberRangeView)
        //stars
        self.scrollView.addSubview(starsLabel)
        starsLabel.text = "Followers Range"
        self.scrollView.addSubview(starsNumberRangeView)
        starsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftMargin)
            make.top.equalTo(forksNumberRangeView.snp.bottom).offset(15)
        }
        starsNumberRangeView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(starsLabel.snp.bottom).offset(spaceMargin)
            make.width.equalTo(self.scrollView).multipliedBy(0.8)
        }
        self.putSeparateLineUnderView(view: starsNumberRangeView)
        //sort
        
        self.scrollView.addSubview(sortLabel)
        sortLabel.text = "Sort Result"
        self.scrollView.addSubview(sortSelectionView)
        sortLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftMargin)
            make.top.equalTo(starsNumberRangeView.snp.bottom).offset(15)
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
        if let range = keywordSelectionView.selectedString {
            searchString.append(" in:" + range)
        }

        let language = languageTextField.text ?? ""
        if !language.isEmpty {
            searchString.append(" language:" + language)
        }
        //topic
        let topic1 = topicTextField1.text ?? ""
        if !topic1.isEmpty {
            searchString.append(" topic:" + topic1)
        }
        let topic2 = topicTextField2.text ?? ""
        if !topic2.isEmpty {
            searchString.append(" topic:" + topic2)
        }
        let topic3 = topicTextField3.text ?? ""
        if !topic3.isEmpty {
            searchString.append(" topic:" + topic3)
        }
        if let forks = forksNumberRangeView.rangeString {
            searchString.append(" forks:" + forks)
        }
        if let stars = starsNumberRangeView.rangeString {
            searchString.append(" stars" + stars)
        }
        
        let searchResultController = GTMRepoSearchResultsViewController(searchString: searchString, sort: sortSelectionView.selectedString)
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


}
