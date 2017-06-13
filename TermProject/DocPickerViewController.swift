//
//  DocPickerViewController.swift
//  TermProject
//
//  Created by 강동훈 on 2017. 6. 10..
//  Copyright © 2017년 강동훈. All rights reserved.
//

import UIKit

class DocPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        // Do any additional setup after loading the view.
    }

    var pickerDataSource = ["제주시", "서귀포시"]
    
    var url1: String = "http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyListInfoInqire?serviceKey=8dzkLURtf3us0Ilf7eEKM5v4JuAyld82MfWecCK0xRWQOdtncpLQ8n8ja1UpdbaARNtc4JVBNnwSsT4ZKz0qqw%3D%3D&Q0=%EC%A0%9C%EC%A3%BC%ED%8A%B9%EB%B3%84%EC%9E%90%EC%B9%98%EB%8F%84&Q1="
    
    var url2: String = "&QT=1&ORD=NAME&pageNo=1&startPage=1&numOfRows=100&pageSize=100"
    
    var sgguCd : String = "%EC%A0%9C%EC%A3%BC%EC%8B%9C"
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            sgguCd = "%EC%A0%9C%EC%A3%BC%EC%8B%9C"
        } else {
            sgguCd = "%EC%84%9C%EA%B7%80%ED%8F%AC%EC%8B%9C"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDocTable" {
            if let tableViewController = segue.destination as? DocTableViewController {
                tableViewController.url = url1 + sgguCd + url2
                tableViewController.Durl1 = url1 + sgguCd + "&QT=1"
            }
        }

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
