//
//  TransactionAdapter.swift
//  MyWallet
//
//  Created by Hoang Tien on 1/10/19.
//  Copyright © 2019 Tran Duy Tien. All rights reserved.
//

import UIKit
import CoreData

class TransactionAdapter: NSObject {
    
    static let sharedInstance = TransactionAdapter()
    
    private override init() {
        print("Singleton class")
    }
    
    func saveTransaction(type: Int, price: String, category: String, date: Date, note: String, photo: NSData) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let transactionEntity = NSEntityDescription.entity(forEntityName: "TransactionEntity", in: context)
        let newTransaction = NSManagedObject(entity: transactionEntity!, insertInto: context)
        newTransaction.setValue(type, forKey: "type")
        newTransaction.setValue(price, forKey: "price")
        newTransaction.setValue(category, forKey: "category")
        newTransaction.setValue(date, forKey: "date")
        newTransaction.setValue(note, forKey: "note")
        newTransaction.setValue(photo, forKey: "photo")
        do {
            try context.save()
        } catch {
            print("Failed saving...")
        }
    }
    
    func deleteTransaction(idx: Int) {
        var list = [TransactionEntity]()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let transactionFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
        do {
            list = try context.fetch(transactionFetch) as! [TransactionEntity]
        } catch {
            print("Fetching failed")
        }
        context.delete(list[idx] as NSManagedObject)
        do {
            try context.save()
        } catch {
            print("Failed deleting")
        }
    }
    
    func deleteAllTransactions() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let transactionFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
        let deletereq = NSBatchDeleteRequest(fetchRequest: transactionFetch)
        do {
            try context.execute(deletereq)
        } catch {
            print("Failed deleting all")
        }
    }
    
    func loadTransactionsFromDevice() -> [TransactionEntity]? {
        var listTransactionEntity = [TransactionEntity]()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let transactionFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
        do {
            listTransactionEntity = try context.fetch(transactionFetch) as! [TransactionEntity]
        } catch {
            print("Fetching failed")
        }
        return listTransactionEntity
    }
}
