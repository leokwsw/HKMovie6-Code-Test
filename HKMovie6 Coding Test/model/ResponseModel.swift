//
//  Model.swift
//  HKMovie6 Coding Test
//
//  Created by Leo Wu on 18/8/2021.
//

import UIKit

struct MovieModel: Codable {
    let uuid: String?
    let name: String?
    let openDate: Double?
    let poster: String?
    let rating: Double?
    let likeCount: Int?
    let reviewCount: Int?
    let duration: Int?
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case name = "name"
        case openDate = "openDate"
        case poster = "poster"
        case rating = "rating"
        case likeCount = "likeCount"
        case reviewCount = "reviewCount"
        case duration = "duration"
    }
    
}
