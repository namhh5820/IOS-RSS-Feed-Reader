//
//  StringExtension.swift
//  15NHP-Feed
//
//  Created by admin on 13/05/2017.
//  Copyright © 2017 15NHP. All rights reserved.
//

import Foundation

extension String
{
    func trim() -> String{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
