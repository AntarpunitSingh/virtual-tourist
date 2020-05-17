//
//  MapPin.swift
//  VirtualTour
//
//  Created by Antarpunit Singh on 2012-05-17.
//  Copyright © 2020 AntarpunitSingh. All rights reserved.
//

import UIKit
import MapKit
extension  MKAnnotationView {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView?.animatesDrop = true
        
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView?.animatesDrop = true
            pinView!.annotation = annotation
        }
        
        return pinView
    }

}
