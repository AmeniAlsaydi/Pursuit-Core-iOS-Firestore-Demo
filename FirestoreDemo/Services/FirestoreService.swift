import FirebaseFirestore

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
                onCompletion(.success(posts))
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
    
    // MARK:- Private Properties
    
    private let db = Firestore.firestore()
}
