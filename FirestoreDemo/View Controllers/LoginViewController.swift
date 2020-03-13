import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    // MARK: -IBOutlets
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    // MARK: -Private Properties
    
    private var validUserCredentials: (email: String, password: String)? {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              emailFieldIsValid() else {
                return nil
        }
        
        return (email, password)
    }
    
    // MARK: -IBActions
        
    @IBAction func signInUser(_ sender: Any) {
        guard let validCredentials = validUserCredentials else {
            handleInvalidFields()
            return
        }
        FirebaseAuthService.manager.loginUser(withEmail: validCredentials.email,
                                              andPassword: validCredentials.password,
                                              onCompletion: { [weak self] (result) in self?.handleLogInResponse(withResult: result) })
    }
    
    @IBAction func createNewUserAccount(_ sender: Any) {
        guard let validCredentials = validUserCredentials else { return }
        FirebaseAuthService.manager.createNewUser(withEmail: validCredentials.email,
                                                  andPassword: validCredentials.password,
                                                  onCompletion: { [weak self] (result) in self?.handleCreateUserResponse(withResult: result) })
    }
    
    // MARK: -Private methods
    
    private func handleLogInResponse(withResult result: Result<User, Error>) {
        switch result {
        case .success:
            performSegue(withIdentifier: "loginSegue", sender: nil)
        case let .failure(error):
            presentGenericAlert(withTitle: "Login Failure",
                                andMessage: "An error occurred while logging in: \(error.localizedDescription)")
        }
    }
    
    private func handleCreateUserResponse(withResult result: Result<User, Error>) {
        switch result {
        case let .success(user):
            FirestoreService.manager.create(PersistedUser(from: user)) { [weak self] result in
                self?.handleCreateUserInDatabaseResponse(withResult: result)
            }
        case let .failure(error):
            presentGenericAlert(withTitle: "Create user failure",
                                andMessage: "An error occurred while creating an account: \(error.localizedDescription)")
        }
    }
    
    private func handleCreateUserInDatabaseResponse(withResult result: Result<Void, Error>) {
        switch result {
        case .success:
            performSegue(withIdentifier: "loginSegue", sender: nil)
        case let .failure(error):
            print("An error occurred peristing the user to Firestore: \(error)")
        }
    }
    
    private func handleInvalidFields() {
        // TODO: Complete implementation
    }
    
    private func emailFieldIsValid() -> Bool {
        // TODO: Complete implementation
        return true
    }
    
    private func presentGenericAlert(withTitle title: String, andMessage message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

