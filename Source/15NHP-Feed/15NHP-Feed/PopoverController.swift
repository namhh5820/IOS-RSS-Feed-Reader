//
//  PopoverController.swift
//  15NHP-Feed
//
//  Created by admin on 14/05/2017.
//  Copyright © 2017 15NHP. All rights reserved.
//

import UIKit

class PopoverController: UIViewController {
    // MARK: Data models
    // ------------------
    var pubDate = ""
    
    // MARK: UI Elements
    // -----------------
    @IBOutlet weak var pubDateLabel: UILabel!
    
    
    // MARK: UIViewController
    // -----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pubDateLabel.text = "Publish date: \n \(pubDate)"
    }
    
    // MARK: UI Events
    // ----------------
    
    
}
