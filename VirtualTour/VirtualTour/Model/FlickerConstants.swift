//
//  FlickerConstants.swift
//  VirtualTour
//
//  Created by Antarpunit Singh on 2012-05-11.
//  Copyright © 2020 AntarpunitSingh. All rights reserved.
//

import Foundation

struct FlickerConstants {
    
    static let scheme = "https"
    static let host = "www.flickr.com"
    static let path = "/services/rest/"
    static var queryDict = [FlickerConstants.urlKeys.method:FlickerConstants.urlValues.method,
                            FlickerConstants.urlKeys.api:FlickerConstants.urlValues.api,
                            FlickerConstants.urlKeys.box:FlickerConstants.urlValues.bboxValue,
                            FlickerConstants.urlKeys.format:FlickerConstants.urlValues.format,
                            FlickerConstants.urlKeys.jsonCallBack:FlickerConstants.urlValues.jsonCallBack,
                            FlickerConstants.urlKeys.perPage:FlickerConstants.urlValues.perPageCount      ]
    
    struct urlKeys {
        static let method = "method"
        static let api = "api_key"
        static let box = "bbox"
        static let format = "format"
        static let jsonCallBack = "nojsoncallback"
        static let perPage = "per_page"
    }
    struct urlValues {
        static let method = "flickr.photos.search"
        static let api = "61e2adadd43fb34303b5a876fe7e8b41"
        static let bboxValue = ""
        static let format = "json"
        static let jsonCallBack = "1"
        static let perPageCount = "30"
        
    }
}

