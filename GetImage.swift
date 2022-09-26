//
//  GetImage.swift
//  IOSTraining
//
//  Created by ERT_Macbook_112 on 5/17/22.
//

import Foundation
struct ImageInfo: Codable {
    let urls: Urls
    var width: Int?
    var height: Int?
    var description: String?
    var user: User
}
struct User: Codable {
    var name: String?
}

struct Urls: Codable {
    let small: String
    let regular: String
    var regularUrl: URL {
        return URL(string: regular)!
    }
    var smallUrl: URL {
        return URL(string: small)!
    }
}
