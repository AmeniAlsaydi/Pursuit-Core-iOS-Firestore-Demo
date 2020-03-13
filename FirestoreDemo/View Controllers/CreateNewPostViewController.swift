import UIKit
import FirebaseFirestore

class CreateNewPostViewController: UIViewController {
    
    // MARK: -IBOutlets
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    
    // MARK: -IBActions
    
    @IBAction func submitPost(_ sender: UIButton) {
        guard let title = titleTextField.text,
            let body = bodyTextView.text,
            let user = FirebaseAuthService.manager.currentUser,
            titleIsValid() && bodyIsValid() else {
            handleInvalidFields()
            return
        }
        
        let newPost = Post(title: title, body: body, userUID: user.uid, createdDate: Timestamp(date: Date()))
        
        FirestoreService.manager.create(newPost) { [weak self] (result) in
            self?.handlePostResponse(withResult: result)
        }
    }
    
    // MARK: -Private Methods
    
    private func handlePostResponse(withResult result: Result<Void, Error>) {
        switch result {
        case .success:
            print("Post created")
        case let .failure(error):
            print("An error occurred creating the post: \(error)")
        }
    }
    
    private func handleInvalidFields() {
        //TODO: Handle invalid fields
    }
    
    private func titleIsValid() -> Bool {
        //TODO: Validate title
        return true
    }
    private func bodyIsValid() -> Bool {
        //TODO: Validate body
        return true
    }
}
