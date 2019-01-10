//
//  TransactionBusiness.swift
//  MyWallet
//
//  Created by Hoang Tien on 1/10/19.
//  Copyright © 2019 Tran Duy Tien. All rights reserved.
//

import UIKit

class TransactionBusiness: NSObject {
    
    static let sharedInstance = TransactionBusiness()
    private let transactionAdapter = TransactionAdapter.sharedInstance
    
    private override init() {
        print("Singleton class")
    }
    
    func loadAllTransactionsFromDevice() -> [Transaction]? {
        let listTransactionEntity = transactionAdapter.loadTransactionsFromDevice()
        if (listTransactionEntity == nil || listTransactionEntity?.count == 0) {
            return nil
        }
        var listTransaction = [Transaction]()
        for item in listTransactionEntity! {
            let date = item.date!
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let dateString = formatter.string(from: date)
            let transaction = Transaction(photo: UIImage(data: item.photo!, scale: 1.0), category: item.category!, type: Int(item.type), price: item.price!, note: item.note!, date: dateString)
            listTransaction.append(transaction!)
        }
        return listTransaction
    }
    
    func saveTransaction(transaction: Transaction) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.date(from: transaction.date)
        let imageData = NSData(data: UIImageJPEGRepresentation(transaction.photo!, 1.0)!)

        transactionAdapter.saveTransaction(type: transaction.type, price: transaction.price, category: transaction.category, date: date!, note: transaction.note, photo: imageData)
    }
    
    func deleteTransaction(idx: Int) {
        transactionAdapter.deleteTransaction(idx: idx)
    }
    
    func deleteAllTransactions() {
        transactionAdapter.deleteAllTransactions()
    }
    
    func loadTransactionsFormDeviceWith(dateFrom: Date, dateTo: Date) -> [Transaction]? {
        let listTransactionEntity = transactionAdapter.loadTransactionsFromDevice()
        if (listTransactionEntity == nil || listTransactionEntity?.count == 0) {
            return nil
        }
        var listTransaction = [Transaction]()
        for item in listTransactionEntity! {
            let date = item.date!
            
            if (dateFrom <= date && date <= dateTo)
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let dateString = formatter.string(from: date)
                let transaction = Transaction(photo: UIImage(data: item.photo!, scale: 1.0), category: item.category!, type: Int(item.type), price: item.price!, note: item.note!, date: dateString)
                listTransaction.append(transaction!)
            }
        }
        return listTransaction
    }
}
