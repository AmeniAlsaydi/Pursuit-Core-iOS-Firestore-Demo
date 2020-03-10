//
//  DetailViewController.swift
//  FirestoreDemo
//
//  Created by Amy Alsaydi on 3/10/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var post: Post
    
    init?(coder: NSCoder, post: Post) {
        self.post = post
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Do any additional setup after loading the view.
    }
    
    private func updateUI() {
        titleLabel.text = post.title
        bodyLabel.text = post.body
        usernameLabel.text = post.userUID
        dateLabel.text = Date().description
    }


}
