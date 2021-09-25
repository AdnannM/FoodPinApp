//
//  DatabaseManager.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 25.09.21.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database(url: "https://foodpin-72ab9-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    
    /// Check if name and emal available
    /// - Parameters
    ///  - Email String representing email
    public func canCreateNewUser(with email: String, name: String, completion: @escaping(Bool)-> Void) {
        completion(true)
    }
    
    /// Inser New User to Database
    /// - Parameters
    ///  - l
    public func inserNewUser(with email: String, name: String, completion: @escaping(Bool) -> Void) {
        database.child(email.saveKey()).setValue(["name": name]) { error, _ in
            if error == nil  {
                completion(true)
                return
            } else {
                // Failed
                completion(false)
                return
            }
        }
    }
}

extension String {
    func saveKey() -> String {
        return self.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
    }
}
