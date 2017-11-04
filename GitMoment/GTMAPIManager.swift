//
//  GTMAPIManager.swift
//  GitMoment
//
//  Created by liying on 14/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import Locksmith
import YYCache

enum GTMAPIManagerError: Error {
    case network(error: Error)
    case apiProviderError(reason: String)
    case authCouldNot(reason: String)
    case authLost(reason: String)
    case objectSerialization(reason: String)
    
    var descripiton : String {
        get {
            switch self {
            case .network(let error):
                return error.localizedDescription
            case .apiProviderError(let reason), .authCouldNot(let reason), .authLost(let reason), .objectSerialization(let reason):
                return reason
            }
        }
    }
}

class GTMAPIManager {
    static let sharedInstance = GTMAPIManager()
    
    var trendingCache = YYMemoryCache()
    
    var isLoadingOAuthToken: Bool = false
    var OAuthTokenCompletionHandler:((Error?) -> Void)?
    init() {
        trendingCache.ageLimit = 10 * 60
    }
    
    var OAuthToken: String? {
        set {
            guard let newValue = newValue else {
                let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "github")
                return
            }

            guard let _ = try? Locksmith.updateData(data: ["token": newValue],
                                                    forUserAccount: "github") else {
                                                        let _ = try? Locksmith.deleteDataForUserAccount(userAccount: "github")
                                                        return
            }
        }
        get {
            // try to load from keychain
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "github")
            return dictionary?["token"] as? String
        }
    }
    
    let clientID: String = "8cfb26b043ee1559dba8"
    let clientSecret: String = "9bd502613a59b60b7c17b48827a49af778c38f6c"
    
    func hasOAuthToken() -> Bool {
        if let token = self.OAuthToken {
            return !token.isEmpty
        }
        return false
    }
    
    // MARK: - OAuth flow
    func URLToStartOAuth2Login() -> URL? {
        let authPath: String = "https://github.com/login/oauth/authorize" +
        "?client_id=\(clientID)&scope=user%20repo&state=TEST_STATE"
        return URL(string: authPath)
    }
    
    func processOAuthStep1Response(_ url: URL) {
        // extract the code from the URL
        guard let code = extractCodeFromOAuthStep1Response(url) else {
            self.isLoadingOAuthToken = false
            let error = GTMAPIManagerError.authCouldNot(reason:
                "Could not obtain an OAuth token")
            self.OAuthTokenCompletionHandler?(error)
            return
        }
        
        swapAuthCodeForToken(code: code)
    }
    
    func swapAuthCodeForToken(code: String) {
        let getTokenPath: String = "https://github.com/login/oauth/access_token"
        let tokenParams = ["client_id": clientID, "client_secret": clientSecret,
                           "code": code]
        let jsonHeader = ["Accept": "application/json"]
        Alamofire.request(getTokenPath, method: .post, parameters: tokenParams,
                          encoding: URLEncoding.default, headers: jsonHeader)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    self.isLoadingOAuthToken = false
                    let errorMessage = response.result.error?.localizedDescription ??
                    "Could not obtain an OAuth token"
                    let error = GTMAPIManagerError.authCouldNot(reason: errorMessage)
                    self.OAuthTokenCompletionHandler?(error)
                    return
                }
                guard let value = response.result.value else {
                    print("no string received in response when swapping oauth code for token")
                    self.isLoadingOAuthToken = false
                    let error = GTMAPIManagerError.authCouldNot(reason:
                        "Could not obtain an OAuth token")
                    self.OAuthTokenCompletionHandler?(error)
                    return
                }
                guard let jsonResult = value as? [String: String] else {
                    print("no data received or data not JSON")
                    self.isLoadingOAuthToken = false
                    let error = GTMAPIManagerError.authCouldNot(reason:
                        "Could not obtain an OAuth token")
                    self.OAuthTokenCompletionHandler?(error)
                    return
                }
                
                self.OAuthToken = self.parseOAuthTokenResponse(jsonResult)
                self.isLoadingOAuthToken = false
                if (self.hasOAuthToken()) {
                    self.OAuthTokenCompletionHandler?(nil)
                } else {
                    let error = GTMAPIManagerError.authCouldNot(reason: "Could not obtain an OAuth token")
                    self.OAuthTokenCompletionHandler?(error)
                }
        }
    }
    
    func parseOAuthTokenResponse(_ json: [String: String]) -> String? {
        var token: String?
        for (key, value) in json {
            switch key {
            case "access_token":
                token = value
            case "scope":
                // TODO: verify scope
                print("SET SCOPE")
            case "token_type":
                // TODO: verify is bearer
                print("CHECK IF BEARER")
            default:
                print("got more than I expected from the OAuth token exchange")
                print(key)
            }
        }
        return token
    }
    
    func extractCodeFromOAuthStep1Response(_ url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var code: String?
        guard let queryItems = components?.queryItems else {
            return nil
        }
        for queryItem in queryItems {
            if (queryItem.name.lowercased() == "code") {
                code = queryItem.value
                break
            }
        }
        return code
    }
    
    func isAPIOnline(completionHandler: @escaping (Bool) -> Void) {
        Alamofire.request(GTMAPIRouter.gitHubAPIBaseURLString)
            .validate(statusCode: 200 ..< 300)
            .response { response in
                guard response.error == nil else {
                    // no internet connection or GitHub API is down
                    completionHandler(false)
                    return
                }
                completionHandler(true)
        }
    }
    
    func fetchLanguagesList(completionHandler: @escaping ([String]) -> Void) {
        let languageList = GTMConstantValue.languageList
        
        completionHandler(languageList)
    }
    
    func fetchTrendingRepos(checkCache: Bool, language: String, since: String, completionHandler: @escaping (Result<[GTMRepository]>) -> Void) {
        let params = ["language": language, "since": since]
        let cacheKey = language + since
        if checkCache, let repos = self.trendingCache.object(forKey: cacheKey) as? [GTMRepository] {
            completionHandler(.success(repos))
            return
        }
        Alamofire.request(GTMAPIRouter.getTrendingRepos(params)).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            guard let jsonArray = response.result.value as? [[String: Any]] else {
                print("didn't get array of repos object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            let repos : [GTMRepository] = Array(JSONArray: jsonArray)
            self.trendingCache.setObject(repos, forKey: cacheKey)
            completionHandler(.success(repos))
        }
    }
    
    func fetchPopularRepos(language: String, page: Int, completionHandler: @escaping (Result<([GTMRepository], Int)>) -> Void) {
        var params = [String: Any] ()
        params["order"] = "desc"
        params["sort"] = "stars"
        params["page"] = "\(page)"
        params["q"] = "language:".appending(language)
        
        Alamofire.request(GTMAPIRouter.getPopularRepos(params)).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            guard let jsonDictionary = response.result.value as? [String : Any], let jsonArray = jsonDictionary["items"] as? [[String: Any]] else {
                print("didn't get popular repos object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let repos : [GTMRepository] = Array(JSONArray:jsonArray)
            completionHandler(.success((repos, page)))
        }
    }
    
    func fetchPopularUsers(language: String?, location: GTMConstantValue.GTMLocationType, page: Int, completionHandler: @escaping (Result<([GTMUserRankingInfo], Int)>) -> Void) {
        var params = [String: Any] ()
        params["page"] = "\(page)"
        if let language = language {
            params["language"] = language
        }
        
        switch location {
        case .GTMLocationWorld:
            params["type"] = "world"
        case .GTMLocationCountry(let country):
            params["type"] = "country"
            params["country"] = country
        case .GTMLocationCity(let city):
            params["type"] = "city"
            params["city"] = city
        }
        
        Alamofire.request(GTMAPIRouter.getPopularUsers(params)).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            guard let jsonDictionary = response.result.value as? [String : Any], let jsonArray = jsonDictionary["users"] as? [[String: Any]] else {
                print("didn't get popular users object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let users : [GTMUserRankingInfo] = Array(JSONArray:jsonArray)
            completionHandler(.success((users, page)))
        }
    }
    
    func fetchUserReposRanking(username: String, completionHandler: @escaping (Result<GTMUserRankingInfo>) -> Void) {
        Alamofire.request(GTMAPIRouter.getUserReposRanking(username)).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            guard let jsonDictionary = response.result.value as? [String : Any], let userJsonDict = jsonDictionary["user"] as? [String: Any] else {
                print("didn't get user repos ranking object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let user = GTMUserRankingInfo(JSON: userJsonDict)!
            completionHandler(.success(user))
        }
    }
    
    func searchUsers(searchString: String, sort: String?, page: Int, completionHandler: @escaping (Result<([GTMUser], Int)>) -> Void) {
        var params = [String: Any] ()
        params["q"] = searchString
        if let sort = sort {
            params["sort"] = sort
        }
        
        Alamofire.request(GTMAPIRouter.searchUser(params)).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            guard let jsonDictionary = response.result.value as? [String : Any], let jsonArray = jsonDictionary["items"] as? [[String: Any]] else {
                print("didn't get popular users object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let users : [GTMUser] = Array(JSONArray: jsonArray)
            completionHandler(.success((users, page)))
        }
    }
    
    func searchRepos(searchString: String, sort: String?, page: Int, completionHandler: @escaping (Result<([GTMRepository], Int)>) -> Void) {
        var params = [String: Any] ()
        params["q"] = searchString
        if let sort = sort {
            params["sort"] = sort
        }
        
        Alamofire.request(GTMAPIRouter.searchRepos(params)).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            guard let jsonDictionary = response.result.value as? [String : Any], let jsonArray = jsonDictionary["items"] as? [[String: Any]] else {
                print("didn't get popular users object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let repos : [GTMRepository] = Array(JSONArray: jsonArray)
            completionHandler(.success((repos, page)))
        }
    }
    
    func fetchFollowUsers(type: GTMRepoInterestedUserType, username: String?, page: Int, completionHandler: @escaping (Result<([GTMGithubUser], Int)>) -> Void) {
        var URLRequest : URLRequestConvertible
        switch type {
        case .follower:
            URLRequest = GTMAPIRouter.getUserFollowers(username)
        case .following:
            URLRequest = GTMAPIRouter.getUserFollowing(username)
        default:
            return
        }
        Alamofire.request(URLRequest).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            guard let jsonArray = response.result.value as? [[String: Any]] else {
                print("didn't get popular users object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let users : [GTMGithubUser] = Array(JSONArray: jsonArray)
            completionHandler(.success((users, page)))
        }
    }
    
    func fetchRepoInterestedUsers(type: GTMRepoInterestedUserType, ownername: String, reponame: String, page: Int, completionHandler: @escaping (Result<([GTMGithubUser], Int)>) -> Void) {
        var URLRequest : URLRequestConvertible
        switch type {
        case .starred:
            URLRequest = GTMAPIRouter.getRepoStargazers(ownername, reponame)
        case .watching:
            URLRequest = GTMAPIRouter.getRepoWatchers(ownername, reponame)
        default:
            return
        }
        Alamofire.request(URLRequest).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            guard let jsonArray = response.result.value as? [[String: Any]] else {
                print("didn't get popular users object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let users : [GTMGithubUser] = Array(JSONArray: jsonArray)
            completionHandler(.success((users, page)))
        }
    }
    
    func fetchUserRepos(type: GTMUserReposType, username: String?, page: Int, completionHandler: @escaping (Result<([GTMRepository], Int)>) ->Void ) {
        var urlRequest : URLRequestConvertible!
        switch type {
        case .userRepos:
            urlRequest = GTMAPIRouter.getUserRepos(username)
        case .starredRepos:
            urlRequest = GTMAPIRouter.getUserStarredRepos(username)
        case .watchingRepos:
            urlRequest = GTMAPIRouter.getUserWatchingRepos(username)
        default:
            return
        }
        Alamofire.request(urlRequest).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            guard let jsonArray = response.result.value as? [[String: Any]] else {
                print("didn't get popular users object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let repos : [GTMRepository] = Array(JSONArray: jsonArray)
            completionHandler(.success((repos, page)))
        }
    }
    
    func fetchRepoForks(ownername: String, reponame: String, page: Int, completionHandler: @escaping (Result<([GTMRepository], Int)>) ->Void ) {
        Alamofire.request(GTMAPIRouter.getRepoForks(ownername, reponame)).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            guard let jsonArray = response.result.value as? [[String: Any]] else {
                print("didn't get popular users object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let repos : [GTMRepository] = Array(JSONArray: jsonArray)
            completionHandler(.success((repos, page)))
        }
    }
    
    func fetchRepoIssues(ownername: String, reponame: String, page: Int, completionHandler: @escaping (Result<([GTMIssue], Int)>) ->Void ) {
        Alamofire.request(GTMAPIRouter.getRepoIssues(ownername, reponame)).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            guard let jsonArray = response.result.value as? [[String: Any]] else {
                print("didn't get popular users object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let issues : [GTMIssue] = Array(JSONArray: jsonArray)
            completionHandler(.success((issues, page)))
        }
    }
    
    func fetchIssueComments(ownername: String, reponame: String, issueNum: Int, page: Int, completionHandler: @escaping (Result<([GTMComment], Int)>) ->Void ) {
        Alamofire.request(GTMAPIRouter.getIssueComments(ownername, reponame, issueNum)).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            guard let jsonArray = response.result.value as? [[String: Any]] else {
                print("didn't get popular users object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let comments : [GTMComment] = Array(JSONArray: jsonArray)
            completionHandler(.success((comments, page)))
        }
    }

    
    
    func fetchUserInfo(username: String?, completionHandler: @escaping (Result<GTMGithubUser>) -> Void) {
        Alamofire.request(GTMAPIRouter.getUserInfo(username)).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            
            guard let jsonDictionary = response.result.value as? [String : Any] else {
                print("didn't get popular users object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let loginUser : GTMGithubUser = GTMGithubUser(JSON: jsonDictionary)!
            completionHandler(.success(loginUser))
        }
    }
    
    func fetchFileContent(path: String, branch: String, completionHandler: @escaping(Result<String>) -> Void) {
        Alamofire.request(GTMAPIRouter.getFileContent(path, branch)).responseString { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            completionHandler(.success(response.result.value!))
        }
    }
    
    func fetchContents(path: String, branch: String, completionHandler: @escaping (Result<[GTMFileInfo]>) -> Void) {
        Alamofire.request(GTMAPIRouter.getContents(path, branch)).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                completionHandler(.failure(GTMAPIManagerError.network(error: response.result.error!)))
                return
            }
            
            guard let jsonArray = response.result.value as? [[String: Any]] else {
                print("didn't get popular users object as JSON from API")
                completionHandler(.failure(GTMAPIManagerError.objectSerialization(reason: "Didn't get JSON array")))
                return
            }
            
            let files : [GTMFileInfo] = Array(JSONArray: jsonArray)
            completionHandler(.success(files))
        }
    }
    
}
