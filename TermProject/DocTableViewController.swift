//
//  DocTableViewController.swift
//  TermProject
//
//  Created by 강동훈 on 2017. 5. 30..
//  Copyright © 2017년 강동훈. All rights reserved.
//

import UIKit

class DocTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var taData: UITableView!
    
    
    var url : String = "http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyListInfoInqire?serviceKey=8dzkLURtf3us0Ilf7eEKM5v4JuAyld82MfWecCK0xRWQOdtncpLQ8n8ja1UpdbaARNtc4JVBNnwSsT4ZKz0qqw%3D%3D&Q0=%EC%A0%9C%EC%A3%BC%ED%8A%B9%EB%B3%84%EC%9E%90%EC%B9%98%EB%8F%84&Q1=%EC%A0%9C%EC%A3%BC%EC%8B%9C&QT=1&ORD=NAME&pageNo=1&startPage=1&numOfRows=10&pageSize=10"
    
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    
    var element = NSString()
    
    var yadmNm = NSMutableString()
    
    var addr = NSMutableString()
    
    var XPos = NSMutableString()
    
    var YPos = NSMutableString()
    
    var docname = ""
    var docname_utf8 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        // Do any additional setup after loading the view, typically from a nib.
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
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "dutyName") {
            yadmNm.append(string)
        } else if element.isEqual(to: "dutyAddr") {
            addr.append(string)
        } else if element.isEqual(to: "wgs84Lat") {
            XPos.append(string)
        } else if element.isEqual(to: "wgs84Lon") {
            YPos.append(string)
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
            
            
            posts.add(elements)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMapView" {
            if let mapViewController = segue.destination as? DocMapViewController {
                mapViewController.posts = posts
            }
        }
        
        if segue.identifier == "segueToDocDetail" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                docname = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "dutyName") as! NSString as String
                docname_utf8 = docname.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                if let detailDocTableViewController = segue.destination as? DetailDocTableViewController {
                    detailDocTableViewController.url = url + "&dutyName=" + docname_utf8
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
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "dutyName") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "dutyAddr") as! NSString as String
        return cell as UITableViewCell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

