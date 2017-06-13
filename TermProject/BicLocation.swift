//
//  BicLocation.swift
//  TermProject
//
//  Created by 강동훈 on 2017. 5. 29..
//  Copyright © 2017년 강동훈. All rights reserved.
//

import Foundation

import MapKit

import AddressBook

import CoreLocation

class BicLocation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    
    init(title: String, locationName: String, key: Int) {
        self.title = title
        self.locationName = locationName
        if key == 0 {
            self.coordinate = CLLocationCoordinate2DMake(33.4844590, 126.5005630)
        } else if key == 1 {
            self.coordinate = CLLocationCoordinate2DMake(33.4881260, 126.4968960)
        } else if key == 2 {
            self.coordinate = CLLocationCoordinate2DMake(33.4910420, 126.4861030)
        } else if key == 3 {
            self.coordinate = CLLocationCoordinate2DMake(33.4830980, 126.4772310)
        } else if key == 4 {
            self.coordinate = CLLocationCoordinate2DMake(33.4786550, 126.4906380)
        } else if key == 5 {
            self.coordinate = CLLocationCoordinate2DMake(33.4754640, 126.5156480)
        } else if key == 6 {
            self.coordinate = CLLocationCoordinate2DMake(33.5105740, 126.5438390)
        } else if key == 7 {
            self.coordinate = CLLocationCoordinate2DMake(33.5001560, 126.5297430)
        } else if key == 8 {
            self.coordinate = CLLocationCoordinate2DMake(33.4991410, 126.5162290)
        } else {
            self.coordinate = CLLocationCoordinate2DMake(33.4844590, 126.5005630)
        }
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}
