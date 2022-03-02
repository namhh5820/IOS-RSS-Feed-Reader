//
//  SearchViewController.swift
//  15NHP-Feed
//
//  Created by namhh on 6/5/17.
//  Copyright © 2017 15NHP. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    
    @IBOutlet weak var txtsearch: UITextField!
    
    
    @IBAction func btnsearch(_ sender: Any) {
        
        Session.s_keyword =  txtsearch.text!
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtsearch.text = ""
        addSideMenu()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
   
}
