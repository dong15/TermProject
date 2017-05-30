//
//  DetailDocTableViewController.swift
//  TermProject
//
//  Created by 강동훈 on 2017. 5. 30..
//  Copyright © 2017년 강동훈. All rights reserved.
//

import UIKit

class DetailDocTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var detailTableView: UITableView!
    
    var url : String?
    
    var parser = XMLParser()
    
    let postsname : [String] = ["약국명", "주소", "전화번호", "코드"]
    var posts : [String] = ["", "", "", ""]
    
    var element = NSString()
    
    var dutyName = NSMutableString()
    var dutyAddr = NSMutableString()
    var dutyTel1 = NSMutableString()
    var hpid = NSMutableString()
    
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
        if (elementName as NSString).isEqual(to: "item")
        {
            posts = ["", "", "", ""]
            dutyName = NSMutableString()
            dutyName = ""
            dutyAddr = NSMutableString()
            dutyAddr = ""
            
            dutyTel1 = NSMutableString()
            dutyTel1 = ""
            hpid = NSMutableString()
            hpid = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "dutyName") {
            dutyName.append(string)
        } else if element.isEqual(to: "dutyAddr") {
            dutyAddr.append(string)
        } else if element.isEqual(to: "dutyTel1") {
            dutyTel1.append(string)
        } else if element.isEqual(to: "hpid") {
            hpid.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !dutyName.isEqual(nil) {
                posts[0] = dutyName as String
            }
            if !dutyAddr.isEqual(nil) {
                posts[1] = dutyAddr as String
            }
            if !dutyTel1.isEqual(nil) {
                posts[2] = dutyTel1 as String
            }
            if !hpid.isEqual(nil) {
                posts[3] = hpid as String
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
        var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "DocCell")!
        if(cell.isEqual(NSNull.self)) {
            cell = Bundle.main.loadNibNamed("DocCell", owner: self, options: nil)?[0] as! UITableViewCell;
        }
        cell.textLabel?.text = postsname[indexPath.row]
        cell.detailTextLabel?.text = posts[indexPath.row]
        
        return cell as UITableViewCell
    }
    
}
