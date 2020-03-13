//
//  Comment.swift
//  FirestoreDemo
//
//  Created by Amy Alsaydi on 3/11/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    let commentedBy: String
    let text: String
    let commentDate: Timestamp

}

extension Comment {
    init(_ dictionary: [String: Any]) {
        self.commentDate = dictionary["commentDate"] as? Timestamp ?? Timestamp(date: Date())
        self.commentedBy = dictionary["commentedBy"] as? String ?? "no commented by name"
        self.text = dictionary["text"] as? String ?? "no comment text"
    }
}
