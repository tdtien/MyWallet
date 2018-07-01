//
//  ChartValueFormatter.swift
//  MyWallet
//
//  Created by Tien Huynh on 7/1/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit
import Charts

class ChartValueFormatter: NSObject, IValueFormatter {
    fileprivate var numberFormatter: NumberFormatter?
    convenience init(numberFormatter: NumberFormatter)
    {
        self.init()
        self.numberFormatter = numberFormatter
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        guard let numberFormatter = numberFormatter else {
            return ""
        }
        return formatCurrency(string: String(format: "%.0f", value))
    }
}

private func formatCurrency(string: String) -> String {
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
    str = str + " ₫"
    return str
}
