//
//  DocTableViewController.swift
//  TermProject
//
//  Created by 강동훈 on 2017. 5. 30..
//  Copyright © 2017년 강동훈. All rights reserved.
//

import UIKit
import CoreLocation

class DocTableViewController: UITableViewController, XMLParserDelegate, CLLocationManagerDelegate  {

    @IBOutlet var taData: UITableView!
    
    
    var url : String?
    
    
    var Durl1 : String?

    var Durl2 : String = "&ORD=NAME&pageNo=1&startPage=1&numOfRows=1&pageSize=1"
    
    var FDurl : String = ""
    
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var Nearposts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    
    var element = NSString()
    
    var yadmNm = NSMutableString()
    
    var addr = NSMutableString()
    
    var XPos = NSMutableString()
    
    var YPos = NSMutableString()
    
    var LX = Double()
    var LY = Double()
    
    var LXY = Double()
    
    var docname = ""
    var docname_utf8 = ""
    
    var lat = 33.44981457698432
    
    var lon = 126.9150117992059
    
    var howlong = 1000000000000000.1000000000
    
    var NyadmNm = NSMutableString()
    
    var locationManager:CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func beginParsing()
    {
        posts = []
        Nearposts = []
        NyadmNm = ""
        parser = XMLParser(contentsOf:(URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
        taData!.reloadData()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        //lon = (locationManager.location?.coordinate.longitude)!
        //lat = (locationManager.location?.coordinate.latitude)!
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            yadmNm = NSMutableString()
            yadmNm = ""
            addr = NSMutableString()
            addr = ""
            
            XPos = NSMutableString()
            XPos = ""
            YPos = NSMutableString()
            YPos = ""
            
            LX = Double()
            LX = 0.0
            LY = Double()
            LY = 0.0
            
            LXY = Double()
            LXY = 0.0
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "dutyName") {
            yadmNm.append(string)
        } else if element.isEqual(to: "dutyAddr") {
            addr.append(string)
        } else if element.isEqual(to: "wgs84Lat") {
            XPos.append(string)
            LX = lat - (XPos as NSString).doubleValue
        } else if element.isEqual(to: "wgs84Lon") {
            YPos.append(string)
            LY = lon - (XPos as NSString).doubleValue
            LXY = (LX * LX) + (LY * LY)
            if howlong > LXY {
                howlong = LXY
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !yadmNm.isEqual(nil) {
                elements.setObject(yadmNm, forKey: "dutyName" as NSCopying)
            }
            if !addr.isEqual(nil) {
                elements.setObject(addr, forKey: "dutyAddr" as NSCopying)
            }
            if !XPos.isEqual(nil) {
                elements.setObject(XPos, forKey: "wgs84Lat" as NSCopying)
            }
            if !YPos.isEqual(nil) {
                elements.setObject(YPos, forKey: "wgs84Lon" as NSCopying)
            }
            if howlong == LXY {
                Nearposts.removeAllObjects()
                Nearposts.add(elements)
            }
            
            posts.add(elements)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDocMapView" {
            if let mapViewController = segue.destination as? DocMapViewController {
                mapViewController.posts = posts
                mapViewController.lat = lat
                mapViewController.lon = lon
            }
        }
        
        if segue.identifier == "segueToDocDetail" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                docname = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "dutyName") as! NSString as String
                docname_utf8 = docname.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                if let detailDocTableViewController = segue.destination as? DetailDocTableViewController {
                    FDurl = Durl1! + "&QN=" + docname_utf8 + Durl2
                    detailDocTableViewController.url = FDurl                }
            }
        }
        if segue.identifier == "segueToNearDoc" {
            if let NearMapViewController = segue.destination as? DocMapViewController {
                NearMapViewController.posts = Nearposts
                NearMapViewController.lat = lat
                NearMapViewController.lon = lon
            }
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        if(cell.isEqual(NSNull)) {
            cell = Bundle.main.loadNibNamed("Cell", owner: self, options: nil)?[0] as! UITableViewCell;
        }
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "dutyName") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "dutyAddr") as! NSString as String
        return cell as UITableViewCell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

