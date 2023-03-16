//
//  User.swift
//  chargd
//
//

import Foundation


struct User: Decodable {
    let battery: String
    let is_plugin: String
    let timestamp: String
    let caption: String
}
