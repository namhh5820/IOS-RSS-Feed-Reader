//
//  RegViewController.swift
//  15NHP-Feed
//
//  Created by namhh on 6/13/17.
//  Copyright © 2017 15NHP. All rights reserved.
//

import UIKit

class RegViewController: UIViewController {

    var tmpten = ""
    
    
    @IBOutlet weak var txtname: UITextField!
    
    @IBOutlet weak var txtpass: UITextField!
    
    @IBOutlet weak var txtrepass: UITextField!
    
    
    @IBAction func btnreg(_ sender: Any) {
    
        //Kiem tra mat khau
        if txtpass.text != txtrepass.text {
            
            let alertController = UIAlertController(title: "Error", message: "MAT KHAU KHONG GIONG NHAU. NHAP LAI!!!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        //Kiem tra user
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
        
        let query = "SELECT * FROM USER WHERE USERNAME ='" + txtname.text! + "'"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let rowten = sqlite3_column_text(statement, 1)

                

                tmpten = String.init(cString: rowten!)

                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        
        
        if tmpten != "" {
            
            let alertController = UIAlertController(title: "Error", message: "USER DA TON TAI. SU DUNG USER KHAC!!!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            //Them user
            var database:OpaquePointer? = nil
            var result = sqlite3_open(dataFilePath(), &database)
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
            
            let sqlcmd:String  = "INSERT INTO USER VALUES (null,'" +  txtname.text! + "','" + txtpass.text! + "')"
            
            SQL_Query(sql: sqlcmd, database: database!)
            
            let alertController = UIAlertController(title: "Reg", message: "DANG KY THANH CONG!!!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
            //Khoi tao DB cho user
            inituserdata(username: txtname.text!)
            
            txtname.text = ""
            txtpass.text = ""
            txtrepass.text = ""
            
            
        }

    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtname.text = ""
        txtpass.text = ""
        txtrepass.text = ""

        // Do any additional setup after loading the view.
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
    
    func inituserdata(username : String) {
        
        var tmpid = 0
        
        //sql
        var database:OpaquePointer? = nil
        var result = sqlite3_open(dataFilePath(), &database)
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
        
        //Get ID
        let query = "SELECT * FROM USER WHERE USERNAME ='" + username + "'"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))

                tmpid = id

            }
            sqlite3_finalize(statement)
        }
        
        
        //TABLE FEED + IDUSER
        let createSQL = "CREATE TABLE IF NOT EXISTS FEED" + String(tmpid) +
        " (ID INTEGER PRIMARY KEY, TITLE VARCHAR, DESCRIPTION VARCHAR, LINK VARCHAR, PUBDATE VARCHAR, STATUS VARCHAR);"
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        result = sqlite3_exec(database, createSQL, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            //sqlite3_close(database)
            print("Failed to create table")
            return
        }
        else
        {
            print("CREATED TABLE FEED OK")
        }
        
        //Add fontsize
        let sqlcmd:String  = "INSERT INTO SETTINGS VALUES (null,'FONT_SIZE','16','" + String(tmpid) + "')"
        SQL_Query(sql: sqlcmd, database: database!)
        
    }

}
