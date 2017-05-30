//
//  BicMapViewController.swift
//  TermProject
//
//  Created by 강동훈 on 2017. 5. 24..
//  Copyright © 2017년 강동훈. All rights reserved.
//

import UIKit
import MapKit

class BicMapViewController: UIViewController, MKMapViewDelegate {
    
    var posts = NSMutableArray()
    
    let regionRadius: CLLocationDistance = 5000
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    var BicLocations = [BicLocation]()
    
    func loadInitialData() {
        for post in posts {
            let location = (post as AnyObject).value(forKey: "title") as! NSString as String
            let address = (post as AnyObject).value(forKey: "address") as! NSString as String
            let numleft = (post as AnyObject).value(forKey: "retal_enable_num") as! NSString as String
            let Bike = BicLocation(title: location, locationName: address, coordinate: CLLocationCoordinate2D(latitude: 100, longitude: 60))
            BicLocations.append(Bike)
        }
    }

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadInitialData()
        mapView.addAnnotations(BicLocations)
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! BicLocation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? BicLocation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
