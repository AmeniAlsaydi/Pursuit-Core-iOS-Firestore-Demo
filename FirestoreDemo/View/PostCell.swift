//
//  PostCell.swift
//  FirestoreDemo
//
//  Created by Amy Alsaydi on 3/9/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PostCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    public func configureCell(post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
        //usernameLabel.text = post.userUID
        
    }
    
    public func getUserInfo(userID: String) {
        let db = Firestore.firestore()
        let postsRef = db.collection("users")
        
        postsRef.document(userID).getDocument { (snapshot , error) in
            if let error = error {
                print("\(error)")
            } else if let snapshot = snapshot {
                guard let dictData = snapshot.data() else {
                    return
                }
                let user = PersistedUser(dictData)
                self.usernameLabel.text = "POSTED BY: \(user.email ?? "Anonymous")"
                //print(user.email)
            }
        }
    }
}
