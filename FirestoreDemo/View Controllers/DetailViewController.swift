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
    @IBOutlet weak var commentTextField: UITextField!
    
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
        commentTextField.delegate = self

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
        
        guard let comment = commentTextField.text, !comment.isEmpty else {
            presentGenericAlert(withTitle: "No comment", andMessage: "Write up a comment in the field")
            return
        }
        
        FirestoreService.manager.postComment(post: post, comment: comment) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentGenericAlert(withTitle: "Try again", andMessage: error.localizedDescription)
                }
                
            case .success:
                DispatchQueue.main.async {
                    self.presentGenericAlert(withTitle: "Comment posted", andMessage: "success")
                    self.commentTextField.text = ""
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

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
    }
}
