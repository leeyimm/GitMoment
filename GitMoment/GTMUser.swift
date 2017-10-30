//
//  GTMUser.swift
//  GitMoment
//
//  Created by liying on 14/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import Foundation
import ObjectMapper

class GTMUser : Mappable {
    var login : String?
    var id : String?
    var avatarUrl : String?
    var gravtarId : String?
    var url : String?
    var htmlUrl : String?
    var followersUrl : String?
    var subscriptionUrl : String?
    var organizationsUrl : String?
    var reposUrl : String?
    var type : String?
    var score : Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        login               <- map["login"]
        id                  <- map["id"]
        avatarUrl           <- map["avatar_url"]
        gravtarId           <- map["gravtar_id"]
        url                 <- map["url"]
        htmlUrl             <- map["html_url"]
        followersUrl        <- map["followers_url"]
        subscriptionUrl     <- map["subscriprion_url"]
        organizationsUrl    <- map["organization_utl"]
        reposUrl            <- map["repos_url"]
        type                <- map["type"]
        score               <- map["score"]
    }
}

class GTMLanguageReposRankingInfo : Mappable {
    var language : String?
    var reposCount : Int?
    var starsCount : Int?
    var cityRank : Int?
    var cityCount : Int?
    var countryRank : Int?
    var countryCount : Int?
    var worldRank : Int?
    var worldCount : Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        language            <- map["language"]
        reposCount          <- map["repository_count"]
        starsCount          <- map["stars_count"]
        cityRank            <- map["city_rank"]
        cityCount           <- map["city_count"]
        countryRank         <- map["country_rank"]
        countryCount        <- map["country_count"]
        worldRank           <- map["world_rank"]
        worldCount          <- map["world_count"]
    }
}

class GTMUserRankingInfo : Mappable {
    var id : String?
    var login : String?
    var gravatarUrl : String?
    var city : String?
    var country : String?
    var starsCount : Int?
    var cityRank : Int?
    var countryRank : Int?
    var worldRank : Int?
    var languageRepos : [GTMLanguageReposRankingInfo]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        login               <- map["login"]
        id                  <- map["id"]
        gravatarUrl         <- map["gravatar_url"]
        city                <- map["city"]
        country             <- map["country"]
        starsCount          <- map["stars_count"]
        cityRank            <- map["city_rank"]
        countryRank         <- map["country_rank"]
        worldRank           <- map["world_rank"]
        languageRepos       <- map["rankings"]
    }
}

class GTMGithubUser : Mappable {
    var login : String?
    var id : String?
    var avatarUrl : String?
    var gravtarId : String?
    var url : String?
    var htmlUrl : String?
    var followersUrl : String?
    var subscriptionUrl : String?
    var organizationsUrl : String?
    var reposUrl : String?
    var type : String?
    var name : String?
    var company : String?
    var location : String?
    var email : String?
    var bio : String?
    var publicRepos : Int?
    var publicGist : Int?
    var followers : Int?
    var following : Int?
    
    var isOrganization :  Bool { get {
        if let type = self.type {
            if type == "Organization" {
                return true
            }
        }
        return false
        }
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        login               <- map["login"]
        id                  <- map["id"]
        avatarUrl           <- map["avatar_url"]
        gravtarId           <- map["gravtar_id"]
        url                 <- map["url"]
        htmlUrl             <- map["html_url"]
        followersUrl        <- map["followers_url"]
        subscriptionUrl     <- map["subscriprion_url"]
        organizationsUrl    <- map["organization_utl"]
        reposUrl            <- map["repos_url"]
        type                <- map["type"]
        name                <- map["name"]
        company             <- map["company"]
        location            <- map["location"]
        email               <- map["email"]
        bio                 <- map["bio"]
        publicRepos         <- map["public_repos"]
        publicGist          <- map["public_gist"]
        followers           <- map["followers"]
        following           <- map["following"]
    }
}
