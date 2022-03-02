//
//  ReadLateTableViewController.swift
//  15NHP-Feed
//
//  Created by namhh on 5/20/17.
//  Copyright © 2017 15NHP. All rights reserved.
//

import UIKit

class ReadLateTableViewController: UITableViewController {

    
    var arrreadlate:[String]! = ["A","B","C"]
    
    var arrid = [Int]()
    var arrtitle = [String]()
    var arrdesc = [String]()
    var arrlink = [String]()
    var arrpubdate = [String]()
    var arrstatus = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        addSideMenu()
        
        //sql quey
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
        
        
        let query = "SELECT * FROM " + Session.s_table + " WHERE STATUS LIKE '2%' "
        
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let row = Int(sqlite3_column_int(statement, 0))
                let rowtitle = sqlite3_column_text(statement, 1)
                let rowdesc = sqlite3_column_text(statement, 2)
                let rowlink = sqlite3_column_text(statement, 3)
                let rowpubdate = sqlite3_column_text(statement, 4)
                let rowstatus = sqlite3_column_text(statement, 5)

                
                
                let tmptitle = String.init(cString: rowtitle!)
                let tmpdesc = String.init(cString: rowdesc!)
                let tmplink = String.init(cString: rowlink!)
                let tmppubdate = String.init(cString: rowpubdate!)
                let tmpstatus = String.init(cString: rowstatus!)
                
                
                arrid.append(row)
                arrtitle.append(tmptitle)
                arrdesc.append(tmpdesc)
                arrlink.append(tmplink)
                arrpubdate.append(tmppubdate)
                arrstatus.append(tmpstatus)
                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        
        
        
        
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
        return arrtitle.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "readlate_cell", for: indexPath) as! ReadlateTableViewCell

        // Configure the cell...
        //cell.textLabel?.text = arrtitle[indexPath.row]
        
        cell.txttitle.font = cell.txttitle.font.withSize(CGFloat(Session.s_fontSize))
        cell.txttitle.text = arrtitle[indexPath.row]
        cell.txtpubdate.text = arrpubdate[indexPath.row]
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_readlate" {
            let dest = segue.destination as! ManHinhChiTietViewController
            
            let indexPath  = tableView.indexPathForSelectedRow
            dest.id = arrid[(indexPath?.row)!]
            dest.link = arrlink[(indexPath?.row)!]
            dest.pubDate = arrpubdate[(indexPath?.row)!]
            
            
        }
    }

}
