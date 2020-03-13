//
//  DetailViewController.swift
//  FirestoreDemo
//
//  Created by Amy Alsaydi on 3/10/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import UIKit
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "EEEE, MMM, d, h:m a"
          return formatter
      }()
    
    private var post: Post
    private var comments = [Comment]()
    
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
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    private func updateUI() {
        titleLabel.text = post.title
        bodyLabel.text = post.body
        // usernameLabel.text = post.userUID // should be the users email 
        dateLabel.text = dateFormatter.string(from: post.createdDate.dateValue())
        
        let db = Firestore.firestore()
        let postsRef = db.collection("users")
        
        postsRef.document(post.userUID).getDocument { (snapshot , error) in
            if let error = error {
                print("\(error)")
            } else if let snapshot = snapshot {
                guard let dictData = snapshot.data() else {
                    return
                }
                let user = PersistedUser(dictData)
                self.usernameLabel.text = "POSTED BY: \(user.email ?? "Anonymous")"
            }
        }
        
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        
        // in db services add a post comment function and call it here. it shoud take in the current post and use the info as properties of the comment
        /*
         comment will have
         - text
         - created by
         - date posted
         
         */
        FirestoreService.manager.postComment(post: post, comment: "comment 1") { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentGenericAlert(withTitle: "Try again", andMessage: error.localizedDescription)
                }
                
            case .success:
                DispatchQueue.main.async {
                    self.presentGenericAlert(withTitle: "Comment posted", andMessage: "success")
                }
            }
        }
        
        
        
        
    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    
}
