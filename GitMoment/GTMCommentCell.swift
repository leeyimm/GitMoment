//
//  GTMCommentCell.swift
//  GitMoment
//
//  Created by liying on 02/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import WebKit
import MMMarkdown

protocol GTMSelfSizedCell {
    func cellHeight() -> CGFloat
}

class GTMIssueHeaderCell : GTMTableViewCell, GTMSelfSizedCell {
    var stateLabel = UILabel(fontSize: 13)
    var titleLabel = UILabel(boldFontSize: 14, textColor: UIColor.black, backgroundColor: UIColor.clear)
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func cellHeight() -> CGFloat {
        return 60
    }
    
    override func setupUI() {
        self.contentView.addSubview(self.stateLabel)
        self.contentView.addSubview(self.titleLabel)
        
        self.stateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(15)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.stateLabel.snp.bottom).offset(10)
            make.left.equalTo(self.stateLabel)
        }
    }
    
    func updateUIWith(issue: GTMIssue) {
        self.stateLabel.text = issue.state.rawValue
        self.titleLabel.text = issue.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GTMCommentAuthorCell: GTMTableViewCell, GTMSelfSizedCell {

    var authorIcon = UIImageView()
    var authorNameLabel = UILabel(fontSize: 12, textColor: UIColor.black, backgroundColor: UIColor.clear)
    var createdTimeLabel = UILabel(fontSize: 11, textColor: UIColor.black, backgroundColor: UIColor.clear)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellHeight() -> CGFloat {
        return 40
    }
    
    override func setupUI() {
        self.contentView.addSubview(self.authorIcon)
        self.contentView.addSubview(self.authorNameLabel)
        self.contentView.addSubview(self.createdTimeLabel)
        
        self.authorIcon.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.height.equalTo(25)
            make.centerY.equalTo(self.contentView)
        }
        
        self.authorNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(self.authorIcon.snp.right).offset(10)
        }
        
        self.createdTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.authorNameLabel.snp.bottom).offset(5)
            make.left.equalTo(self.authorNameLabel)
        }
    }
    
    func updateUIWith(author: GTMUser, createTime: String) {
        self.authorIcon.kf.setImage(with: URL(string: author.avatarUrl!))
        self.authorNameLabel.text = author.login
        self.createdTimeLabel.text = createTime
    }

}

class GTMHTMLContentCell : GTMTableViewCell, GTMSelfSizedCell {
    var webView : WKWebView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.webView.navigationDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadContent(original: String) {
        let htmlString = try? MMMarkdown.htmlString(withMarkdown: original, extensions: .gitHubFlavored)
        var htmlPage : String!
        if let body = htmlString {
            htmlPage = GTMConstantValue.htmlHead + body + GTMConstantValue.htmlTail
        } else {
            htmlPage = GTMConstantValue.htmlHead + "no content" + GTMConstantValue.htmlTail
        }
        self.webView.loadHTMLString(htmlPage, baseURL: nil)
    }
    
    func cellHeight() -> CGFloat {
        return webView.frame.height
    }
}

extension GTMHTMLContentCell: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("document.body.offsetHeight;") { (any, error) in
            guard error == nil  else{
                return
            }
            if let height = any as? CGFloat {
                print(height)
                var webFrame = webView.frame
                webFrame.size.height = height
                webView.frame = webFrame
            }
        }
        //didLoadSuccessfully?()
    }
    
}
