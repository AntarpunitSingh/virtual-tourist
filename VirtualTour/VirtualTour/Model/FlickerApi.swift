//
//  FlickerApi.swift
//  VirtualTour
//
//  Created by Antarpunit Singh on 2012-05-11.
//  Copyright © 2020 AntarpunitSingh. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FlickerApi {
    
    class func getbbox(lat:Double, long:Double) -> String {
        let minLon = max(long - 1.0, (-180.0, 180.0).0)
        let minLat = max(lat - 1.0, (-90.0, 90.0).0)
        let maxLon = min(long + 1.0, (-180.0, 180.0).1)
        let maxLat = min(lat + 1.0, (-90.0, 90.0).1)

        return "\(minLon),\(minLat),\(maxLon),\(maxLat)"
    }
    class func generateUrl(lat:Double, long:Double) -> URL? {
        let bbox = getbbox(lat: lat, long: long)
        FlickerConstants.queryDict.updateValue(bbox, forKey: FlickerConstants.urlKeys.box)
        var url = URLComponents()
        url.scheme = FlickerConstants.scheme
        url.host = FlickerConstants.host
        url.path = FlickerConstants.path
        var queryItem = [URLQueryItem]()
        
        for q in FlickerConstants.queryDict {
            let item = URLQueryItem(name: q.key, value: q.value)
            queryItem.append(item)
        }
        url.queryItems = queryItem
        guard let fullUrl = url.url else {
            print("error in url generating")
            return nil}
        return fullUrl
    }
    class func taskGetRequest<responseType:Decodable>(url : URL,responseType: responseType.Type, completion: @escaping(responseType? ,Error?)->Void){
        let taskForGet = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                
                    completion(nil,error)
                return
            }
            do {
                let decode = try JSONDecoder().decode(responseType.self, from: data)
                DispatchQueue.main.async {
                    completion(decode , nil)
                }
            }
            catch {
                    completion(nil,error)
            }
        }
        taskForGet.resume()
    }
    class func downloadPhotos(url:URL,completion: @escaping(Data?,Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil,error)
                return
            }
            completion(data,nil)
        }
        task.resume()
    }
}
