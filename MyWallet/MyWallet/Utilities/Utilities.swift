//
//  Utilities.swift
//  MyWallet
//
//  Created by Hoang Tien on 1/3/19.
//  Copyright © 2019 Tran Duy Tien. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
    static func formatCurrency(string: String) -> String {
        var str = string
        var count = 0
        for (index, _) in str.enumerated().reversed() {
            count = count + 1
            if count == 4 {
                let idx = str.index(str.startIndex, offsetBy: index + 1)
                str.insert(",", at: idx)
                count = 1
            }
        }
        return str
    }
    
    //format: 250,000đ -> 250000
    static func formatStrMoneyToDouble(strMoney: String) ->Double
    {
        var result:String = ""
        for char in strMoney {
            if (char == "0" || char == "1" || char == "2" || char == "3" || char == "4" || char == "5" || char == "6" || char == "7" || char == "8" || char == "9")
            {
                result.append(char)
            }
        }
        return Double(result)!
    }
}
extension Date {
    func getNextMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }
    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    func getNextDate() -> Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    func getNextYear() -> Date? {
        return Calendar.current.date(byAdding: .year, value: 1, to: self)
    }
    func getPreviousDate() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    func isInSameWeek(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    func isInSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    func isInSameYear(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    func isInSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
}
extension Calendar {
    func startOfMonth(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: date))!
    }
    
    func endOfMonth(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(date))!
    }
    func startOfYear(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year], from: date))!
    }
    
    func endOfYear(_ date: Date) -> Date {
        return self.date(from: DateComponents(year: self.component(.year, from: date), month: 12, day: 31))!
    }
}
