//
//  Alert.swift
//  FirestoreDemo
//
//  Created by Amy Alsaydi on 3/13/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import UIKit


extension UIViewController {
    
    public func presentGenericAlert(withTitle title: String, andMessage message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
