//
//  PostCell.swift
//  FirestoreDemo
//
//  Created by Amy Alsaydi on 3/9/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    public func configureCell(post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
        usernameLabel.text = post.userUID
    }
    

}
