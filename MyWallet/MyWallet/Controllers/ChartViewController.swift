//
//  ChartViewController.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/30/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController, UITextFieldDelegate {

    //Mark: Property
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var txtDateFrom: UITextField!
    @IBOutlet weak var txtDateTo: UITextField!
    let dateFromPicker = UIDatePicker()
    let dateToPicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtDateFrom.delegate = self
        txtDateTo.delegate = self
        txtDateFrom.addTarget(self, action: #selector(createDateFromPicker), for: UIControlEvents.touchDown)
        txtDateTo.addTarget(self, action: #selector(createDateToPicker), for: UIControlEvents.touchDown)
        let categories = ["Food", "Transportation", "Healthy", "Education", "Salary", "Entertainment", "Other"]
        let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 8.0]
        setChart(dataPoints: categories, values: values)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*private func textFieldShouldBeginEditing(_ textField: UITextField) {
        if textField === txtDateFrom
        {
            txtDateFrom.addTarget(self, action: #selector(createDateFromPicker), for: UIControlEvents.touchDown)
        }
        if textField === txtDateTo
        {
            txtDateTo.addTarget(self, action: #selector(createDateToPicker), for: UIControlEvents.touchDown)
        }
    }*/
    
    //Mark: Pie Chart
    func setChart(dataPoints: [String], values: [Double])
    {
        var dataEntities: [PieChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry()
            dataEntry.y = values[i]
            dataEntry.label = dataPoints[i]
            dataEntities.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(values: dataEntities, label: "")
        var colors: [UIColor] = []
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        
        pieChartDataSet.colors = colors
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        //Some set up to Pie Chart
        let description = Description()
        description.text = ""
        pieChartView.chartDescription = description
        pieChartView.noDataText = "No data available"
        pieChartView.centerText = "Pie Chart"
    }
    
    @objc func createDateFromPicker()
    {
        dateFromPicker.datePickerMode = .date
        dateFromPicker.locale = Locale(identifier: "en_GB")
        dateFromPicker.setDate(Date(), animated: false)
        dateFromPicker.backgroundColor = UIColor.white
        txtDateFrom.inputView = dateFromPicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //add done button
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneFromPressed))
        toolbar.setItems([doneButton], animated: true)
        txtDateFrom.inputAccessoryView = toolbar
    }
    
    @objc func doneFromPressed()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        let dateString = dateFormatter.string(from: dateFromPicker.date)
        txtDateFrom.text = dateString
        self.view.endEditing(true)
    }
    
    @objc func createDateToPicker()
    {
        dateToPicker.datePickerMode = .date
        dateToPicker.locale = Locale(identifier: "en_GB")
        dateToPicker.setDate(Date(), animated: false)
        dateToPicker.backgroundColor = UIColor.white
        txtDateTo.inputView = dateToPicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //add done button
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneToPressed))
        toolbar.setItems([doneButton], animated: true)
        txtDateTo.inputAccessoryView = toolbar
    }
    
    @objc func doneToPressed()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        let dateString = dateFormatter.string(from: dateToPicker.date)
        txtDateTo.text = dateString
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
