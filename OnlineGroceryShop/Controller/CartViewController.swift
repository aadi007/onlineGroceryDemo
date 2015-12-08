//
//  CartViewController.swift
//  OnlineGroceryShop
//
//  Created by Aadesh Maheshwari on 07/12/15.
//  Copyright © 2015 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import CoreData

class CartViewController: UIViewController, UITableViewDataSource {

    var groceryProducts = [NSManagedObject]()
    private let reuseIdentifier = "SelectedItemCell"
    private let totalAmountIdentifier = "TotalPriceCell"
    @IBOutlet weak var tableView: UITableView!
    private var totalAmount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
