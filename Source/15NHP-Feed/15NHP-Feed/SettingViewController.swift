//
//  SettingViewController.swift
//  15NHP-Feed
//
//  Created by namhh on 5/19/17.
//  Copyright © 2017 15NHP. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    
    @IBOutlet weak var txtname: UILabel!
    
    @IBAction func btnlogout(_ sender: Any) {
        
        Session.s_check = 0
    }
    var fontSize = Int ()
    
    @IBAction func btn_showFontSizeAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Skin Type", message: "Please Choose Skin Type", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Small", style: .default, handler: { (action) in
            //execute some code when this option is selected
            if (self.updateFontSize(fontSize: 14) == 1) {
                Session.s_fontSize = 14
                print("Update fontsize successful")
            } else {
                print("update Fontsize failed")
            }
        }))
        alert.addAction(UIAlertAction(title: "Large", style: .default, handler: { (action) in
            //execute some code when this option is selected
            if (self.updateFontSize(fontSize: 16) == 1) {
                Session.s_fontSize = 16
                print("Update fontsize successful")
            } else {
                print("update Fontsize failed")
            }
        }))
        self.present(alert, animated: true, completion: nil)
        /*self.present(alert, animated: true) {
            //code to execute once the alert is showing
            self.alertShown = true
        }*/
        
        
      
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtname.text = Session.s_name
        addSideMenu()        
        
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
    func updateFontSize(fontSize: Int) -> Int {
        var database:OpaquePointer? = nil
        var result = sqlite3_open(dataFilePath(), &database)
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
        
        
        
        print(fontSize)
        
        
        let sqlcmd:String  = "UPDATE SETTINGS SET VALUE = '" +  String(fontSize) + "' WHERE NAME = 'FONT_SIZE' AND IDUSER = '" + String(Session.s_id) + "'"
        
        SQL_Query(sql: sqlcmd, database: database!)
        return 1
    }

}
