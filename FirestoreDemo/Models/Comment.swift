//
//  Comment.swift
//  FirestoreDemo
//
//  Created by Amy Alsaydi on 3/11/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import Foundation

struct Comment {
    let userId: String
    let postId: String
    let comment: String
    let datePosted: Date
    let uuid: UUID
    
    init(userId: String, postId: String, comment: String, datePosted: Date) {
        self.userId = userId
        self.postId = postId
        self.comment = comment
        self.datePosted = datePosted
        self.uuid = UUID()
    }
    init?(from dict: [String: Any], andUUID uuid: UUID) {
        guard let userId = dict["userId"] as? String,
            let postId = dict["postId"] as? String,
        let comment = dict["comment"] as? String,
            let datePosted = dict["datePosted"] as? Date else {
                return nil
        }
        self.userId = userId
        self.postId = postId
        self.comment = comment
        self.datePosted = datePosted
        self.uuid = uuid
    }
    var uuidStr: String {
        return uuid.uuidString
    }
    var fieldsDict: [String: Any] {
        return [
            "userId": userId,
            "postId": postId,
            "comment": comment
        ]
    }
}
