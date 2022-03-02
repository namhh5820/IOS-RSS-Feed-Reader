//
//  UI.swift
//  TuVanTraGop
//
//  Created by dev7 on 11/13/16.
//  Copyright © 2016 dev7. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String, message: String) {
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        let view = UIAlertController(title: title, message: message, preferredStyle: .alert)
        view.addAction(ok)
        
        self.present(view, animated: true, completion: nil)
    }
    
    func addDoneButton(to control: UITextField) {
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: control, action: #selector(UITextField.resignFirstResponder))
        ]
        toolbar.sizeToFit()
        control.inputAccessoryView = toolbar
    }
    
    func addDoneButton(tos controls: [UITextField]) {
        for control in controls {
            let toolbar = UIToolbar()
            toolbar.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Done", style: .done, target: control, action: #selector(UITextField.resignFirstResponder))
            ]
            toolbar.sizeToFit()
            control.inputAccessoryView = toolbar
        }
    }
    
    func addSideMenu() {
        let menuButton = UIBarButtonItem(image: UIImage(named: "sidemenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        self.navigationItem.setLeftBarButton(menuButton, animated: true)
        
        // Vuốt kéo để hiện sidemenu
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    func addHomeButton() {
        let homeButton = UIBarButtonItem(title: "Home", style: .done, target: self, action: #selector(popToHome))
        self.navigationItem.setRightBarButton(homeButton, animated: true)
        
        // Vuốt kéo để hiện sidemenu
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func popToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // DB
    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:String?
        url = urls.first?.appendingPathComponent("rssdb.sqlite").path
        return url!
    }
    
    
    func SQL_Query(sql:String, database:OpaquePointer){
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let result = sqlite3_exec(database, sql, nil, nil, &errMsg);
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Cau truy van bi loi! :" + sql)
            return
        }
        else
        {
            print("Thuc hien thanh cong!")
        }
    }
    
    
    
    //
    
    
}

extension UITextField {
    func isEmpty() -> Bool {
        return (self.text?.characters.count)! == 0
    }
}


