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

    
    private var post: Post
    
    private var listener: ListenerRegistration?
    
    private var comments = [Comment]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    init?(coder: NSCoder, post: Post) {
        self.post = post
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // set up listener
        listener = Firestore.firestore().collection("posts").document(post.uuidStr).collection("comments").addSnapshotListener({ (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.presentGenericAlert(withTitle: "Try again", andMessage: error.localizedDescription)
                }
            } else if let snapshot = snapshot {
                
                // create comments using dictionary intializer from the comment model
                let comments = snapshot.documents.map {Comment($0.data())}
                self.comments = comments.sorted {$0.commentDate.dateValue() > $1.commentDate.dateValue()} // from most recent to least 
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        tableView.dataSource = self
        tableView.delegate = self
        commentTextField.delegate = self
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "postCell")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener?.remove()
    }
    
    private func updateUI() {
        titleLabel.text = post.title
        bodyLabel.text = post.body
        // usernameLabel.text = post.userUID // should be the users email 
        dateLabel.text = post.createdDate.dateValue().dateString()
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostCell else {
            fatalError("could not down cast to custom cell")
        }
        let comment = comments[indexPath.row]
        cell.configureCell(for: comment)
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
    }
}
