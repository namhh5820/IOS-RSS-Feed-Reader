//
//  AddFeedViewController.swift
//  15NHP-Feed
//
//  Created by namhh on 5/22/17.
//  Copyright © 2017 15NHP. All rights reserved.
//

import UIKit

class AddFeedViewController: UIViewController {

    var name = ""
    var link = ""
    
    @IBOutlet weak var txtname: UITextField!
    
    @IBOutlet weak var txtlink: UITextView!
    
    
    @IBAction func btnadd(_ sender: Any) {
        
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
        
        
        //TABLE USER
        let createSQL = "CREATE TABLE IF NOT EXISTS FEEDS " +
        "(ID INTEGER PRIMARY KEY, NAME VARCHAR, LINK VARCHAR, IDUSER VARCHAR);"
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        result = sqlite3_exec(database, createSQL, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            //sqlite3_close(database)
            print("Failed to create table")
            return
        }
        else
        {
            print("CREATED TABLE FEEDS OK")
        }
        
        if txtname.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter name", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        if txtlink.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter link", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
       
        
        let sqlcmd1:String  = "INSERT INTO FEEDS VALUES (null,'" +  txtname.text!
        let sqlcmd2:String =  "','" + txtlink.text! + "','" + String(Session.s_id) + "')"
        let sqlcmd:String = sqlcmd1 + sqlcmd2
        
        SQL_Query(sql: sqlcmd, database: database!)
        
        txtname.text = ""
        txtlink.text = ""
        Session.s_check = 0
        
        let alertController = UIAlertController(title: "Thong Bao", message: "Them thanh cong!", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
