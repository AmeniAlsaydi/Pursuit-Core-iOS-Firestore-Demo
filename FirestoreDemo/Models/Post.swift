import Foundation
import FirebaseFirestore

struct Post {
    let title: String
    let body: String
    let uuid: UUID
    let userUID: String
    let createdDate: Timestamp
    
    init(title: String, body: String, userUID: String, createdDate: Timestamp) {
        self.title = title
        self.body = body
        self.uuid = UUID()
        self.userUID = userUID
        self.createdDate = createdDate
        
    }
    
    init?(from dict: [String: Any]) {
        guard let title = dict["title"] as? String else {
                print("issue title")
                return nil
        }
        guard let body = dict["body"] as? String else {
                print("issue body")
                return nil
        }
        guard let userUID = dict["userUID"] as? String else {
                print("issue userUID")
                return nil
        }
        guard let uuidString = dict["uuid"] as? String, let uuid =  UUID(uuidString: uuidString) else {
                print(dict["uuid"] ?? "hello")
                print("issue uuid")
                return nil
        }
        guard let createdDate = dict["createdDate"] as? Timestamp else {
            print(dict["createdDate"] ?? "no date")
                print("issue date")
                return nil
        }

        self.title = title
        self.body = body
        self.userUID = userUID
        self.uuid = uuid
        self.createdDate = createdDate
    }
    
    var uuidStr: String {
        return uuid.uuidString // used when creating a post (document) ID
    }
    
    var fieldsDict: [String: Any] {
        return [
            "title": title,
            "body": body,
            "uuid": uuidStr,
            "userUID": userUID,
            "createdDate": createdDate
        ]
    }
}
