//
//  SideMenuController.swift
//  15NHP-Feed
//
//  Created by admin on 14/05/2017.
//  Copyright © 2017 15NHP. All rights reserved.
//

import Foundation


class SideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: *** UI Elements
    let ids = ["search_id" , "today_id", "readlate_id", "all_id", "setting_id"]
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: *** TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ids[indexPath.row], for: indexPath)
        return cell
    }
}
