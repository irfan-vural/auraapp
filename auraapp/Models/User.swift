//
//  User.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//

import Foundation


struct User: Codable {
    var id: String?
    var name: String?
    var email: String?
    var token: String?
    var joined: TimeInterval?
}
