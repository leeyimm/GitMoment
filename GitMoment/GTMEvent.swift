//
//  GTMEvent.swift
//  GitMoment
//
//  Created by liying on 07/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import ObjectMapper

class GTMEvent: Mappable {
    
    enum GTMEventType : String {
        case commitComment = "CommitCommentEvent"
        case fork = "ForkEvent"
        case issueComment = "IssueCommentEvent"
        case member = "MemberEvent"
        case pullRequest = "PullRequestEvent"
        case pullRequestReview = "PullRequestReviewEvent"
        case watch = "WatchEvent"
        case unspported
    }
    
    
    var type : GTMEventType?
    var typeString : String?
    var payload : [String: Any]!
    var repo : GTMRepository?
    var actor : GTMUser?
    var org : GTMUser?
    var id : String?
    var createdAt : String?
    
    init(event: GTMEvent) {
        self.type = event.type
        self.typeString = event.typeString
        self.repo = event.repo
        self.actor = event.actor
        self.org = event.org
        self.id = event.id
        self.createdAt = event.createdAt
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        type          <- map["type"]
        typeString              <- map["type"]
        payload            <- map["payload"]
        repo              <- map["repo"]
        actor                <- map["actor"]
        org               <- map["org"]
        createdAt                <- map["created_at"]
        id                  <- map["id"]
    }
    
    func parsePayload<T:Mappable>(key: String, payload: T.Type) -> T? {
        if let jsonDict = self.payload[key], let dict = jsonDict as? [String: Any] {
            return T(JSON: dict)
        } else {
            return nil
        }
    }
    func parsePayload<T>(key: String) -> T? {
        if let josn = self.payload[key], let result = josn as? T {
            return result
        } else {
            return nil
        }
    }
}

class GTMCommitCommentEvent : GTMEvent {
    var comment : GTMComment!
    var sender : GTMUser!
    
    override init(event: GTMEvent) {
        super.init(event: event)
        self.comment = self.parsePayload(key: "comment", payload: GTMComment.self)
        self.sender = self.parsePayload(key: "sender", payload: GTMUser.self)
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
}

class GTMForkEvent : GTMEvent {
    var forkee : GTMRepository!
    var forked : GTMRepository!
    var sender : GTMUser!
    
    override init(event: GTMEvent) {
        super.init(event: event)
        self.forkee = self.parsePayload(key: "forkee", payload: GTMRepository.self)
        self.forked = self.parsePayload(key: "repository", payload: GTMRepository.self)
        self.sender = self.parsePayload(key: "sender", payload: GTMUser.self)
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
}

class GTMIssueCommentEvent : GTMEvent {
    var issue : GTMRepository!
    var comment : GTMComment!
    var sender : GTMUser!
    var action : String!
    
    override init(event: GTMEvent) {
        super.init(event: event)
        self.issue = self.parsePayload(key: "issue", payload: GTMRepository.self)
        self.comment = self.parsePayload(key: "comment", payload: GTMComment.self)
        self.sender = self.parsePayload(key: "sender", payload: GTMUser.self)
        self.action = self.parsePayload(key: "action")
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
}

class GTMMemberEvent : GTMEvent {
    var member : GTMUser!
    var repository : GTMRepository!
    var sender : GTMUser!
    var action : String!
    
    override init(event: GTMEvent) {
        super.init(event: event)
        self.member = self.parsePayload(key: "member", payload: GTMUser.self)
        self.repository = self.parsePayload(key: "repository", payload: GTMRepository.self)
        self.sender = self.parsePayload(key: "sender", payload: GTMUser.self)
        self.action = self.parsePayload(key: "action")
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
}

class GTMPublicEvent : GTMEvent {
    var publicRepo : GTMRepository!
    var sender : GTMUser!
    
    override init(event: GTMEvent) {
        super.init(event: event)
        self.publicRepo = self.parsePayload(key: "publicRepo", payload: GTMRepository.self)
        self.sender = self.parsePayload(key: "sender", payload: GTMUser.self)
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
}

class GTMPullRequestEvent : GTMEvent {
    var repository : GTMRepository!
    var pullRequest : GTMPullRequest!
    var sender : GTMUser!
    var action : String!
    var number : Int!
    
    override init(event: GTMEvent) {
        super.init(event: event)
        self.repository = self.parsePayload(key: "repository", payload: GTMRepository.self)
        self.sender = self.parsePayload(key: "sender", payload: GTMUser.self)
        self.pullRequest = self.parsePayload(key: "pull_request", payload: GTMPullRequest.self)
        self.action = self.parsePayload(key: "action")
        self.number = self.parsePayload(key: "number")
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
}

class GTMWatchEvent : GTMEvent {
    var repository : GTMRepository!
    var sender : GTMUser!
    var action : String!
    
    override init(event: GTMEvent) {
        super.init(event: event)
        self.repository = self.parsePayload(key: "repository", payload: GTMRepository.self)
        self.sender = self.parsePayload(key: "sender", payload: GTMUser.self)
        self.action = self.parsePayload(key: "action")
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
}
