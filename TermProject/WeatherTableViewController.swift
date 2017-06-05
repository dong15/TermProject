//
//  WeatherTableViewController.swift
//  TermProject
//
//  Created by 강동훈 on 2017. 5. 31..
//  Copyright © 2017년 강동훈. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var taData: UITableView!
    
    var url : String = "http://data.jeju.go.kr/rest/JejuLdapsDataService/getForecastPointDataXY?ServiceKey=8dzkLURtf3us0Ilf7eEKM5v4JuAyld82MfWecCK0xRWQOdtncpLQ8n8ja1UpdbaARNtc4JVBNnwSsT4ZKz0qqw%3D%3D&baseDate=20161026&baseTime=2100&hgtLevel=0&nx=43&ny=31&numOfRows=&37pageNo=1"
    
    
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    
    var element = NSString()
    
    var fcstDate = NSMutableString()
    
    var fcstTime = NSMutableString()
    
    var humiValue = NSMutableString()
    
    var tempValue = NSMutableString()
    
    var lat = NSMutableString()
    
    var lon = NSMutableString()
    
    var weathername = ""
    
    var weathername_utf8 = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginParsing()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf:(URL(string:url))!)!
        parser.delegate = self
        parser.parse()
        taData!.reloadData()
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "list")
        {
            elements = NSMutableDictionary()
            elements = [:]
            fcstDate = NSMutableString()
            fcstDate = ""
            fcstTime = NSMutableString()
            fcstTime = ""
            humiValue = NSMutableString()
            humiValue = ""
            tempValue = NSMutableString()
            tempValue = ""
            
            lat = NSMutableString()
            lat = ""
            lon = NSMutableString()
            lon = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "fcstDate") {
            fcstDate.append(string)
        } else if element.isEqual(to: "fcstTime") {
            fcstTime.append(string)
        } else if element.isEqual(to: "humiValue") {
            humiValue.append(string)
        } else if element.isEqual(to: "tempValue") {
            tempValue.append(string)
        } else if element.isEqual(to: "lat") {
            lat.append(string)
        } else if element.isEqual(to: "lon") {
            lon.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "list") {
            if !fcstDate.isEqual(nil) {
                elements.setObject(fcstDate, forKey: "fcstData" as NSCopying)
            }
            if !fcstTime.isEqual(nil) {
                elements.setObject(fcstTime, forKey: "fcstTime" as NSCopying)
            }
            if !humiValue.isEqual(nil) {
                elements.setObject(humiValue, forKey: "humiValue" as NSCopying)
            }
            if !tempValue.isEqual(nil) {
                elements.setObject(tempValue, forKey: "tempValue" as NSCopying)
            }
            if !lat.isEqual(nil) {
                elements.setObject(lat, forKey: "lat" as NSCopying)
            }
            if !lon.isEqual(nil) {
                elements.setObject(lon, forKey: "lon" as NSCopying)
            }
            
            
            posts.add(elements)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWeatherDetail" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                weathername = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "fcstDate") as! NSString as String
                weathername_utf8 = weathername.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                if let detailWeatherTableViewController = segue.destination as? DetailWeatherTableViewController {
                    detailWeatherTableViewController.url = url + "&fcstDate=" + weathername_utf8
                }
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
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "fcstTime") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "humiValue") as! NSString as String
        return cell as UITableViewCell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
}
