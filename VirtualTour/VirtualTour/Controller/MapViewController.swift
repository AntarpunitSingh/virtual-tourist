//
//  ViewController.swift
//  VirtualTour
//
//  Created by Antarpunit Singh on 2012-05-09.
//  Copyright © 2020 AntarpunitSingh. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class MapViewController: UIViewController {
    
    var pins:[PinData] = []
    var state:Bool = false
    var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        HoldGesture()
        fetchPinsFromCoreData()
    // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    //  Mark: Tap and Hold gesture method on mapView.
    func HoldGesture(){
        let tapHoldRecogniser = UILongPressGestureRecognizer(target: self,action: #selector(handleTapHold(_:)))
        tapHoldRecogniser.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(tapHoldRecogniser)
    }
    @objc func handleTapHold(_ gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state != .began { return }
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        mapView.addAnnotation(annotation)
        savePinToCoreData(coordinates: touchMapCoordinate)
    }
    
    
    func deletePinFromCoreData(cord:MKAnnotation , mapview:MKMapView){
        let request:NSFetchRequest<PinData> = PinData.fetchRequest()
        if let results = try? persistentContainer.viewContext.fetch(request){
            for result in results {
                if result.latitude == cord.coordinate.latitude && result.longitude == cord.coordinate.longitude {
                    persistentContainer.viewContext.delete(result)
                    mapview.removeAnnotation(cord)
                }
            }
            try? persistentContainer.viewContext.save()
        }
    }
    
    
    func savePinToCoreData(coordinates: CLLocationCoordinate2D){
        let pinData = PinData(context: persistentContainer.viewContext)
        pinData.latitude = coordinates.latitude
        pinData.longitude = coordinates.longitude
        pins.insert(pinData, at: 0)
        try? persistentContainer.viewContext.save()
    }
    func fetchPinsFromCoreData(){
        let request:NSFetchRequest<PinData> = PinData.fetchRequest()
        if let result = try? persistentContainer.viewContext.fetch(request){
            pins = result
        }
        annotatePinsOnMap()
    }
    func annotatePinsOnMap(){
        for pin in pins {
            let pinPoint = MKPointAnnotation()
            let coordinates = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            pinPoint.coordinate = coordinates
            mapView.addAnnotation(pinPoint)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSegue" {
            let vc = segue.destination as! PhotoViewController
            let cords = sender as! MKAnnotation
//            vc.selectedPin = cords
            for pin in pins {
                if (pin.latitude == cords.coordinate.latitude && pin.longitude == cords.coordinate.longitude){
                    vc.pin = pin
                }
            }
        }
    }
    
    @IBAction func barButtonTapped(_ sender: UIBarButtonItem) {
        state = !state
        if state {
            sender.tintColor = .red
            navigationController?.navigationBar.topItem?.title = "Delete Pins"
           
        }
        else {
            navigationController?.navigationBar.topItem?.title = ""
            sender.tintColor = .opaqueSeparator
            state = false
        }
    }
}

extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if state == true {
            deletePinFromCoreData(cord: view.annotation!, mapview: mapView)
        }
        else {
            performSegue(withIdentifier: "showSegue", sender: view.annotation)
            mapView.deselectAnnotation(view.annotation, animated: false)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView?.animatesDrop = true
        }
        else {
            pinView?.animatesDrop = true
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
