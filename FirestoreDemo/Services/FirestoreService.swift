import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    
    // MARK:- Static Properties
    
    static let manager = FirestoreService()
    
    // MARK:- Internal Properties
    
    func getPosts(onCompletion: @escaping (Result<[Post], Error>) -> Void) {
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                onCompletion(.failure(err))
            } else {
                let posts = querySnapshot!.documents.compactMap { (snapShot) -> Post? in
                    // it goes through the posts but does not return a post - issue with initializer
                    //guard let uuid = UUID(uuidString: snapShot.documentID) else { return nil }
                    return Post(from: snapShot.data())
                }
                onCompletion(.success(posts.sorted {$0.createdDate.dateValue() > $1.createdDate.dateValue()} ))  // sorts from most recent to least recent?
            }
        }
    }
    
    func create(_ user: PersistedUser, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(user.uid).setData(user.fieldsDict) { err in
            if let err = err {
                onCompletion(.failure(err))
            } else {
                onCompletion(.success(()))
            }
        }
    }
    
    func create(_ post: Post, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        
        db.collection("posts").document(post.uuidStr).setData(post.fieldsDict) { err in
            if let err = err {
                onCompletion(.failure(err))
            } else {
                onCompletion(.success(()))
            }
        }
    }
    
    
    public func postComment(post: Post, comment: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        // in db services add a post comment function and call it here. it shoud take in the current post and use the info as properties of the comment
               /*
                comment will have
                - text
                - created by
                - date posted
                */
        
        guard let user = Auth.auth().currentUser, let email = user.email  else { return }
        
        let docRef =  db.collection("posts").document(post.uuidStr).collection("comments").document() // creates doc idea
        
        db.collection("posts").document(post.uuidStr).collection("comments").document(docRef.documentID).setData(["text" : comment, "commentDate": Timestamp(date: Date()), "commentedBy": email]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
               completion(.success(true))
            }
        }
        
        
        
    }
    
    // MARK:- Private Properties
    
    private let db = Firestore.firestore()
}
