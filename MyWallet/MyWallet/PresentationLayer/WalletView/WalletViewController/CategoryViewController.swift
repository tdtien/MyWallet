//
//  CategoryViewController.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/21/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var segment = 0;
    var categories = [Category]()
    var categoryChoosen:Category? = nil
    var categoriesWithSegment = [Category]()
    var currentCategories = [Category]()
    let categoryAdapter = CategoryAdapter.sharedInstance
    @IBOutlet weak var searhBar: UISearchBar!
    @IBOutlet weak var segmentOulet: UISegmentedControl!
    @IBOutlet weak var tblView: UITableView!
    
    @IBAction func segmentTapped(_ sender: Any) {
        segment = segmentOulet.selectedSegmentIndex
        categoriesWithSegment.removeAll()
        currentCategories.removeAll()
        for aCategory in categories {
            if aCategory.type == segment {
                categoriesWithSegment.append(aCategory)
                currentCategories.append(aCategory)
            }
        }
        tblView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Init and set search bar
        searhBar.delegate = self
        
        self.categories = categoryAdapter.loadCategory()
        for aCategory in categories {
            if aCategory.type == segment {
                categoriesWithSegment.append(aCategory)
                currentCategories.append(aCategory)
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
        return currentCategories.count
        //return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllCategoryViewControllerID", for: indexPath) as? AllCategoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of AllCategoryViewControllerID.")
        }
        let category = currentCategories[indexPath.row]
        
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
        categoryChoosen = currentCategories[indexPath.row]
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addTransactionViewController = navigationController?.viewControllers[0] as? AddTransactionViewController
        addTransactionViewController?.myCategory = categoryChoosen
        self.navigationController?.popViewController(animated: true)
    }
    
    //Mark: Search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentCategories = categoriesWithSegment
            tblView.reloadData()
            return
        }
        currentCategories = categoriesWithSegment.filter( { aCategory -> Bool in
            aCategory.nameCategory.lowercased().contains(searchText.lowercased())
        })
        tblView.reloadData()
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
