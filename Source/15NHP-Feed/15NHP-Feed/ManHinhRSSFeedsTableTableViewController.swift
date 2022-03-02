//
//  ManHinhRSSFeedsTableTableViewController.swift
//  15NHP-Feed
//
//  Created by admin on 15/05/2017.
//  Copyright © 2017 15NHP. All rights reserved.
//

import UIKit

class ManHinhRSSFeedsTableViewController: UITableViewController, MyXMLParserDelegate {
    // MARK: Data models
    var parser = MyXMLParser()
    
    var chiTietViewController: ManHinhChiTietViewController? = nil
    var objects = [Any]()
    
    var arrlinkrss = [String]()
    
    
    var arrid = [Int]()
    var arrtitle = [String]()
    var arrdesc = [String]()
    var arrlink = [String]()
    var arrpubdate = [String]()
    var arrstatus = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        self.navigationItem.leftBarButtonItem = self.editButtonItem
        //
        //        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        //        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.chiTietViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ManHinhChiTietViewController
        }
        
        addSideMenu()
        
        print(Session.s_id)
        print(Session.s_name)
        print(Session.s_table)
        print("CHECK = "  + String(Session.s_check))
        
        parser.delegate = self // Giải quyết xong khai báo, chưa cài đặt
        
        //1. Get cac link RSS || Chi lay link moi luc dau
        
        if(Session.s_check == 0)
        {
            var database:OpaquePointer? = nil
            let result = sqlite3_open(dataFilePath(), &database)
            if result != SQLITE_OK {
                sqlite3_close(database)
                print("Failed to open database")
                return
            }
            else
            {
                //print("Connected DB")
                //print(dataFilePath())
            }
            
            
            let query = "SELECT * FROM FEEDS WHERE IDUSER = '" + String(Session.s_id) + "'"
            
            var statement:OpaquePointer? = nil
            if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    _ = Int(sqlite3_column_int(statement, 0))
                    let rowlink = sqlite3_column_text(statement, 2)
                    
                    
                    let tmplink = String.init(cString: rowlink!)
                    
                    arrlinkrss.append(tmplink)
                    
                    
                }
                sqlite3_finalize(statement)
            }
            sqlite3_close(database)
            
            //Parser XML cac link
            
            for i in 0 ..< arrlinkrss.count
            {
                //print(arrlinkrss[i])
                let url = NSURL(string: arrlinkrss[i])
                parser.parseContent(rssUrl: url!)
                
            }
            
            
            //Xu ly luu xuong DB
            
            for i in 0 ..< parser.data.count
            {
                let object = parser.data[i]
                
                
                if(kiemtralink(tmplink: object["link"]!) == 0)
                {
                    print("--Tin Moi--" + object["title"]!)
                    
                    if (luulink(tmptitle: object["title"]!, tmplink: object["link"]!, tmppubdate: object["pubDate"]!) == 1) {
                        print("Luu link ok !")
                    } else {
                        print("Khong luu link dc")
                    }
                    
                    
                }
                
            }
            
            //Cap nhat bien check
            Session.s_check = 1
        }

        
        //2. Load cac tin moi trong ngay
        var database1:OpaquePointer? = nil
        let result1 = sqlite3_open(dataFilePath(), &database1)
        
        if result1 != SQLITE_OK {
            sqlite3_close(database1)
            print("Failed to open database")
            return
        }
        else
        {
            //print("Connected DB")
            //print(dataFilePath())
        }
        
        let query1 = "SELECT * FROM " + Session.s_table + " WHERE PUBDATE LIKE '%" + Session.s_date + "%' ORDER BY ID DESC"
       
        var statement1:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database1, query1, -1, &statement1, nil) == SQLITE_OK {
            while sqlite3_step(statement1) == SQLITE_ROW {
                let row = Int(sqlite3_column_int(statement1, 0))
                let rowtitle = sqlite3_column_text(statement1, 1)
                let rowdesc = sqlite3_column_text(statement1, 2)
                let rowlink = sqlite3_column_text(statement1, 3)
                let rowpubdate = sqlite3_column_text(statement1, 4)
                let rowstatus = sqlite3_column_text(statement1, 5)
                
                
                
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
            sqlite3_finalize(statement1)
        }
        sqlite3_close(database1)
        
        //END
        print("Number feeds: " + String(arrtitle.count))
        
    }
    
    func parsingWasFinished() {
        // TODO: Thêm code xử lí ở đây
        //print(parser.data) // tạm thời parse xong chỉ debug, hiện ds đã parse ra thôi3.
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let controller = (segue.destination as! UINavigationController).topViewController as! ManHinhChiTietViewController
                
                controller.id = arrid[(indexPath.row)]
                controller.link = arrlink[(indexPath.row)]
                controller.pubDate = arrpubdate[(indexPath.row)]
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrtitle.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCellID", for: indexPath) as! TodayTableViewCell
        
        //let object = parser.data[indexPath.row]
        if(arrstatus[indexPath.row] == "0")
        {
            cell.txttitle.font = UIFont.boldSystemFont(ofSize: CGFloat(Session.s_fontSize))
        }
        
        
        cell.txttitle.font = cell.txttitle.font.withSize(CGFloat(Session.s_fontSize))
        cell.txttitle.text = arrtitle[indexPath.row]
        cell.txtpubdate.text = arrpubdate[indexPath.row]
        
        return cell
    }
    

    
    // kiem tra tin da duoc luu trong DB hay chua
    func kiemtralink(tmplink: String) -> Int {
        
        //print("----" + tmplink)
        
        var arrlinktmp = [String]()
        
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            
        }
        else
        {
            //print("Connected DB")
            //print(dataFilePath())
        }
        
        
        let query = "SELECT * FROM " + String(Session.s_table) + " WHERE LINK = '" + tmplink + "'"
        
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                _ = Int(sqlite3_column_int(statement, 0))
                let rowlink = sqlite3_column_text(statement, 2)
                
                
                let link = String.init(cString: rowlink!)
                
                arrlinktmp.append(link)
                
                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        
        //print(arrlinktmp.count)
        
        return arrlinktmp.count
    }
    
    
    //luu link xuong db
    func luulink(tmptitle: String , tmplink: String , tmppubdate: String) -> Int {
        
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            
        }
        else
        {
            //print("Connected DB")
            //print(dataFilePath())
        }
        
        let sqlcmd1:String  = "INSERT INTO " + String(Session.s_table) + " VALUES (null,'" +  tmptitle
        let sqlcmd2:String =  "','Desc','" + tmplink + "','" + tmppubdate + "','0')"
        let sqlcmd:String = sqlcmd1 + sqlcmd2
        
        SQL_Query(sql: sqlcmd, database: database!)
        
        return 1
    
    }
    
    
}
