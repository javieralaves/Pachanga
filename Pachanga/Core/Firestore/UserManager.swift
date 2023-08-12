//
//  UserManager.swift
//  Pachanga
//
//  Created by Javier Alaves on 12/8/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        
        var userData: [String : Any] = [
            "user_id" : auth.uid,
            "date_created" : Timestamp(),
            
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        if let photoUrl = auth.photoURL {
            userData["photo_url"] = photoUrl
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
}
