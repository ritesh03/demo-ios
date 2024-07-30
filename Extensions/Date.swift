//
//  Date.swift
//  synex
//
//  Created by Ritesh chopra on 07/09/23.
//

import Foundation

enum DateFormat: String {
    
    case dateTime = "yyyy-MM-dd HH:mm:ss"
    case ymdDate = "yyyy/MM/dd"
}

enum TimeZoneType {
    case utc
    case gmt
    case local
}


extension Date{
    
    func string(format: DateFormat, type: TimeZoneType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if format != .dateTime {
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
        }

        if type == .utc {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        else if type == .gmt {
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            
        } else {
            dateFormatter.timeZone = NSTimeZone.local
        }

        return dateFormatter.string(from: self)
    }
}
