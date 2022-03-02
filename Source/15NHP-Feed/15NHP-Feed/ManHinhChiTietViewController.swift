//
//  ManHinhChiTietViewController.swift
//  15NHP-Feed
//
//  Created by admin on 14/05/2017.
//  Copyright © 2017 15NHP. All rights reserved.
//

import UIKit
import Social


class ManHinhChiTietViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    // MARK: Data models
    
    var id = 0
    var link = ""
    var pubDate = ""
    
    // MARK: UI Elements
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var pubDateButton: UIBarButtonItem!
    @IBOutlet weak var readlatebutton: UIBarButtonItem!
    @IBOutlet weak var openbutton: UIBarButtonItem!

    
    
    // MARK: UI Events
    
    @IBAction func pubDateButton_Tapped(_ sender: UIBarButtonItem) {
        
        print("shared facebook.com")
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Rss Feeds: " + link)
            self.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func readlatebutton_Tapped(_ sender: UIBarButtonItem) {
        
        print("readlate tapped")
        print("id")
        
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
        
        let sqlcmd1:String  = "UPDATE " + Session.s_table + " SET STATUS = '2'"
        let sqlcmd2:String  = "WHERE ID = '" + String(id) + "'"
        
        let sqlcmd = sqlcmd1 + sqlcmd2
        
        SQL_Query(sql: sqlcmd, database: database!)
        
    }

    
    @IBAction func openbutton_Tapped(_ sender: UIBarButtonItem) {
        
        print("open tapped")
        UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        webview.isHidden = true
        toolbar.isHidden = true
        
        //update status  = 1
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
        
        let sqlcmd1:String  = "UPDATE " + Session.s_table + " SET STATUS = '1'"
        let sqlcmd2:String  = "WHERE ID = '" + String(id) + "'"
        
        let sqlcmd = sqlcmd1 + sqlcmd2
        
        SQL_Query(sql: sqlcmd, database: database!)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if link.characters.count > 0 {
            let request = NSURLRequest(url: URL(string: link)!)
            webview.loadRequest(request as URLRequest)
            
            if webview.isHidden {
                webview.isHidden = false
                toolbar.isHidden = false
            }
        }
    }
}

