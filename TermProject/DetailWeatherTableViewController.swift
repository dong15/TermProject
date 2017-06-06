//
//  DetailWeatherTableViewController.swift
//  TermProject
//
//  Created by 강동훈 on 2017. 6. 3..
//  Copyright © 2017년 강동훈. All rights reserved.
//

import UIKit

class DetailWeatherTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var detailTableView: UITableView!
    
    var url : String?
    
    var key : String?
    
    var Fork = true
    var parser = XMLParser()
    
    let postsname : [String] = ["날짜", "시간", "습도", "온도"]
    var posts : [String] = ["", "", "", ""]
    
    var element = NSString()
    
    var fcstDate = NSMutableString()
    var fcstTime = NSMutableString()
    var humiValue = NSMutableString()
    var tempValue = NSMutableString()
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser.delegate = self
        parser.parse()
        detailTableView.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String? , attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "list")
        {
            if (Fork) {
            posts = ["", "", "", ""]
            fcstDate = NSMutableString()
            fcstDate = ""
            fcstTime = NSMutableString()
            fcstTime = ""
            
            humiValue = NSMutableString()
            humiValue = ""
            tempValue = NSMutableString()
            tempValue = ""
            }
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
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "list") {
            if fcstTime.isEqual(key)
            {
                if !fcstDate.isEqual(nil) {
                    posts[0] = fcstDate as String
                }
                if !fcstTime.isEqual(nil) {
                    posts[1] = fcstTime as String
                }
                if !humiValue.isEqual(nil) {
                    posts[2] = humiValue as String
                }
                if !tempValue.isEqual(nil) {
                    posts[3] = tempValue as String
                }
                Fork = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginParsing()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postsname.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell")!
        if(cell.isEqual(NSNull.self)) {
            cell = Bundle.main.loadNibNamed("WeatherCell", owner: self, options: nil)?[0] as! UITableViewCell;
        }
        cell.textLabel?.text = postsname[indexPath.row]
        cell.detailTextLabel?.text = posts[indexPath.row]
        
        return cell as UITableViewCell
    }
    
}
