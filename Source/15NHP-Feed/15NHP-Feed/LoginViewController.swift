//
//  LoginViewController.swift
//  15NHP-Feed
//
//  Created by namhh on 5/19/17.
//  Copyright © 2017 15NHP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var tmpid = 0
    var tmpten = ""
    var tmpmatkhau = ""
    var tmpFontSize = 0;
    
    @IBOutlet weak var txtten: UITextField!
    
    @IBOutlet weak var txtmatkhau: UITextField!
    
    
    @IBAction func btnlogin(_ sender: Any) {
        
        
        if txtten.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your username", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
            
        if txtmatkhau.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        //sql
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        else
        {
            print("Connected DB")
            print(dataFilePath())
        }
        
        let query = "SELECT * FROM USER WHERE USERNAME ='" + txtten.text! + "'"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let rowten = sqlite3_column_text(statement, 1)
                let rowmatkhau = sqlite3_column_text(statement, 2)
                
                tmpid = id
                tmpten = String.init(cString: rowten!)
                tmpmatkhau = String.init(cString: rowmatkhau!)
                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        
        
        //print(tmpten)
        //print(tmpmatkhau)
        
        
        if tmpmatkhau != txtmatkhau.text {
            
            let alertController = UIAlertController(title: "Error", message: "User and password wrong. Login again!!!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            print("DANG NHAP THANH CONG")
            Session.s_id = tmpid
            Session.s_name = tmpten
            Session.s_table = "FEED" + String(tmpid)
            Session.s_fontSize = self.getFontSize()
            
        }

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.navigationController?.isNavigationBarHidden = true
        
        //Khoi tao DB
        copyDatabaseIfNeeded()
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        let strDate = dateFormatter.string(from: Date())
        //print("Ngay thang hien tai: " + strDate)
        Session.s_date = strDate
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
    
    
    func getFontSize() -> Int {
        //sql
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return 0
        }
        else
        {
            print("Connected DB")
            print(dataFilePath())
        }
        
        let query = "SELECT VALUE FROM SETTINGS WHERE IDUSER = " + String(tmpid) + " AND NAME = 'FONT_SIZE'"
        var statement:OpaquePointer? = nil
        //print(query)
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                tmpFontSize = Int(sqlite3_column_int(statement, 0))

                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        return tmpFontSize
    }
    
    func copyDatabaseIfNeeded() {
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("rssdb.sqlite")
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("rssdb.sqlite")
            
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
        
    }
    
    

}
