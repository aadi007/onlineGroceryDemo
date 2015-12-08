//
//  CartViewController.swift
//  OnlineGroceryShop
//
//  Created by Aadesh Maheshwari on 07/12/15.
//  Copyright © 2015 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import CoreData

class CartViewController: UIViewController, UITableViewDataSource, PayPalPaymentDelegate {

    var groceryProducts = [NSManagedObject]()
    private let reuseIdentifier = "SelectedItemCell"
    private let totalAmountIdentifier = "TotalPriceCell"
    @IBOutlet weak var tableView: UITableView!
    private var totalAmount = 0
    
    var payPalConfig = PayPalConfiguration()
    var enviornment: String = PayPalEnvironmentNoNetwork {
        willSet(newEnviornment) {
            if newEnviornment != enviornment {
                PayPalMobile.preconnectWithEnvironment(newEnviornment)
            }
        }
    }
    #if HAS_CARDIO
    var acceptCreditCards: Bool = true {
        didSet {
        payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    #else
    var acceptCreditCards: Bool = false {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    #endif

    
    override func viewDidLoad() {
        super.viewDidLoad()
        payPalConfig.acceptCreditCards = acceptCreditCards
        payPalConfig.merchantName = "Aadi's World"
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages()[0] 
        payPalConfig.payPalShippingAddressOption = .PayPal
        PayPalMobile.preconnectWithEnvironment(enviornment)
        fetchSelectedItems()
    }
    
    func fetchSelectedItems() {
        //check if the local storage has the data present in the DB to be shown
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Grocery")
        fetchRequest.predicate = NSPredicate(format: "selected = %d", 1)
        
        do {
            groceryProducts =
            try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            print("selected grocery count \(groceryProducts.count)")
            if groceryProducts.count == 0 {
            } else {
                self.tableView.reloadData()
            }
        } catch let error as NSError {
            print("Could not in updated selected value \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MakePaymentButtonClicked(sender: AnyObject) {
        //add the item to the paypal account for payment 
        var items = [PayPalItem]()
        for product in groceryProducts {
            var itemName = "item"
            var itemPrice = "14.2"
            if let name = product.valueForKey("name") as? String {
                itemName =  name
            }
            if let price = product.valueForKey("price") as? String {
                let components = price.componentsSeparatedByString("/")
                if let amount = components.first {
                    itemPrice = amount
                }
            }

            let item1 = PayPalItem(name: itemName, withQuantity: 1, withPrice: NSDecimalNumber(string: itemPrice), withCurrency: "USD", withSku: "aadiWorld-\(index)")
            items.append(item1)
        }
        let subTotal = PayPalItem.totalPriceForItems(items)
        let payment = PayPalPayment(amount: subTotal, currencyCode: "USD", shortDescription: "AddWorldTesting", intent: .Sale)
        payment.items = items
        if payment.processable {
           let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            presentViewController(paymentViewController, animated: true, completion: nil)
        } else {
            
        }
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var tableCount = groceryProducts.count
        if tableCount > 0 {
            tableCount++
        }
        return tableCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == groceryProducts.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(totalAmountIdentifier, forIndexPath: indexPath) as! TotalAmountCartViewCell
            cell.totalAmountLabel.text = "\(totalAmount)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SelectedProductViewCell
            if let product: NSManagedObject = groceryProducts[indexPath.row] {
                if let name = product.valueForKey("name") as? String {
                    cell.titleLabel.text =  name
                }
                if let price = product.valueForKey("price") as? String {
                    cell.priceLabel.text =  price
                    let components = price.componentsSeparatedByString("/")
                    if let amount = components.first {
                        cell.amountLabel.text = amount
                        totalAmount += Int(amount)!
                    }
                }
            }
            return cell
        }
    }
    
    
    //PayPal payment delegates
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        print("PayPal payment cancelled")
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        print("PayPal payment completed")
        paymentViewController.dismissViewControllerAnimated(true) { () -> Void in
            print("proof of payment \(completedPayment.confirmation)")
        }
        let alert = UIAlertView(title: "Payment Successfull!", message: "Order placed", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok")
        alert.show()
        self.navigationController?.popViewControllerAnimated(false)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
