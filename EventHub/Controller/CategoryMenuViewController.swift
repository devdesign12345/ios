//
//  CategoryMenuViewController.swift
//  EventHub
//
//  Created by BIGSCAL on 10/9/15.
//  Copyright (c) 2015 BIGSCAL. All rights reserved.
//

import UIKit

class CategoryMenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tblCategory : UITableView!
    var categoryArray : NSMutableArray = NSMutableArray()
    var childCatArray : NSMutableArray = NSMutableArray()
    var subChildArray : NSMutableArray = NSMutableArray()
    
    var sectionTitleArray : NSMutableArray = NSMutableArray()
    var sectionContentDict : NSMutableDictionary = NSMutableDictionary()
    var arrayForBool : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        
        self.getAllCategory()
        
        
    }
    
    // PRAGMA: UITableViewDelegate, UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(arrayForBool.objectAtIndex(section).boolValue == true)
        {
            var catObj : CategoryModal = CategoryModal()
            catObj = self.sectionTitleArray.objectAtIndex(section) as! CategoryModal
            let tps = catObj.cat_Name as String
            
            let tmp1 : NSMutableArray = NSMutableArray()
            for(var i : Int = 0; i < catObj.childArr.count; i++)
            {
                var childObj : ChildCategory = ChildCategory()
                childObj = catObj.childArr.objectAtIndex(i) as! ChildCategory
                
                if let childCat = childObj.cat_Name
                {
                    tmp1.addObject(childCat)
                }
            }
            
            [sectionContentDict.setValue(tmp1, forKey:tps)]
            
            if(sectionContentDict.count > 0)
            {
                
                
                let count1 = (sectionContentDict.valueForKey(tps)) as! NSArray
                return count1.count
            }
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ABC"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(arrayForBool .objectAtIndex(indexPath.section).boolValue == true){
            return 40
        }
        return 2;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.tag = section
        
        let headerString = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.size.width-10, height: 30)) as UILabel
        var catObj : CategoryModal = CategoryModal()
        catObj = self.sectionTitleArray.objectAtIndex(section) as! CategoryModal
        headerString.text = catObj.cat_Name as String
        headerView .addSubview(headerString)
        
        let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
        headerView .addGestureRecognizer(headerTapped)
        
        return headerView
    }
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        
        let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        if (indexPath.row == 0) {
            
            var collapsed = arrayForBool .objectAtIndex(indexPath.section).boolValue
            collapsed       = !collapsed;
            
            arrayForBool .replaceObjectAtIndex(indexPath.section, withObject: collapsed)
            //reload specific section animated
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            self.tblCategory.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let CellIdentifier = "Cell"
        let cell : UITableViewCell = self.tblCategory.dequeueReusableCellWithIdentifier(CellIdentifier)! //as! UITableViewCell
        
        let manyCells : Bool = arrayForBool .objectAtIndex(indexPath.section).boolValue
        var catObj : CategoryModal = CategoryModal()
        catObj = self.sectionTitleArray.objectAtIndex(indexPath.section) as! CategoryModal
        
        if (!manyCells) {
        } else {
            
            let content = sectionContentDict.valueForKey(catObj.cat_Name as String) as! NSArray
            cell.textLabel?.text = content.objectAtIndex(indexPath.row) as? String
            cell.backgroundColor = UIColor.lightGrayColor()
            let cellTapped = UITapGestureRecognizer (target: self, action:"sectionCellTapped:")
            cell.tag = indexPath.row
            cell.addGestureRecognizer(cellTapped)
            
            
            
            
        }
        return cell
    }
    
    func sectionCellTapped(recognizer: UITapGestureRecognizer) {
        var indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
    }
    
    /*========================================================
    * function Name: getAllCategory
    * function Purpose: to get all categories
    * function Parameters: nil
    * function ReturnType: nil
    *=======================================================*/
    func getAllCategory()
    {
       
        
        self.startIndicator()
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        let stringURL : NSString = NSString(format: "%@", Get_All_Category)
        
        manager.GET(stringURL as String, parameters: nil, success: { (operation:AFHTTPRequestOperation? , responseObject:AnyObject?) -> Void in
            if let response: AnyObject = responseObject
            {
                let jsonInfo = (try! NSJSONSerialization.JSONObjectWithData(response as! NSData, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                let arr : NSMutableArray = NSMutableArray(array: jsonInfo.allKeys)
                
                self.categoryArray.removeAllObjects()
                self.categoryArray = NSMutableArray()
                
                for(var i : Int = 0; i < arr.count; i++)
                {
                    let mainDic = jsonInfo.valueForKey(arr.objectAtIndex(i) as! String) as! NSMutableDictionary
                    let mainItems = mainDic.valueForKey("items") as? NSMutableDictionary
                    let arr1 : NSMutableArray = NSMutableArray(array: mainItems!.allKeys)
                    for(var j : Int = 0; j < arr1.count; j++)
                    {
                        let catObj : CategoryModal = CategoryModal()
                        let catDic = mainItems?.valueForKey(arr1.objectAtIndex(j) as! String) as! NSMutableDictionary
                        
                        catObj.cat_Id = catDic.valueForKey("id") as? String ?? ""
                        catObj.cat_Name = catDic.valueForKey("name") as? String ?? ""
                        if let catLeaf = catDic.valueForKey("leaf") as? String {
                            catObj.leaf = catLeaf
                        } else {
                            let childItems = catDic.valueForKey("items") as? NSMutableDictionary
                            let arr2 : NSMutableArray = NSMutableArray(array: childItems!.allKeys)
                            self.childCatArray = NSMutableArray()
                            
                            for(var k : Int = 0; k < arr2.count; k++)
                            {
                                let childObj : ChildCategory = ChildCategory()
                                let childDic = childItems?.valueForKey(arr2.objectAtIndex(k) as! String) as! NSMutableDictionary
                                
                                if let catId = childDic.valueForKey("id") as? String {
                                    childObj.cat_Id = Int(catId)
                                }
                                childObj.cat_Name = childDic.valueForKey("name") as? String ?? ""
                                if let catLeaf = childDic.valueForKey("leaf") as? String {
                                    childObj.leaf = catLeaf
                                } else {
                                    let subChildItems = childDic.valueForKey("items") as? NSMutableDictionary
                                    let arr3 : NSMutableArray = NSMutableArray(array: subChildItems!.allKeys)
                                    self.subChildArray = NSMutableArray()
                                    
                                    for(var l : Int = 0; l < arr3.count; l++)
                                    {
                                        let subChildObj : SubChildCategory = SubChildCategory()
                                        let subChildDic = subChildItems?.valueForKey(arr3.objectAtIndex(l) as! String) as! NSMutableDictionary

                                        if let catId = subChildDic.valueForKey("id") as? String {
                                            subChildObj.cat_Id = Int(catId)
                                        }
                                        if let catName = subChildDic.valueForKey("name") as? String {
                                            subChildObj.cat_Name = catName
                                        }
                                        if let catLeaf = subChildDic.valueForKey("leaf") as? String {
                                            subChildObj.leaf = catLeaf
                                        }
                                        self.subChildArray.addObject(subChildObj)
                                    }
                                    childObj.subChildArr = self.subChildArray
                                }
                                self.childCatArray.addObject(childObj)
                            }
                            catObj.childArr = self.childCatArray
                        }
                        self.arrayForBool.addObject("0")
                        self.categoryArray.addObject(catObj)
                        self.sectionTitleArray.addObject(catObj)
                    }
                }

                let otherObj : CategoryModal = CategoryModal()
                otherObj.cat_Id = "0"
                otherObj.cat_Name = "All events near me"
                self.categoryArray.insertObject(otherObj, atIndex: 0)
                self.arrayForBool.addObject("0")
                self.sectionTitleArray.insertObject(otherObj, atIndex: 0)
                self.tblCategory.reloadData()
            } else {
                NSLog("Error(getAllCategories): Response Object found nil.")
            }
            self.stopIndicator()
        })
        { (operation:AFHTTPRequestOperation? , error : NSError?) -> Void in
            self.stopIndicator()
            print("Failure:(getAllCategories)",error?.description)
        }
    }
}
