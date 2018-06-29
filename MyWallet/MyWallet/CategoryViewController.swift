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
    
    @IBAction func segmentTapped(_ sender: Any) {
        if (segment == 0) {
            segment = 1
        }
        else {
            segment = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadSampleCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Mark: TabeView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllCategoryViewControllerID", for: indexPath) as? AllCategoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of AllCategoryViewControllerID.")
        }
        
        let category = categories[indexPath.row]
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryChoosen = categories[indexPath.row]
        self.performSegue(withIdentifier: "ChooseCategory", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addExpenseViewController = segue.destination as! AddExpenseViewController
    addExpenseViewController.myCategory = categoryChoosen
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func loadSampleCategory()
    {
        let photo1 = UIImage(named: "IconAnUong")
        let photo2 = UIImage(named: "IconDiChuyen")
        
        guard let category1 = Category(photo: photo1, nameCategory: "Ăn uống")
            else {
                fatalError("Unable to instantiate category1")
        }
        
        guard let category2 = Category(photo: photo2, nameCategory: "Di chuyển")
            else {
                fatalError("Unable to instantiate category2")
        }
        
        categories+=[category1,category2]
    }

}
