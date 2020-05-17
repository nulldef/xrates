//
//  Date.swift
//  XRates
//
//  Created by nulldef on 17.05.2020.
//  Copyright © 2020 nulldef. All rights reserved.
//

import Foundation

extension Date {
    static func parse(string: String, format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: string)
    }
    
    func format(_ format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func adding(_ days: Int) -> Date {
        guard let date = Calendar.current.date(byAdding: .day, value: days, to: self) else {
            fatalError("Can't get a day before \(self.format())")
        }
        return date
    }
}
