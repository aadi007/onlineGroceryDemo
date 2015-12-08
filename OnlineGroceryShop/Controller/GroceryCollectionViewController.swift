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

//        deleteAllData("Grocery")
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
        saveProduct(Product.init(productName: "Potato", productId: Int16(0), productPrice: "20/kg"))
        saveProduct(Product.init(productName: "Tomato", productId: Int16(1), productPrice: "30/kg"))
        saveProduct(Product.init(productName: "Onion", productId: Int16(2), productPrice: "15/kg"))
        saveProduct(Product.init(productName: "CauliFlower", productId: Int16(3), productPrice: "40/kg"))
        saveProduct(Product.init(productName: "SunFlowerOil", productId: Int16(4), productPrice: "99/Lit"))
        saveProduct(Product.init(productName: "LadyFinger", productId: Int16(5), productPrice: "60/kg"))
        saveProduct(Product.init(productName: "Brinjal", productId: Int16(6), productPrice: "30/kg"))
        saveProduct(Product.init(productName: "Peas", productId: Int16(7), productPrice: "70/kg"))
        saveProduct(Product.init(productName: "Spinach", productId: Int16(8), productPrice: "50/kg"))
        saveProduct(Product.init(productName: "Groundnut", productId: Int16(9), productPrice: "40/kg"))
    }
    
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
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
                if let image = UIImage(named: name) {
                    cell.imageView.image = image
                }
            }
            if let price = product.valueForKey("price") as? String {
                cell.priceLabel.text =  price
            }
            
            if let result = product.valueForKey("selected") as? Bool {
                if result {
                    cell.selectedImage.hidden = false
                } else {
                    cell.selectedImage.hidden = true
                }
            } else {
                cell.selectedImage.hidden = true
            }
        }
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let product: NSManagedObject = groceryProducts[indexPath.row] {
            if let number = product.valueForKey("id") as? NSNumber {
                selectItemIfNotSelected(Int16(number.integerValue))
            }
        }
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
    func selectItemIfNotSelected(productId: Int16) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Grocery")
        fetchRequest.predicate = NSPredicate(format: "id = %d", productId)
        
        do {
            let fetchResults =
            try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            if fetchResults.count != 0 {
                let managedObject:NSManagedObject = fetchResults[0]
                if let result = managedObject.valueForKey("selected") as? Bool {
                    if result {
                        managedObject.setValue(NSNumber(bool: false), forKey: "selected")
                    } else {
                        managedObject.setValue(NSNumber(bool: true), forKey: "selected")
                    }
                } else {
                    managedObject.setValue(NSNumber(bool: true), forKey: "selected")
                }
                
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    print("Could not save in updated selected \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Could not in updated selected value \(error), \(error.userInfo)")
        }
    }
    
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
