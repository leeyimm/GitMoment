//
//  GTMRepoTagsView.swift
//  GitMoment
//
//  Created by liying on 10/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMTagCell : UICollectionViewCell {
    var tagLabel : UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        tagLabel = UILabel(fontSize: 12, textColor: UIColor.white, backgroundColor:UIColor(hex: "#2196f3"))
        tagLabel.textAlignment = .center
        tagLabel.layer.borderWidth = 1.0
        tagLabel.layer.borderColor = UIColor(hex: "#dedede").cgColor
        tagLabel.layer.cornerRadius = 3.0
        tagLabel.layer.masksToBounds = true
        self.contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GTMRepoTagsView : GTMRepoInfoBaseView {
    var tags = [String]()
    let tagsCellIdentifier = "tagsCell"
    
    var collectionView : UICollectionView!
    
    override init(title: String, noContentTitle: String) {
        super.init(title: title, noContentTitle: noContentTitle)
        let tagsLayout = UICollectionViewFlowLayout()
        tagsLayout.scrollDirection = .vertical
        tagsLayout.minimumLineSpacing = 10
        tagsLayout.minimumInteritemSpacing = 8
        tagsLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 15, width: UIScreen.main.bounds.width - 30, height: 0), collectionViewLayout: tagsLayout)
        collectionView.register(GTMTagCell.self, forCellWithReuseIdentifier: tagsCellIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(0)
            make.width.equalTo(UIScreen.main.bounds.width - 30)
        }
        self.bringSubview(toFront: self.titleLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func setTags(tags: [String]) {
        if tags.count > 0 {
            self.tags = tags
            self.collectionView.reloadData()
            self.noContentLabel.isHidden = true
            self.collectionView.isHidden = false
        } else {
            self.noContentLabel.isHidden = false
            self.collectionView.isHidden = true
        }
        self.invalidateIntrinsicContentSize()
        self.setNeedsUpdateConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        if self.tags.count == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: 60)
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: self.collectionView.collectionViewLayout.collectionViewContentSize.height + 20)
        }
    }
    
    override func updateConstraints() {
        self.collectionView.snp.updateConstraints { (make) in
            make.height.equalTo(self.collectionView.collectionViewLayout.collectionViewContentSize.height)
        }
        super.updateConstraints()
    }
}

extension GTMRepoTagsView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagsCellIdentifier, for: indexPath) as! GTMTagCell
        cell.tagLabel.text = self.tags[indexPath.row]
        return cell
    }
}

extension GTMRepoTagsView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = self.tags[indexPath.row]
        let label = UILabel(fontSize: 13)
        label.text = tag
        return CGSize(width: label.intrinsicContentSize.width + 8, height: label.intrinsicContentSize.height + 4)
    }
}

