//
//  DocMapViewController.swift
//  TermProject
//
//  Created by 강동훈 on 2017. 5. 24..
//  Copyright © 2017년 강동훈. All rights reserved.
//

import UIKit
import MapKit

class DocMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var posts = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 33.51941915384433, longitude: 126.56976660848167)
        
        centerMapOnLocation(location: initialLocation)
        
        mapView.delegate = self
        loadInitialData()
        mapView.addAnnotations(hospitals)
        
        // Do any additional setup after loading the view.
    }
    
    let regionRadius: CLLocationDistance = 5000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    var hospitals = [DocLocation]()
    
    func loadInitialData() {
        for post in posts {
            let yadmNm = (post as AnyObject).value(forKey: "dutyName") as! NSString as String
            let addr = (post as AnyObject).value(forKey: "dutyAddr") as! NSString as String
            let XPos = (post as AnyObject).value(forKey: "wgs84Lat") as! NSString as String
            let YPos = (post as AnyObject).value(forKey: "wgs84Lon") as! NSString as String
            let lat = (YPos as NSString).doubleValue
            let lon = (XPos as NSString).doubleValue
            let docLocation = DocLocation(title: yadmNm, locationName: addr, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            hospitals.append(docLocation)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! DocLocation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DocLocation {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
