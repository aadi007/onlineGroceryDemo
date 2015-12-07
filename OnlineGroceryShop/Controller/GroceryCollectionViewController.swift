//
//  GroceryCollectionViewController.swift
//  OnlineGroceryShop
//
//  Created by Aadesh Maheshwari on 07/12/15.
//  Copyright © 2015 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "ProductCell"
class GroceryCollectionViewController: UICollectionViewController {

    var groceryProducts = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        fetchGroceriesLocally()
        self.collectionView?.allowsMultipleSelection = true
    }

    func fetchGroceriesLocally() {
        //check if the local storage has the data present in the DB to be shown
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Grocery")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            groceryProducts = results as! [NSManagedObject]
            if groceryProducts.count == 0 {
                print("fetch the contents from the list and store it")
                addDummyData()
            } else {
                self.title = "\(groceryProducts.count) products"
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func addDummyData() {
        for index in 0..<10 {
            var name = "Apple"
            if index % 3 == 0 {
                name = "Banana"
            } else if index % 3 == 1 {
                name = "Guava"
            }
            saveProduct(Product.init(productName: name, productId: Int16(index), productPrice: "\(index)/kg"))
        }
    }
    
    func saveProduct(product: Product) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Grocery", inManagedObjectContext:managedContext)
        
        let productData = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if let name = product.name {
            productData.setValue(name, forKey: "name")
        }
        if let price = product.price {
            productData.setValue(price, forKey: "price")
        }
        let productId = NSNumber(short: product.Id)
        productData.setValue(productId, forKey: "id")
        
        do {
            try managedContext.save()
            groceryProducts.append(productData)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return groceryProducts.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProductViewCell
        if let product: NSManagedObject = groceryProducts[indexPath.row] {
            if let name = product.valueForKey("name") as? String {
                cell.nameLabel.text =  name
            }
            if let price = product.valueForKey("price") as? String {
                cell.priceLabel.text =  price
            }
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
