//
//  CategoryViewController.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/21/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var segment = 0;
    var categories = [Category]()
    var categoryChoosen:Category? = nil
    var categoriesWithSegment = [Category]()
    @IBOutlet weak var segmentOulet: UISegmentedControl!
    @IBOutlet weak var tblView: UITableView!
    
    @IBAction func segmentTapped(_ sender: Any) {
        /*if (segment == 0) {
            segment = 1
        }
        else {
            segment = 0
        }*/
        segment = segmentOulet.selectedSegmentIndex
        categoriesWithSegment.removeAll()
        for aCategory in categories {
            if aCategory.type == segment {
                categoriesWithSegment.append(aCategory)
            }
        }
        tblView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadCategory()
        for aCategory in categories {
            if aCategory.type == segment {
                categoriesWithSegment.append(aCategory)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        if let ownNavigationController = navigationController {
            ownNavigationController.popViewController(animated: true)
        }
    }
    
    //Mark: TabeView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segment == 0)
        {
            return 16
        }
        else
        {
            return 6
        }
        //return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllCategoryViewControllerID", for: indexPath) as? AllCategoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of AllCategoryViewControllerID.")
        }
        let category = categoriesWithSegment[indexPath.row]
        
        cell.imgCategory.image = category.photo
        cell.txtCategory.text = category.nameCategory
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row <= categories.count) {
            return 70
        }
        else {
            return 60
        }
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        categoryChoosen = categoriesWithSegment[indexPath.row]
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addTransactionViewController = navigationController?.viewControllers[0] as? AddTransactionViewController
        addTransactionViewController?.myCategory = categoryChoosen
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func loadCategory()
    {
        let expensePhoto1 = UIImage(named: "IconAnUong")
        let expensePhoto2 = UIImage(named: "IconBanBeNguoiYeu")
        let expensePhoto3 = UIImage(named: "IconBaoHiem")
        let expensePhoto4 = UIImage(named: "IconDauTu")
        let expensePhoto5 = UIImage(named: "IconDiChuyen")
        let expensePhoto6 = UIImage(named: "IconDuLich")
        let expensePhoto7 = UIImage(named: "IconGiaDinh")
        let expensePhoto8 = UIImage(named: "IconGiaiTri")
        let expensePhoto9 = UIImage(named: "IconGiaoDuc")
        let expensePhoto10 = UIImage(named: "IconHoaDonTienIch")
        let expensePhoto11 = UIImage(named: "IconKhoanChiKhac")
        let expensePhoto12 = UIImage(named: "IconKinhDoanh")
        let expensePhoto13 = UIImage(named: "IconMuaSam")
        let expensePhoto14 = UIImage(named: "IconQuaTangTuThien")
        let expensePhoto15 = UIImage(named: "IconRutTien")
        let expensePhoto16 = UIImage(named: "IconSucKhoe")
        
        let incomePhoto1 = UIImage(named: "IconBanDo")
        let incomePhoto2 = UIImage(named: "IconDuocTang")
        let incomePhoto3 = UIImage(named: "IconKhoanThuKhac")
        let incomePhoto4 = UIImage(named: "IconLuong")
        let incomePhoto5 = UIImage(named: "IconThuong")
        let incomePhoto6 = UIImage(named: "IconTienLai")
        
        //Expense
        guard let categoryExpense1 = Category(photo: expensePhoto1, nameCategory: "Food & Beverage", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense1")
        }
        guard let categoryExpense2 = Category(photo: expensePhoto2, nameCategory: "Friends and Lover", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense2")
        }
        guard let categoryExpense3 = Category(photo: expensePhoto3, nameCategory: "Insurances", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense3")
        }
        guard let categoryExpense4 = Category(photo: expensePhoto4, nameCategory: "Investment", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense4")
        }
        guard let categoryExpense5 = Category(photo: expensePhoto5, nameCategory: "Transportation", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense5")
        }
        guard let categoryExpense6 = Category(photo: expensePhoto6, nameCategory: "Travel", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense6")
        }
        guard let categoryExpense7 = Category(photo: expensePhoto7, nameCategory: "Family", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense7")
        }
        guard let categoryExpense8 = Category(photo: expensePhoto8, nameCategory: "Entertainment", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense8")
        }
        guard let categoryExpense9 = Category(photo: expensePhoto9, nameCategory: "Education", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense9")
        }
        guard let categoryExpense10 = Category(photo: expensePhoto10, nameCategory: "Bills & Ultities", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense10")
        }
        guard let categoryExpense11 = Category(photo: expensePhoto11, nameCategory: "Others", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense11")
        }
        guard let categoryExpense12 = Category(photo: expensePhoto12, nameCategory: "Business", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense12")
        }
        guard let categoryExpense13 = Category(photo: expensePhoto13, nameCategory: "Shopping", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense13")
        }
        guard let categoryExpense14 = Category(photo: expensePhoto14, nameCategory: "Gifts & Donations", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense14")
        }
        guard let categoryExpense15 = Category(photo: expensePhoto15, nameCategory: "Withdrawal", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense15")
        }
        guard let categoryExpense16 = Category(photo: expensePhoto16, nameCategory: "Health & Fitness", type: 0)
            else {
                fatalError("Unable to instantiate categoryExpense16")
        }
        
        //Income
        guard let categoryIncome1 = Category(photo: incomePhoto1, nameCategory: "Selling", type: 1)
            else {
                fatalError("Unable to instantiate categoryIncome1")
        }
        guard let categoryIncome2 = Category(photo: incomePhoto2, nameCategory: "Gifts", type: 1)
            else {
                fatalError("Unable to instantiate categoryIncome2")
        }
        guard let categoryIncome3 = Category(photo: incomePhoto3, nameCategory: "Others", type: 1)
            else {
                fatalError("Unable to instantiate categoryIncome3")
        }
        guard let categoryIncome4 = Category(photo: incomePhoto4, nameCategory: "Salary", type: 1)
            else {
                fatalError("Unable to instantiate categoryIncome4")
        }
        guard let categoryIncome5 = Category(photo: incomePhoto5, nameCategory: "Award", type: 1)
            else {
                fatalError("Unable to instantiate categoryIncome5")
        }
        guard let categoryIncome6 = Category(photo: incomePhoto6, nameCategory: "Interest Money", type: 1)
            else {
                fatalError("Unable to instantiate categoryIncome6")
        }
        
        categories += [categoryExpense1, categoryExpense10, categoryExpense5, categoryExpense13, categoryExpense2, categoryExpense8, categoryExpense6, categoryExpense16, categoryExpense14, categoryExpense7, categoryExpense9, categoryExpense4, categoryExpense12, categoryExpense3, categoryExpense15, categoryExpense11]
        
        categories += [categoryIncome5, categoryIncome6, categoryIncome4, categoryIncome2, categoryIncome1, categoryIncome3]
    }

}
