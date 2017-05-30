//
//  BicTableViewController.swift
//  TermProject
//
//  Created by 강동훈 on 2017. 5. 28..
//  Copyright © 2017년 강동훈. All rights reserved.
//

import UIKit

class BicTableViewController: UITableViewController, XMLParserDelegate {
    @IBOutlet var taData: UITableView!
    
    var url : String = "http://openapi.jejusi.go.kr/rest/PublicBikeInfoService/getPublicBikeInfoList?serviceKey=8dzkLURtf3us0Ilf7eEKM5v4JuAyld82MfWecCK0xRWQOdtncpLQ8n8ja1UpdbaARNtc4JVBNnwSsT4ZKz0qqw%3D%3D"
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var location = NSMutableString()
    var address = NSMutableString()
    var numleft = NSMutableString()
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf: (URL(string:url))!)!
        parser.delegate = self
        parser.parse()
        taData.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "list") {
            elements = NSMutableDictionary()
            elements = [:]
            location = NSMutableString()
            location = ""
            address = NSMutableString()
            address = ""
            
            numleft = NSMutableString()
            numleft = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "title") {
            location.append(string)
        } else if element.isEqual(to: "address") {
            address.append(string)
        } else if element.isEqual(to: "retal_enable_num") {
            numleft.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "list") {
            if !location.isEqual(nil) {
                elements.setObject(location, forKey: "title" as NSCopying)
            }
            if !address.isEqual(nil) {
                elements.setObject(address, forKey: "address" as NSCopying)
            }
            if !numleft.isEqual(nil) {
                elements.setObject(numleft, forKey: "retal_enable_num" as NSCopying)
            }
            posts.add(elements)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        if(cell.isEqual(NSNull)) {
            cell = Bundle.main.loadNibNamed("Cell", owner: self, options: nil)?[0] as! UITableViewCell;
        }
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "title") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "address") as! NSString as String
        return cell as UITableViewCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToBicMap" {
            if let mapViewController = segue.destination as? BicMapViewController {
                mapViewController.posts = posts
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

}
