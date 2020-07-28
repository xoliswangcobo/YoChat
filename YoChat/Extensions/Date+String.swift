//
//  Date+String.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

extension Date {
    
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }

    func dateShort() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self)
    }
    
    static func dateFrom(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.date(from: date)
    }
}
