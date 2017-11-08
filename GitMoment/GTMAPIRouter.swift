//
//  GTMAPIRouter.swift
//  GitMoment
//
//  Created by liying on 10/08/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import Foundation
import Alamofire

enum GTMAPIRouter: URLRequestConvertible {
    static let gitAwardsBaseURLString = "http://git-awards.com/api/v0/"
    static let gitTrendingBaseURLString = "http://trending.codehub-app.com/v2/trending"
    static let gitHubAPIBaseURLString = "https://api.github.com/"
    
    case getLanguagesList()
    case getTrendingRepos([String: Any]) //since=daily&language=objective-c
    case getPopularRepos([String: Any])
    case getPopularUsers([String: Any])
    case searchUser([String : Any])
    case searchRepos([String : Any])
    case getUserInfo(String?)
    case getUserRepos(String?)
    case getUserReposRanking(String)
    //star
    case getUserStarredRepos(String?) // username , without username is authenticated user
    case starRepo(String, String) //username, repo
    case unstarRepo(String, String)
    case checkStarred(String, String)
    //watch
    case getUserWatchingRepos(String?)
    case watchRepo(String, String)
    case unwatchRepo(String, String)
    case checkWatching(String, String)
    //follow
    case getUserFollowers(String?)   // username , without username is authenticated user
    case getUserFollowing(String?)
    case checkFollowing(String) //username
    case followUser(String)
    case unfollowUser(String)
    
    //repo
    case getRepoStargazers(String, String) //username, reponame
    case getRepoWatchers(String, String)
    case getRepoContributers(String, String)
    case getRepoForks(String, String)
    
    //issue
    case getRepoIssues(String, String)
    case getIssueComments(String, String, Int) //username, reponame, issueNumber
    case getRepoPullRequests(String, String)
    case getPullRequestFiles(String, String, Int)
    
    //fileContent
    case getREADMEContent(String, String) //username, reponame
    
    case getContents(String, String) //path , branch
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .starRepo, .watchRepo, .followUser:
                return .put
            case .unstarRepo, .unwatchRepo, .unfollowUser:
                return .delete
            default:
                return .get
            }
        }
        
        let url: URL = {
            let urlString: String
            switch self {
            case .getLanguagesList:
                urlString = GTMAPIRouter.gitAwardsBaseURLString.appending("languages")
            case .getTrendingRepos:
                urlString = GTMAPIRouter.gitTrendingBaseURLString
            case .getPopularRepos, .searchRepos:
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("search/repositories")
            case .getPopularUsers:
                urlString = GTMAPIRouter.gitAwardsBaseURLString.appending("users")
            case .getUserReposRanking(let username):
                urlString = GTMAPIRouter.gitAwardsBaseURLString.appending("users/" + username)
            case .searchUser:
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("search/users")
            case .getUserInfo(let username):
                if let name = username {
                    urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("users/" + name)
                } else {
                    urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("user")
                }
            case .getUserFollowers(let username):
                if let name = username {
                    urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("users/" + name + "/followers")
                } else {
                    urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("user/followers")
                }
            case .getUserFollowing(let username):
                if let name = username {
                    urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("users/" + name + "/following")
                } else {
                    urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("user/following")
                }
            case .getUserRepos(let username):
                if let name = username {
                    urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("users/" + name + "/repos")
                } else {
                    urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("user/repos")
                }
            case .getUserStarredRepos(let username):
                if let name = username {
                    urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("users/" + name + "/starred")
                } else {
                    urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("user/starred")
                }
            case .starRepo(let username, let repo), .unstarRepo(let username, let repo), .checkStarred(let username, let repo):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("users/starred/" + username + repo)
            case .getUserWatchingRepos(let username):
                if let name = username {
                    urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("users/" + name + "/subscriptions")
                } else {
                    urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("user/subscriptions")
                }
            case .watchRepo(let username, let repo), .unwatchRepo(let username, let repo), .checkWatching(let username, let repo):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("users/subscriptions/" + username + repo)
            case .followUser(let username), .unfollowUser(let username):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("user/following/" + username)
            case  .checkFollowing(let username):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("users/following/" + username)
            case .getRepoStargazers(let ownername, let reponame):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("repos/" + ownername + "/" + reponame + "/stargazers")
            case .getRepoWatchers(let ownername, let reponame):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("repos/" + ownername + "/" + reponame + "/subscribers")
            case .getRepoContributers(let ownername, let reponame):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("repos/" + ownername + "/" + reponame + "/contributors")
            case .getRepoForks(let ownername, let reponame):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("repos/" + ownername + "/" + reponame + "/forks")
            case .getRepoIssues(let ownername, let reponame):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("repos/" + ownername + "/" + reponame + "/issues")
            case .getRepoPullRequests(let ownername, let reponame):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("repos/" + ownername + "/" + reponame + "/pulls")
            case .getIssueComments(let ownername, let reponame, let issueNum):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("repos/" + ownername + "/" + reponame + "/issues/\(issueNum)/comments")
            case .getREADMEContent(let ownername, let reponame):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("repos/" + ownername + "/" + reponame + "/readme")
            case .getContents(let path, _):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending(path)
            case .getPullRequestFiles(let ownername, let reponame, let pullNum):
                urlString = GTMAPIRouter.gitHubAPIBaseURLString.appending("repos/" + ownername + "/" + reponame + "/pulls/\(pullNum)/files")
        }
        
            let url = URL(string: urlString)!
            return url
            
        }()
        
        let params: ([String: Any]?) = {
            var params = [String:Any]()
            switch self {
            case .getLanguagesList:
                params["sort"] = "popularity"
            case .getRepoIssues, .getRepoPullRequests:
                params["state"] = "all"
            case .getTrendingRepos(let params):
                return params
            case .getPopularRepos(let params):
                return params
            case .searchRepos(let params):
                return params
            case .getPopularUsers(let params):
                return params
            case .searchUser(let params):
                return params
            default:
                break
            }
            return params
            
        }()
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .getREADMEContent:
            urlRequest.setValue("application/vnd.github.v3.html", forHTTPHeaderField: "Accept")
        case .followUser:
            urlRequest.setValue("0", forHTTPHeaderField: "Content-Length")
            fallthrough
        default:
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        
        // Set OAuth token if we have one
        if let token = GTMAPIManager.sharedInstance.OAuthToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoding = URLEncoding.default
        return try encoding.encode(urlRequest, with: params)
        
    }
}
