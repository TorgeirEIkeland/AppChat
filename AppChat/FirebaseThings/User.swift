//
//  User.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 30/09/2022.
//

import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
