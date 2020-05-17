//
//  CollectionViewController.swift
//  VirtualTour
//
//  Created by Antarpunit Singh on 2012-05-09.
//  Copyright © 2020 AntarpunitSingh. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class PhotoViewController: UIViewController {
    
  
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
//    var selectedPin:MKAnnotation!
    var pin:PinData!
    var fetchController:NSFetchedResultsController<PhotoData>!
    var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setupFetchController()
        fetchPhotos()
        mapViewSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchController.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchController = nil
    }
    // Mark: Setting up the fetch request
    func setupFetchController(){
        let fetchresult: NSFetchRequest<PhotoData> = PhotoData.fetchRequest()
        fetchresult.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchresult.predicate = NSPredicate(format: "pin == %@", pin)
        fetchController = NSFetchedResultsController(fetchRequest: fetchresult, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchController.performFetch()
        }
        catch{
            fatalError("Error in fetching -- \(error.localizedDescription)")
        }
    }
    //Mark: Method to check the fetched objects in CoreData
    func fetchPhotos(){
        
        if fetchController.fetchedObjects?.count == 0 {
            guard let url = FlickerApi.generateUrl(lat: pin.latitude, long: pin.longitude ) else {
                
                return}
            networkRequest(url: url)
        }
        else {
            print("fetched")
            try? fetchController.performFetch()
        }
    }
    func mapViewSetup(){
        let mapPin = MKPointAnnotation()
        let coordinates = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        mapPin.coordinate = coordinates
        mapView.addAnnotation(mapPin)
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        mapView.setRegion(region, animated: true)
    }
    // Mark : Perform network request and save the fetched result in Coredata
    func networkRequest(url:URL){
        _ = FlickerApi.taskGetRequest(url: url, responseType: FlickerResponse.self) { (response, error) in
            guard let response = response else {return}
            for photoObject in response.photos.photo {
                let urlString = "https://farm\(photoObject.farm).staticflickr.com/\(photoObject.server)/\(photoObject.id)_\(photoObject.secret).jpg"
                print("error in url\(urlString)")
                FlickerApi.downloadPhotos(url: URL(string: urlString)!, completion: self.handleDownloadImageResponse(imageData:error:))
            }
        }
    }
    func handleDownloadImageResponse(imageData:Data? , error:Error?){
        guard let imageData = imageData else {
            print("error in downloading photos")
            return }
        let photo = PhotoData(context: persistentContainer.viewContext)
        photo.imageData = imageData
        photo.creationDate = Date()
        photo.pin = pin
        try? persistentContainer.viewContext.save()
    }
    
    @IBAction func newCollection(_ sender: UIButton) {
        if let photos = fetchController.fetchedObjects{
            for photo in photos{
                persistentContainer.viewContext.delete(photo)
                try? persistentContainer.viewContext.save()
            }
           guard let url = FlickerApi.generateUrl(lat: pin.latitude, long: pin.longitude ) else {
                   print("url problem")
                   return}
               networkRequest(url: url)
           }
        }
        
}
// Mark: DataSourse methods populated by NSFetchresultcontroller
extension PhotoViewController:UICollectionViewDataSource,UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchController.fetchedObjects?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! CollectionViewCell
        
        let index = fetchController.object(at: indexPath)
        cell.imageView.image = UIImage(data: index.imageData!)
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = fetchController.object(at: indexPath)
        persistentContainer.viewContext.delete(index)
        try? persistentContainer.viewContext.save()
    }
}
extension PhotoViewController : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
            break
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
        default:
            return
        }
    }
}
