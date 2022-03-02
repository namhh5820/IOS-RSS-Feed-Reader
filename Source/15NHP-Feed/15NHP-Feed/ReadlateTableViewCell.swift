//
//  ReadlateTableViewCell.swift
//  15NHP-Feed
//
//  Created by namhh on 6/4/17.
//  Copyright © 2017 15NHP. All rights reserved.
//

import UIKit

class ReadlateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var txttitle: UILabel!
    
    @IBOutlet weak var txtpubdate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
