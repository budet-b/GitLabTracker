//
//  GroupModel.swift
//  GitLabTracker
//
//  Created by Benjamin_Budet on 29/06/2018.
//  Copyright © 2018 Benjamin Budet. All rights reserved.
//

import Foundation
import Alamofire

class GroupeModel {
    
    open var id: Int?
    open var name: String?
    open var avatarURL: URL?

    let headers: HTTPHeaders = [
        "Private-Token": UserDefaults.standard.value(forKey: "token") as! String,
        "Accept": "application/json"
    ]
    func downloadData(completed: @escaping ([GroupeModel]) -> ()) {
        let urlString = "https://gitlab.com/api/v4/groups"
        let url = URL(string: urlString)
        var res: [GroupeModel] = []
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
                            var tmp = GroupeModel()
                            guard let newDict = dict[index] as? [String: Any] else { break }
                            tmp.name = newDict["name"] as? String
                            if let urlString = newDict["avatar_url"] as? String, let url = URL(string: urlString) {
                                tmp.avatarURL = url
                            } else {
                                let url = URL(string: "http://via.placeholder.com/75x75.png")
                                tmp.avatarURL = url
                            }
                            tmp.id = newDict["id"] as? Int
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
