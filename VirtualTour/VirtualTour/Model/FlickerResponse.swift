//
//  FlickerResponse.swift
//  VirtualTour
//
//  Created by Antarpunit Singh on 2012-05-13.
//  Copyright © 2020 AntarpunitSingh. All rights reserved.
//

import Foundation

struct FlickerResponse : Codable {
    let photos : Photos
    let stat: String
}
struct Photos:Codable {
    let page : Int
    let pages: Int
    let perpage : Int
    let total: String
    let photo : [Photo]
    
}
struct Photo: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var isPublic: Int?
    var isFriend: Int?
    var isFamily: Int?
    
}
