//
//  UserModel.swift
//  GitLabTracker
//
//  Created by Benjamin_Budet on 29/06/2018.
//  Copyright © 2018 Benjamin Budet. All rights reserved.
//

import Foundation
import Alamofire

class UserModel {
    private var _username: String?
    open var id: Int?
    private var token: String?
    open var state: String?
    open var avatarURL: URL?
    open var webURL: URL?
    open var createdAt: Date?
    open var isAdmin: Bool?
    open var bio: String?
    open var name: String?
    open var location: String?
    open var skype: String?
    open var linkedin: String?
    open var twitter: String?
    open var websiteURL: URL?
    open var lastSignInAt: Date?
    open var confirmedAt: Date?
    open var email: String?
    open var themeId: Int?
    open var colorSchemeId: Int?
    open var projectsLimit: Int?
    open var currentSignInAt: Date?
    open var canCreateGroup: Bool?
    open var canCreateProject: Bool?
    let url = URL(string: "https://gitlab.com/api/v4/user")!
    
    let headers: HTTPHeaders = [
        "Private-Token": UserDefaults.standard.value(forKey: "token") as! String,
        "Accept": "application/json"
    ]
    func downloadData(completed: @escaping ()-> ()) {
        Alamofire.request(url, headers: headers)
            .responseJSON(completionHandler: {
            response in
            let result = response.result
            if let dict = result.value as? [String: Any] {
                if let id = dict["id"] as? Int {
                    self.name = dict["name"] as? String
                    self._username = dict["username"] as? String
                    self.id = id
                    self.state = dict["state"] as? String
                    if let urlString = dict["avatar_url"] as? String, let url = URL(string: urlString) {
                        self.avatarURL = url
                    }
                    if let urlString = dict["web_url"] as? String, let url = URL(string: urlString) {
                        self.self.webURL = url
                    }
                    //createdAt = Time.rfc3339Date(dict["created_at"] as? String)
                    self.isAdmin = dict["is_admin"] as? Bool
                    self.bio = dict["bio"] as? String
                    self.location = dict["location"] as? String
                    self.skype = dict["skype"] as? String
                    self.linkedin = dict["linkedin"] as? String
                    self.twitter = dict["twitter"] as? String
                    if let urlString = dict["website_url"] as? String, let url = URL(string: urlString) {
                        self.websiteURL = url
                    }
                    //lastSignInAt = Time.rfc3339Date(dict["last_sign_in_at"] as? String)
                    //confirmedAt = Time.rfc3339Date(dict["confirmed_at"] as? String)
                    self.email = dict["email"] as? String
                    self.themeId = dict["theme_id"] as? Int
                    self.colorSchemeId = dict["color_scheme_id"] as? Int
                    self.projectsLimit = dict["projects_limit"] as? Int
                    //currentSignInAt = Time.rfc3339Date(dict["current_sign_in_at"] as? String)
                    self.canCreateGroup = dict["can_create_group"] as? Bool
                    self.canCreateProject = dict["can_create_project"] as? Bool
                } else {
                    self.id = -1
                }
                UserDefaults.standard.setValue(self.id, forKey: "idUser")
            }
            completed()
        })
    }
    
    
    func getEventsForUser(idUser: Int, completed: @escaping ([EventModel]) -> ()) {
        let urlString = "https://gitlab.com/api/v4/users/\(idUser)/events"
        let url = URL(string: urlString)
        var res: [EventModel] = []
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
                            guard let actionName = newDict["action_name"] as? String else {continue}
                            guard let createdAt = newDict["created_at"] as? String else {continue}
                            guard let authorUsername = newDict["author_username"] as? String else {continue}
                            let event = EventModel()
                            event.actionDate = createdAt
                            if (actionName == "opened" || actionName == "accepted") { // MR, ISSUE
                                let target_type = newDict["target_type"] as? String
                                let target_title = newDict["target_title"] as? String
                                let msg = "\(authorUsername) \(actionName) a new \(target_type!): \(target_title!)"
                                event.message = msg
                                event.actionName = actionName
                                event.authorName = authorUsername
                            } else {
                                guard let pushDict = newDict["push_data"] as? [String: Any] else {break}
                                let branch = pushDict["ref"] as? String ?? ""
                                let commit_title = pushDict["commit_title"] as? String ?? ""
                                event.actionName = actionName
                                event.authorName = authorUsername
                                let msg = "\(authorUsername) \(actionName) \(branch) : \(commit_title)"
                                event.message = msg
                            }
                            res.append(event)
                        }
                    }
                case .failure(_):
                    print("error")
                }
                completed(res)
            })
    }
}
