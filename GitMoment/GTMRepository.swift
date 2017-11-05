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
                let width = descString.boundingRect(with: CGSize(width:2000, height :20), options: [], attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil).width
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


class GTMFileInfo : Mappable {
    
    enum GTMFileType : String{
        case dir = "dir"
        case file = "file"
        case symlink = "symlink"
        case submodule = "submodule"
        case invalid = ""
    }
    
    var type : GTMFileType = .invalid
    var target : String?
    var submoduleGitUrl : String?
    var name : String?
    var path : String?
    var sha : String?
    var url : String?
    var gitUrl : String?
    var htmlUrl : String?
    var downloadUrl : String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        type                <- map["type"]
        target              <- map["target"]
        submoduleGitUrl     <- map["submodule_git_url"]
        name                <- map["name"]
        path                <- map["path"]
        sha                 <- map["sha"]
        url                 <- map["url"]
        gitUrl              <- map["git_url"]
        htmlUrl             <- map["html_url"]
        downloadUrl         <- map["download_url"]
    }
}

class GTMIssueBase : Mappable {
    enum GTMIssueState : String {
        case open = "open"
        case closed = "closed"
    }
    var id : Int?
    var url : String?
    var number : Int?
    var state : GTMIssueState = .open
    var title : String?
    var body : String?
    var user : GTMUser?
    var assignee : GTMUser?
    var assignees : [GTMUser]?

    var createdAt : String?
    var updatedAt : String?
    var closedAt : String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                     <- map["id"]
        url                    <- map["url"]
        number                 <- map["number"]
        state                  <- map["state"]
        title                  <- map["title"]
        body                   <- map["body"]
        user                   <- map["user"]
        assignee               <- map["assignee"]
        assignees              <- map["assignees"]
        createdAt              <- map["created_at"]
        updatedAt              <- map["updated_at"]
        closedAt               <- map["closed_at"]
    }
}

class GTMIssue: GTMIssueBase {
    var closeBy : GTMUser?
    var comments : Int?
    var repositoryUrl : String?
    var labelsUrl : String?
    var commentsUrl : String?
    var eventsUrl : String?
    var htmlUrl : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        repositoryUrl          <- map["repository_url"]
        labelsUrl              <- map["labels_url"]
        commentsUrl            <- map["comments_url"]
        eventsUrl              <- map["events_url"]
        htmlUrl                <- map["html_url"]
        comments               <- map["comments"]
        closeBy                <- map["closed_by"]
    }
}

class GTMComment : Mappable {
    var id : Int?
    var url : String?
    var htmlUrl : String?
    var body : String?
    var user : GTMUser?
    var createdAt : String?
    var updatedAt : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                     <- map["id"]
        url                    <- map["url"]
        htmlUrl                <- map["html_url"]
        body                   <- map["body"]
        user                   <- map["user"]
        createdAt              <- map["created_at"]
        updatedAt              <- map["updated_at"]
    }
}

class GTMPullRequest : GTMIssueBase {
    var htmlUrl : String?
    var diffUrl : String?
    var patchUrl : String?
    var issueUrl : String?
    var commitsUrl : String?
    var commentsUrl : String?
    
    var mergedAt : String?
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        htmlUrl                <- map["html_url"]
        diffUrl                <- map["diff_url"]
        patchUrl               <- map["patch_url"]
        issueUrl               <- map["issue_url"]
        commitsUrl             <- map["commits_url"]
        commentsUrl            <- map["comments_url"]
        mergedAt               <- map["merged_at"]
    }
}

class GTMUpdatedFileInfo : Mappable {
    enum GTMModifiedFileStatus : String {
        case added = "added"
        case removed = "removed"
        case modified = "modified"
        case renamed = "renamed"
    }
    var filename : String?
    var status : GTMModifiedFileStatus!
    var additions : Int!
    var deletions: Int!
    var changes: Int!
    var contentsUrl : String?
    var blobUrl : String!
    var patch : String?
    var previousFilename : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        filename                <- map["filename"]
        status                <- map["status"]
        additions               <- map["additions"]
        deletions               <- map["deletions"]
        changes             <- map["changes"]
        blobUrl            <- map["blob_url"]
        contentsUrl            <- map["contents_url"]
        patch               <- map["patch"]
        previousFilename    <- map["previous_filename"]        
    }
}


