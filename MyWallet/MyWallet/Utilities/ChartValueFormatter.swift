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
        return Utilities.formatCurrency(string: String(format: "%.0f", value))
    }
}

