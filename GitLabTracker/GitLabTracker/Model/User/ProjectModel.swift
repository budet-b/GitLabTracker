//
//  ProjectModel.swift
//  GitLabTracker
//
//  Created by Benjamin_Budet on 29/06/2018.
//  Copyright © 2018 Benjamin Budet. All rights reserved.
//

import Foundation
import Alamofire

class PipelineModel {
    open var id: Int?
    open var ref: String?
    open var status: String?
    open var createdAt: String?
    open var finishedAt: String?
    open var duration: Int?
    open var triggerByName: String?
    open var triggerByUserame: String?
    open var triggerByUrl: String?

}

class CIModel {
    open var id: Int?
    open var ref: String?
    open var status: String?
}

class CommitModel {
    open var id: String?
    open var title: String?
    open var author_name: String?
    open var committed_date: Date?
    open var message: String = ""
    
    init(id: String, title: String, author: String) {
        self.id = id
        self.title = title
        self.author_name = author
    }
    
    init(id: String, title: String, author: String, message: String) {
        self.id = id
        self.title = title
        self.author_name = author
        self.message = message
    }
}

class BranchModel {
    open var name: String?
    open var commit: CommitModel?
    open var merged: Bool?
    open var protected: Bool?
}

class ProjectModel {
    open var id: Int?
    open var name: String?
    open var nameWithNamespace: String?
    open var isPrivate: Bool?
    open var projectDescription: String?
    open var sshURL: URL?
    open var cloneURL: URL?
    open var webURL: URL?
    open var path: String?
    open var pathWithNamespace: String?
    open var containerRegisteryEnabled: Bool?
    open var defaultBranch: String?
    open var tagList: [String]?
    open var isArchived: Bool?
    open var issuesEnabled: Bool?
    open var mergeRequestsEnabled: Bool?
    open var wikiEnabled: Bool?
    open var buildsEnabled: Bool?
    open var snippetsEnabled: Bool?
    open var sharedRunnersEnabled: Bool?
    open var creatorID: Int?
    open var avatarURL: URL?
    open var starCount: Int?
    open var forksCount: Int?
    open var openIssuesCount: Int?
    open var runnersToken: String?
    open var publicBuilds: Bool?
    open var createdAt: String?
    open var lastActivityAt: String?
    open var lfsEnabled: Bool?
    open var onlyAllowMergeIfBuildSucceeds: Bool?
    open var requestAccessEnabled: Bool?
    open var visibility: String?
    
    let headers: HTTPHeaders = [
        "Private-Token": UserDefaults.standard.value(forKey: "token") as! String,
        "Accept": "application/json"
    ]
    func downloadData(completed: @escaping ([ProjectModel]) -> ()) {
        let idUser = UserDefaults.standard.value(forKey: "idUser") ?? -1
        let urlString = "https://gitlab.com/api/v4/users/\(idUser)/projects"
        let url = URL(string: urlString)
        var res: [ProjectModel] = []
        Alamofire.request(url!, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let result = response.result
                    if let dict = result.value as? [[String: Any]] {
                        print("success")
                        for index in 0..<dict.count {
                            let tmp = ProjectModel()
                            let newDict = dict[index]
                            tmp.id = newDict["id"] as? Int
                            tmp.name = newDict["name"] as? String
                            tmp.visibility = newDict["visibility"] as? String
                            tmp.lastActivityAt = newDict["last_activity_at"] as? String
                            tmp.defaultBranch = newDict["default_branch"] as? String
                            tmp.createdAt = newDict["created_at"] as? String
                            let urlGit = newDict["ssh_url_to_repo"] as? String ?? ""
                            tmp.sshURL = URL(string: urlGit)
                            if let urlString = newDict["avatar_url"] as? String, let url = URL(string: urlString) {
                                tmp.avatarURL = url
                            } else {
                                let url = URL(string: "http://via.placeholder.com/75x75.png")
                                tmp.avatarURL = url
                            }
                            res.append(tmp)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            completed(res)
        })
    }
    
    func getProjectFromGroup(idGroup: Int, completed: @escaping ([ProjectModel]) -> ()) {
        let urlString = "https://gitlab.com/api/v4/groups/\(idGroup)/projects"
        let url = URL(string: urlString)
        var res: [ProjectModel] = []
        Alamofire.request(url!, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let result = response.result
                    if let dict = result.value as? [[String: Any]] {
                        print("success")
                        for index in 0..<dict.count {
                            let tmp = ProjectModel()
                            let newDict = dict[index]
                            tmp.id = newDict["id"] as? Int
                            tmp.name = newDict["name"] as? String
                            tmp.visibility = newDict["visibility"] as? String
                            tmp.lastActivityAt = newDict["last_activity_at"] as? String
                            tmp.defaultBranch = newDict["default_branch"] as? String
                            tmp.createdAt = newDict["created_at"] as? String
                            let urlGit = newDict["ssh_url_to_repo"] as? String ?? ""
                            tmp.sshURL = URL(string: urlGit)
                            if let urlString = newDict["avatar_url"] as? String, let url = URL(string: urlString) {
                                tmp.avatarURL = url
                            } else {
                                let url = URL(string: "http://via.placeholder.com/75x75.png")
                                tmp.avatarURL = url
                            }
                            res.append(tmp)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                completed(res)
            })
    }
    
    func getBranchs(idProject: Int, completed: @escaping ([BranchModel]) -> ()) {
        let urlString = "https://gitlab.com/api/v4/projects/\(idProject)/repository/branches"
        let url = URL(string: urlString)
        var res: [BranchModel] = []
        Alamofire.request(url!, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let result = response.result
                    if let dict = result.value as? [[String: Any]] {
                        print("success")
                        for index in 0..<dict.count {
                            let tmp = BranchModel()
                            let newDict = dict[index]
                            tmp.name = newDict["name"] as? String
                            tmp.merged = newDict["merged"] as? Bool
                            tmp.protected = newDict["protected"] as? Bool
                            guard let commitDict = newDict["commit"] as? [String: Any] else { continue }
                            let idCommit = commitDict["id"] as? String
                            let titleCommit = commitDict["title"] as? String
                            let authorCommit =  commitDict["author_name"] as? String
                            //let dateCommit = commitDict["committed_date"] as? String
                            let commit = CommitModel(id: idCommit!, title: titleCommit!, author: authorCommit!)
                            tmp.commit = commit
                            res.append(tmp)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                completed(res)
            })
    }
    
    func getCommits(idProject: Int, completed: @escaping ([CommitModel]) -> ()) {
        let urlString = "https://gitlab.com/api/v4/projects/\(idProject)/repository/commits"
        let url = URL(string: urlString)
        var res: [CommitModel] = []
        Alamofire.request(url!, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let result = response.result
                    if let dict = result.value as? [[String: Any]] {
                        print("success")
                        for index in 0..<dict.count {
                            let newDict = dict[index]
                            guard let idCommit = newDict["id"] as? String else {continue}
                            guard let titleCommit = newDict["title"] as? String else {continue}
                            guard let authorCommit =  newDict["author_name"] as? String else {continue}
                            guard let messageCommit = newDict["message"] as? String else {continue}
                            let tmp = CommitModel(id: idCommit, title: titleCommit, author: authorCommit, message: messageCommit)
                            res.append(tmp)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                completed(res)
            })
    }
    
    func getCI(idProject: Int, completed: @escaping ([CIModel]) -> ()) {
        let urlString = "https://gitlab.com/api/v4/projects/\(idProject)/pipelines"
        let url = URL(string: urlString)
        var res: [CIModel] = []
        Alamofire.request(url!, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let result = response.result
                    if let dict = result.value as? [[String: Any]] {
                        print("success")
                        for index in 0..<dict.count {
                            let newDict = dict[index]
                            guard let idCI = newDict["id"] as? Int else {continue}
                            guard let refCI = newDict["ref"] as? String else {continue}
                            guard let statusCI =  newDict["status"] as? String else {continue}
                            let ci = CIModel()
                            ci.id = idCI
                            ci.ref = refCI
                            ci.status = statusCI
                            res.append(ci)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                completed(res)
            })
    }
    
    func getSingleCI(idProject: Int, idPipeline: Int, completed: @escaping (PipelineModel?) -> ()) {
        let urlString = "https://gitlab.com/api/v4/projects/\(idProject)/pipelines/\(idPipeline)"
        let url = URL(string: urlString)
        Alamofire.request(url!, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let result = response.result
                    if let dict = result.value as? [String: Any] {
                        print("success")
                        guard let idCI = dict["id"] as? Int else {return}
                        guard let refCI = dict["ref"] as? String else {return}
                        guard let statusCI =  dict["status"] as? String else {return}
                        guard let createdAt = dict["created_at"] as? String else {return}
                        guard let finishedAt = dict["finished_at"] as? String else {return}
                        guard let duration =  dict["duration"] as? Int else {return}
                        
                        guard let newDict = dict["user"] as? [String: Any] else {return}
                        guard let userName = newDict["name"] as? String else {return}
                        guard let userUsername = newDict["username"] as? String else {return}
                        guard let userAvatar = newDict["avatar_url"] as? String else {return}
                        let pipeline = PipelineModel()
                        pipeline.id = idCI
                        pipeline.ref = refCI
                        pipeline.status = statusCI
                        pipeline.createdAt = createdAt
                        pipeline.finishedAt = finishedAt
                        pipeline.duration = duration
                        pipeline.triggerByName = userName
                        pipeline.triggerByUserame = userUsername
                        pipeline.triggerByUrl = userAvatar
                        completed(pipeline)
                    }
                case .failure(let error):
                    print(error)
                }
                completed(nil)
            })
    }
    
}
