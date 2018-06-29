//
//  ProjectModel.swift
//  GitLabTracker
//
//  Created by Benjamin_Budet on 29/06/2018.
//  Copyright © 2018 Benjamin Budet. All rights reserved.
//

import Foundation
import Alamofire

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
    open var createdAt: Date?
    open var lastActivityAt: Date?
    open var lfsEnabled: Bool?
    open var onlyAllowMergeIfBuildSucceeds: Bool?
    open var requestAccessEnabled: Bool?
    
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
                            var tmp = ProjectModel()
                            guard let newDict = dict[index] as? [String: Any] else { break }
                            tmp.name = newDict["name"] as? String
                            res.append(tmp)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            completed(res)
        })
    }
}
