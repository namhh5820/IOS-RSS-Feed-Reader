//
//  ListFeedTableViewController.swift
//  15NHP-Feed
//
//  Created by namhh on 5/22/17.
//  Copyright © 2017 15NHP. All rights reserved.
//

import UIKit

class ListFeedTableViewController: UITableViewController {

    var arrall:[String]! = ["A","B","C"]
    
    var arrid = [Int]()
    var arrname = [String]()
    var arrlink = [String]()
    var arruserid = [String]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
        
        
        let query = "SELECT * FROM FEEDS WHERE IDUSER = '" + String(Session.s_id) + "'"
        
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let row = Int(sqlite3_column_int(statement, 0))
                let rowtitle = sqlite3_column_text(statement, 1)
                let rowdesc = sqlite3_column_text(statement, 2)
                let rowlink = sqlite3_column_text(statement, 3)

                
                let tmptitle = String.init(cString: rowtitle!)
                let tmpdesc = String.init(cString: rowdesc!)
                let tmplink = String.init(cString: rowlink!)

                
                arrid.append(row)
                arrname.append(tmptitle)
                arrlink.append(tmpdesc)
                arruserid.append(tmplink)

                
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
        return arrname.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listfeed_cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = arrname[indexPath.row] + " | " + arrlink[indexPath.row]

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            //delete row
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
                
                let sqlcmd:String  = "DELETE FROM FEEDS WHERE ID = ' " + String(arrid[indexPath.row]) + "'"
                
                
                SQL_Query(sql: sqlcmd, database: database!)
                
                //
                arrid.remove(at: indexPath.row)
                arrname.remove(at: indexPath.row)
                arrlink.remove(at: indexPath.row)
                arruserid.remove(at: indexPath.row)
            }
 
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

}
