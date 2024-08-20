//
//  DateExtension.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/8/24.
//

import Foundation

extension Date {
    
    var dayOrTimeRepresentation: String {
        let calender = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calender.isDateInToday(self){
            dateFormatter.dateFormat = "h: mm a"
            let formattedDate = dateFormatter.string(from: self)
            return formattedDate
        } else if calender.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "MM/dd/yy"
            return dateFormatter.string(from: self)
        }
    }
    
    var formatToTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h: mm a"
        return dateFormatter.string(from: self)
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var relativeDateString: String {
        let calender = Calendar.current
        if calender.isDateInToday(self) {
            return "Today"
        } else if calender.isDateInYesterday(self) {
            return "Yesterday"
        } else if isCurrentWeek {
            return toString(format: "EEEE") //Monday
        } else if isCurrentYear {
            return toString(format: "E, MMM d") //Mon, Feb 18
        } else {
            return toString(format: "MMM dd, yyyy") // Mon, Feb 18, 2023
        }
    }
    
    private var isCurrentWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekday)
    }
    
    private var isCurrentYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
}
