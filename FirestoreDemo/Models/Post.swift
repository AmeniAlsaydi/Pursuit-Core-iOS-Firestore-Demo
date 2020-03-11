import Foundation

struct Post {
    let title: String
    let body: String
    let uuid: UUID
    let userUID: String
    let createdDate: Date
    
    init(title: String, body: String, userUID: String, createdDate: Date) {
        self.title = title
        self.body = body
        self.uuid = UUID()
        self.userUID = userUID
        self.createdDate = createdDate
        
    }
    
    init?(from dict: [String: Any], andUUID uuid: UUID) {
        guard let title = dict["title"] as? String,
            let body = dict["body"] as? String,
            let userUID = dict["userUID"] as? String,
            let createdDate = dict["createdDate"] as? Date else {
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
