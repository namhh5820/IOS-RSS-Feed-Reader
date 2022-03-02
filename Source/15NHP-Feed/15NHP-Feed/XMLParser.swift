//
//  XMLParser.swift
//  15NHP-Feed
//
//  Created by admin on 13/05/2017.
//  Copyright © 2017 15NHP. All rights reserved.
//

import Foundation

protocol  MyXMLParserDelegate {
    func parsingWasFinished()
}

// Đặt tên XMLParser trùng với tên lớp của hệ thống
class MyXMLParser: NSObject, XMLParserDelegate {
    // MARK: Local variables
    // Dữ liệu sẽ có dạng: title: "", description: "", link: "http://"...
    var data = [Dictionary<String, String>]() // Dữ liệu sau khi parse
    
    // Các biến lưu trữ dữ liệu tạm dùng khi parse
    var dictionary = Dictionary<String, String>()
    var currentElement = "" // item
    var title = "" // Tiêu đề bài viết
    var link = "" // Liên kết cụ thể
    var pubDate = "" // Ngày xuất bản
    
    var delegate: MyXMLParserDelegate?
    
    func parseContent(rssUrl: NSURL) {
        // Dùng parse của hệ thống
        let parser = XMLParser(contentsOf: rssUrl as URL)!
        parser.delegate = self
        parser.parse() // Bắt đầu parse
    }
    
    // MARK: XMLParseDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if (currentElement as NSString).isEqual(to: "item") {
            // Khởi tạo lại từ đầu các biến trung gian dùng trong quá trình parse
            dictionary = Dictionary<String, String>()
            currentElement = "" // item
            title = "" // Tiêu đề bài viết
            link = "" // Liên kết cụ thể
            pubDate = "" // Ngày xuất bản
        }
    }
    
    // Tùy theo element hiện tại là gì mà tổng hợp chuỗi tương ứng
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "title" {
            title.append(string)
            //
            //print(string)
            //
            
        } else if currentElement == "link" {
            link.append(string)
        } else if currentElement == "pubDate" {
            pubDate.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            // Tiền xử lí một chút vì có kí tự \n và một vài khoảng trống ở sau
            
            title = title.replacingOccurrences(of: "'", with: "").trim()
            link = link.replacingOccurrences(of: "\n", with: "").trim()
            pubDate = pubDate.replacingOccurrences(of: "\n", with: "").trim()
            
            dictionary["title"] = title
            dictionary["link"] = link
            dictionary["pubDate"] = pubDate
            
            data.append(dictionary) // Thêm một mục vào kết quả parse cuối cùng
        }
    }
    
    // Kết thúc việc parse tài liệu
    func parserDidEndDocument(_ parser: XMLParser) {
        delegate?.parsingWasFinished() // Gọi hàm delegate nếu có
    }
}
