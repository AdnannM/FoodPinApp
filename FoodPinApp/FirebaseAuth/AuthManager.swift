//
//  AuthManager.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 24.09.21.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    public func registerUser(name: String, email: String, password: String, completion: @escaping (Bool) -> Void)
      {
          
          /*
           - Check if username is available
           - Check if email is available
           
           */
          
          DatabaseManager.shared.canCreateNewUser(with: email, name: name) { canCreate in
              if canCreate {
                  /*
                   - Create Account
                   - Create Account to database
                   */
                  Auth.auth().createUser(withEmail: email, password: password) { user, error in
                      guard error == nil,  user != nil  else {
                          return
                      }
                      
                      // Inser to database
                      DatabaseManager.shared.inserNewUser(with: email, name: name) { inserted in
                          if inserted {
                              completion(true)
                              return
                          } else {
                              completion(false)
                              return
                          }
                      }
                  }
              } else {
                  // Either user name or email does not exist
                  
              }
          }
    }
    
    public func loginUser(email: String?, password: String, completion: @escaping(Bool) -> Void) {
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard  authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            }
        }
    }
    
    public func saveUserName(name: String, completion: @escaping(Error?) -> Void) {
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Failed to change dispay name \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func logoutUser() {
        
    }
}
