//
//  GTMRepository.swift
//  GitMoment
//
//  Created by liying on 14/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import Foundation
import ObjectMapper

class GTMRepository : Mappable {
    var id : String?
    var name : String?
    var fullName : String?
    var owner : GTMUser?
    var htmlUrl : String?
    var description : String?
    var fork : Bool?
    var url : String?
    var createdAt : String?
    var updatedAt : String?
    var pushedAt : String?
    var homepage : String?
    var size : Int?
    var stargazersCount : Int?
    var watchersCount : Int?
    var language : String?
    var forksCount : Int?
    var openIssueCount : Int?
    var masterBranch : String?
    var defaultBranch : String?
    var score : Double?
    var source : GTMRepository?
    
    var heightForCell : CGFloat {
        get {
            if let desc = description {
                let descString = (desc as NSString)
                let width = descString.boundingRect(with: CGSize(width:2000, height :20), options: [], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil).width
                if width > UIScreen.main.bounds.width - 20 {
                    return GTMRepoCell.height + 10
                } else {
                    return GTMRepoCell.height
                }
            } else {
                return GTMRepoCell.height - 15
            }
        }
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        fullName        <- map["full_name"]
        owner           <- map["owner"]
        htmlUrl         <- map["html_url"]
        description     <- map["description"]
        fork            <- map["fork"]
        url             <- map["url"]
        createdAt        <- map["created_at"]
        updatedAt       <- map["updated_at"]
        pushedAt        <- map["pushed_at"]
        homepage        <- map["homepage"]
        size            <- map["size"]
        stargazersCount <- map["stargazers_count"]
        watchersCount   <- map["watchers_count"]
        language        <- map["language"]
        forksCount       <- map["forks_count"]
        openIssueCount  <- map["open_issue_count"]
        masterBranch    <- map["master_branch"]
        defaultBranch   <- map["default_branch"]
        score           <- map["score"]
        source          <- map["source"]
    }
}
