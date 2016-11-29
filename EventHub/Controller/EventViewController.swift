//
//  ViewController.swift
//  EventHub
//
//  Created by Bigscal on 05/10/15.
//  Copyright © 2015 Bigscal. All rights reserved.
//

import UIKit
import CoreLocation
var justOnce:Bool = true

//Event Types
enum Section : String {
    case Featured = "Featured"
    case NonFeatured = "Upcoming"
    case Category3 = "To be define 3"
    case Category4 = "To be define 4"
}

@objc protocol selectedIndexDelegate {
    
    optional func returnSelectedItemIndex(index:Int)
    optional func returnSelectedItemIndex(index:Int, section_number : Int)
    optional func returnSelectedIndex(index:Int)
}

// Term  Window View
class termWindow : UIView {
    
    @IBOutlet var  btnChk : UIButton!
    @IBOutlet var  btnAgree  : UIButton!
    @IBOutlet var  textview  : UITextView!
}

// Info Window View
class infoWindow : UIView {
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblAddr : UILabel!
    @IBOutlet var imgEvent : UIImageView!
    
    override func awakeFromNib() {
    }
}

// Header view for event
class HeaderView : UIView {
    
    @IBOutlet var lblTitle : UILabel!
}

// Event List View
class EventListView : UIView, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    @IBOutlet var eventTableView : UITableView!
    @IBOutlet var txtSearch : UITextField!
    @IBOutlet var lblNoSearch : UILabel!
    
    var delegate : selectedIndexDelegate!
    var headerTitleView : HeaderView = HeaderView()
    var activityIndicator : UIActivityIndicatorView!
    var userDefault = NSUserDefaults.standardUserDefaults()
    
    // Events data variables
    var searchArray : NSArray = NSArray()
    var eventArray : NSMutableArray = NSMutableArray()
    var arrSections: NSMutableArray = NSMutableArray()
    var dictSectionValue: NSMutableDictionary = NSMutableDictionary()
    
    override func awakeFromNib() {
        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self
        
        self.getAllEvents()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getListOfEvent:", name: "getListOfEvent", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "getListOfEvent", object: nil)
    }
    
    /*========================================================
    * function Name: getListOfEvent
    * function Purpose: check for gps availability and status.
    * function Parameters: notification
    * function ReturnType: nil
    *=======================================================*/
    func getListOfEvent(notification: NSNotification) {
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            if(status == CLAuthorizationStatus.Denied) {
                
            } else {
                
            }
        }
        self.getAllEvents()
    }
    
    // PRAGMA :-  UITableView Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if((self.txtSearch.text! as NSString).length > 0) {
            return 1
        } else {
            return self.arrSections.count
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        return 45
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let nib: NSArray = NSBundle.mainBundle().loadNibNamed("EventListCell", owner: self, options: nil)
        self.headerTitleView = nib.objectAtIndex(1) as! HeaderView
        self.headerTitleView.lblTitle.text = ""
        
        if((self.txtSearch.text! as NSString).length > 0) {
            self.headerTitleView.lblTitle.text = "Search Result"
        } else {
            let headerTitle = self.arrSections.objectAtIndex(section) as? String ?? ""
            self.headerTitleView.lblTitle.text = headerTitle
            switch headerTitle{
            case Section.Featured.rawValue:
                self.headerTitleView.lblTitle.backgroundColor = UIColor(red: 214/255, green: 83/255, blue: 86/255, alpha: 1)
                break
            case Section.NonFeatured.rawValue:
                self.headerTitleView.lblTitle.backgroundColor = UIColor(red: 77/255, green: 149/255, blue: 215/255, alpha: 1)
                break
            default:
                break
            }
        }
        return self.headerTitleView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier(EventViewCellIdentifier) as! EventViewCell!
        if let _ = cell {
        } else {
            let nib: NSArray = NSBundle.mainBundle().loadNibNamed("EventListCell", owner: self, options: nil)
            cell = nib.objectAtIndex(0) as! EventViewCell
        }
        
        cell.containerView.layer.cornerRadius = CELL_VIEW_RADIUS
        cell.containerView.layer.shadowColor = CELL_VIEW_SHADOW_COLOR
        cell.containerView.layer.shadowOpacity = 0.8
        cell.containerView.layer.shadowOffset = CGSizeMake(1.5,1.5)
      
        var eventObj : EventModal = EventModal()
        
        if(searchArray.count > 0) {
            eventObj = self.searchArray.objectAtIndex(indexPath.row) as! EventModal
        } else {
            let sectionTitle = self.arrSections.objectAtIndex(indexPath.section) as! String
            var arrData = NSArray()
            if(self.dictSectionValue.allKeys as NSArray!).containsObject(sectionTitle) {
                arrData = self.dictSectionValue.valueForKey(sectionTitle) as! NSArray
            }
            eventObj = arrData.objectAtIndex(indexPath.row) as! EventModal
        }

        cell.lblEventTitle.text = eventObj.title as String
        cell.lblEventAddr.text = eventObj.address as String
        if eventObj.imagePath != nil && eventObj.imagePath != "" {
            cell.eventImg?.sd_setImageWithURL(NSURL(string: eventObj.imagePath as String), placeholderImage: UIImage(named: "no-image"))
        } else {
            cell.eventImg?.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "no-image"))
        }
        
        // Event Highlights
        if (eventObj.keyFeature == "1") {
            
            
            cell.containerView.backgroundColor =  UIColor(red: 231/255, green: 122/255, blue: 115/255, alpha: 1)//UIColor(red: 255/255, green: 74/255, blue: 77/255, alpha: 1)//UIColor(red: 160/255, green: 203/255, blue: 235/255, alpha: 1) //Green
        } else if(eventObj.keyFeature == "0"){
            
            cell.containerView.backgroundColor = UIColor(red: 160/255, green: 203/255, blue: 235/255, alpha: 1)//UIColor(red: 77/255, green: 149/255, blue: 215/255, alpha: 1) //Violet
        }
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if((self.txtSearch.text! as NSString).length > 0)
        {
            if(self.searchArray.count > 0) {
                self.lblNoSearch!.hidden = true
                self.eventTableView.hidden = false
                return self.searchArray.count
            } else {
                self.lblNoSearch!.hidden = false
                self.eventTableView.hidden = true
                return 0
            }
        } else {
            if(self.eventArray.count > 0)
            {
                self.lblNoSearch!.hidden = true
                self.eventTableView.hidden = false
                
                let sectionTitle = self.arrSections.objectAtIndex(section) as! String
                if(self.dictSectionValue.allKeys as NSArray!).containsObject(sectionTitle) {
                    return (self.dictSectionValue.valueForKey(sectionTitle) as! NSArray).count
                } else {
                    return 0
                }
            } else {
                self.lblNoSearch!.hidden = false
                self.eventTableView.hidden = true
                return 0
            }
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.txtSearch.resignFirstResponder()
        if(self.searchArray.count > 0) {
            self.delegate.returnSelectedItemIndex!(indexPath.row)
        } else {
            self.delegate.returnSelectedItemIndex!(indexPath.row, section_number: indexPath.section)
        }
    }
    
    // PRAGMA: UITextField Delegate Method
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func filterContentForSearchText(sender: AnyObject)
    {
        let searchText: String = self.txtSearch.text!
        let resultPredicate: NSPredicate = NSPredicate(format: "SELF.title contains[cd] %@ OR SELF.body1 contains[cd] %@ OR SELF.body2 contains[cd] %@ OR SELF.category_name contains[cd] %@ OR SELF.body3 contains[cd] %@ OR SELF.body5 contains[cd] %@ OR SELF.address contains[cd] %@", searchText,searchText,searchText,searchText,searchText,searchText,searchText)
        self.searchArray = self.eventArray.filteredArrayUsingPredicate(resultPredicate)
        self.eventTableView?.reloadData()
    }
   
    /*========================================================
    * function Name: getAllEvents
    * function Purpose: get all events
    * function Parameters: nil
    * function ReturnType: nil
    *=======================================================*/
    func getAllEvents()
    {
        var stringURL : NSString = ""
        if(self.userDefault.valueForKey("catId") != nil)
        {
            self.startIndicator()
            
            let manager = AFHTTPRequestOperationManager()
            manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
            let cat_id = self.userDefault.valueForKey("catId") as! NSInteger
            let dis = 4000
            
            if(self.userDefault.valueForKey("lat") != nil && self.userDefault.valueForKey("lon") != nil)
            {
//                let lat = self.userDefault.valueForKey("lat") as! NSInteger
//                let lon = self.userDefault.valueForKey("lon") as! NSInteger
//                
//                if(cat_id == 0) {
//                    // Events without category
//                    stringURL = NSString(format:Near_Events_with_gps,lat,lon,dis)
//                } else {
//                    // Events With Category
//                    stringURL = NSString(format: BASE_URL,lat,lon,dis,cat_id)
//                    
//                }
                
                
                if(cat_id == 0) {
                    // Near by events without passing lat long and cat id
                    stringURL = NSString(format: "%@", Near_Events)
                } else {
                    // Events With Category
                    stringURL = NSString(format: Get_Events_By_CategoryID,cat_id)
                }
                
                
            } else {
                if(cat_id == 0) {
                    // Near by events without passing lat long and cat id
                    stringURL = NSString(format: "%@", Near_Events)
                } else {
                    // Events With Category
                    stringURL = NSString(format: Get_Events_By_CategoryID,cat_id)
                }
            }
            
            if(stringURL.length  > 0)
            {
                manager.GET(stringURL as String, parameters: nil, success: { (operation:AFHTTPRequestOperation? , responseObject:AnyObject?) -> Void in
                    
                    if let response: AnyObject = responseObject
                    {
                        let arrFeature = NSMutableArray()
                        let arrNonFeature = NSMutableArray()
                        let arrCat3 = NSMutableArray()
                        let arrCat4 = NSMutableArray()
                        
                        self.eventArray.removeAllObjects()
                        self.eventArray = NSMutableArray()

                        for(var i : Int = 0; i < response.count; i++)
                        {
                            
                            
                            
                            let eventDic = response.objectAtIndex(i) as! NSMutableDictionary
                        
                            let eventObj : EventModal = EventModal()
                            eventObj.id = eventDic.valueForKey("id") as? String ?? ""
                            eventObj.category_id = eventDic.valueForKey("category_id") as? String ?? ""
                            eventObj.category_name = eventDic.valueForKey("category_name") as? String ?? ""
                            eventObj.name = eventDic.valueForKey("name") as? String ?? ""
                            eventObj.title = eventDic.valueForKey("title") as? String ?? ""
                            eventObj.body1 = eventDic.valueForKey("body1") as? String ?? ""
                            eventObj.body2 = eventDic.valueForKey("body2") as? String ?? ""
                            eventObj.body3 = eventDic.valueForKey("body3") as? String ?? ""
                            eventObj.body5 = eventDic.valueForKey("body5") as? String ?? ""
                            eventObj.body6 = eventDic.valueForKey("body6") as? String ?? ""
                            eventObj.address = eventDic.valueForKey("address") as? String ?? ""
                            eventObj.country = eventDic.valueForKey("country") as? String ?? ""
                            eventObj.lati = eventDic.valueForKey("lat") as? String
                            eventObj.longi = eventDic.valueForKey("lng") as? String ?? ""
                            eventObj.locality = eventDic.valueForKey("locality") as? String ?? ""
                            
                            eventObj.type = eventDic.valueForKey("type") as? String ?? ""
                            if let img_Path = eventDic.valueForKey("img_path") as? String
                            {
                                let img = NSString(format: "http://%@", img_Path).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                                eventObj.imagePath = img
                            }
                            if let start_Time = eventDic.valueForKey("showtime") as? NSString
                            {
                                let dateTime = NSDate(timeIntervalSince1970: start_Time.doubleValue)
                                eventObj.startDate = dateTime
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle //Set time style
                                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle //Set date style
                                dateFormatter.timeZone = NSTimeZone()
                                let localDate = dateFormatter.stringFromDate(dateTime)
                                eventObj.startTime = localDate
                                
                                
                            }
                            if let end_Time = eventDic.valueForKey("number2") as? NSString
                            {
                                let dateTime = NSDate(timeIntervalSince1970: end_Time.doubleValue)
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle //Set time style
                                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle //Set date style
                                dateFormatter.timeZone = NSTimeZone()
                                let localDate = dateFormatter.stringFromDate(dateTime)
                                eventObj.endTime = localDate
                            }
                            if let key_feature = eventDic.valueForKey("number4") as? NSString
                            {
                                eventObj.keyFeature = key_feature
                            }
                            self.eventArray.addObject(eventObj)
                            
                            // Event by Key Feature
                            if(eventObj.keyFeature == "0")
                            {
                                arrFeature.addObject(eventObj)
                            }
                            else if(eventObj.keyFeature == "1")
                            {
                                arrNonFeature.addObject(eventObj)
                            }
                            else if(eventObj.keyFeature == "2")
                            {
                                arrCat3.addObject(eventObj)
                            }
                            else if(eventObj.keyFeature == "3")
                            {
                                arrCat4.addObject(eventObj)
                            }
                        }
                        
                        // compare date and sort array by dates
                        let sortedArray : NSArray = self.eventArray.sortedArrayUsingComparator { (activity1:AnyObject!, activity2:AnyObject!) -> NSComparisonResult in
                            var dateString1: NSDate, dateString2:NSDate
                            dateString1 = (activity1 as! EventModal).startDate
                            dateString2 = (activity2 as! EventModal).startDate
                            return dateString1.compare(dateString2)
                        }
                        self.eventArray = NSMutableArray()
                        self.eventArray.addObjectsFromArray(sortedArray as [AnyObject])
                        
                        self.arrSections.removeAllObjects()
                        self.arrSections = NSMutableArray()
                        self.dictSectionValue.removeAllObjects()
                        self.dictSectionValue = NSMutableDictionary()
                        
                        // Store all section array in 1 array
                        if arrNonFeature.count > 0 {
                            self.dictSectionValue.setValue(arrNonFeature, forKey: Section.Featured.rawValue)
                            self.arrSections.addObject(Section.Featured.rawValue)
                        }
                        if arrFeature.count > 0 {
                            self.dictSectionValue.setObject(arrFeature, forKey: Section.NonFeatured.rawValue)
                            self.arrSections.addObject(Section.NonFeatured.rawValue)
                        }
                        if arrCat3.count > 0 {
                            self.dictSectionValue.setObject(arrCat3, forKey: Section.Category3.rawValue)
                            self.arrSections.addObject(Section.Category3.rawValue)
                        }
                        if arrCat4.count > 0 {
                            self.dictSectionValue.setObject(arrCat4, forKey: Section.Category4.rawValue)
                            self.arrSections.addObject(Section.Category4.rawValue)
                        }
                        
                        self.eventTableView.reloadData()
                    }
                    else
                    {
                        NSLog("Error: Response object found nil.")
                    }
                    self.stopIndicator()
                    
                    }, failure: { (operation, error) -> Void in
                        self.stopIndicator()
                        print("Failure : ",error.description)
                })
            } else {
                self.stopIndicator()
            }
        }
    }
    
    /*========================================================
    * function Name: startIndicator() ,stopIndicator()
    * function Purpose: start and stop indicator
    * function Parameters: nil
    * function ReturnType: nil
    *=======================================================*/
    func startIndicator() {
        self.stopIndicator()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.addSubview(self.activityIndicator!)
        self.activityIndicator?.center = CGPointMake(AppUtilities.getScreenWidth() / 2, (AppUtilities.getScreenHeight() - 100) / 2)
        self.activityIndicator?.tintColor = UIColor(red: 239/255, green: 173/255, blue: 98/255, alpha: 1.0)
        self.activityIndicator?.color = UIColor(red: 239/255, green: 173/255, blue: 98/255, alpha: 1.0)
        self.activityIndicator?.startAnimating()
    }
    
    func stopIndicator() {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
}

//Google Map View
class EventMap : GMSMapView, GMSMapViewDelegate, CLLocationManagerDelegate
{
    var activityIndicator : UIActivityIndicatorView!
    var eventMapArray : NSMutableArray = NSMutableArray()
    var infoDelegate : selectedIndexDelegate!
    var userDefault = NSUserDefaults.standardUserDefaults()
    var currMarkerPos = GMSMarker()
    var infoView : UIView = UIView()
    var lblTitle : UILabel!
    var cnt : Int = 0
    
    @IBOutlet var btnGo : UIButton!
    
    override func awakeFromNib() {
        self.delegate = self
        
        // Get all Events
        self.getAllEvents()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getLocation:", name: "getLocation", object: nil)
        
        // For Current Location
        if(self.userDefault.valueForKey("lat") != nil && self.userDefault.valueForKey("lon") != nil)
        {
            let camera = GMSCameraPosition.cameraWithLatitude(self.userDefault.valueForKey("lat")!.doubleValue, longitude: self.userDefault.valueForKey("lon")!.doubleValue, zoom: 5)
            self.camera = camera
        }
       
        self.btnGo.frame = CGRectMake(10, AppUtilities.getScreenHeight() - 150, 30, 30)
        self.btnGo.layer.cornerRadius = 2.0
        self.btnGo.layer.borderWidth = 1.0
        self.btnGo.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.bringSubviewToFront(self.btnGo)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "getLocation", object: nil)
    }
    
    /*========================================================
    * function Name: getLocation
    * function Purpose: check gps availability.
    * function Parameters: notification
    * function ReturnType: nil
    *=======================================================*/
    func getLocation(notification: NSNotification)
    {
        if(self.userDefault.valueForKey("lat") != nil && self.userDefault.valueForKey("lon") != nil)
        {
            let camera = GMSCameraPosition.cameraWithLatitude(self.userDefault.valueForKey("lat")!.doubleValue, longitude: self.userDefault.valueForKey("lon")!.doubleValue, zoom: 5)
            self.camera = camera
        }
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            
            if(status == CLAuthorizationStatus.Denied){
            } else {
            }
        }
        self.getAllEvents()

    }
    
    /*========================================================
    * function Name: btnGoClick
    * function Purpose: Make ZoomIn mapview
    * function Parameters: sender
    * function ReturnType: nil
    *=======================================================*/
    @IBAction func btnGoClick(sender : UIButton)
    {
        if(self.userDefault.valueForKey("lat") != nil && self.userDefault.valueForKey("lon") != nil)
        {
            let camera = GMSCameraPosition.cameraWithLatitude(self.userDefault.valueForKey("lat")!.doubleValue, longitude: self.userDefault.valueForKey("lon")!.doubleValue, zoom: 10)
            self.camera = camera
            
            self.currMarkerPos.position = (CLLocationCoordinate2DMake(self.userDefault.valueForKey("lat")!.doubleValue, self.userDefault.valueForKey("lon")!.doubleValue))
            //self.currMarkerPos.icon = UIImage(named:"Marker-4")
            self.currMarkerPos.icon = UIImage(named:"eventLocaton")
            
             //image = UIImage(named:"eventLocaton")!
            self.currMarkerPos.map = self
            self.currMarkerPos.title = "Current Location"
        }
    }
    
    // Map View delegate method
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView!
    {
        if(self.currMarkerPos == marker)
        {
            self.infoView = UIView(frame: CGRectMake(0, 0, 150, 30))
            if(self.cnt == 0)
            {
                self.infoView.backgroundColor = UIColor.whiteColor()
                lblTitle = UILabel(frame: CGRectMake(0, 0, 150, 30))
                lblTitle.text = "Current Location"
                lblTitle.textAlignment = NSTextAlignment.Center
                self.infoView.addSubview(lblTitle)
                cnt = 1
            } else {
                lblTitle.removeFromSuperview()
                cnt = 0
            }
            return self.infoView
        } else {
            let view : infoWindow = UINib(nibName: "MarkerInfoWindow", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! infoWindow
            
            let index: NSInteger = (marker.title as NSString).integerValue
            var eventObj : EventModal = EventModal()
            eventObj = self.eventMapArray.objectAtIndex(index) as! EventModal
            
            if let title = eventObj.title {
                view.lblTitle.text = title as String
            }
            if let addr = eventObj.address {
                view.lblAddr.text = addr as String
            }
            if let imagePath = eventObj.imagePath {
                view.imgEvent?.sd_setImageWithURL(NSURL(string: imagePath as String), placeholderImage: UIImage(named: "no-image"))
            }
            return view
        }
    }
   
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!)
    {
        if(self.currMarkerPos == marker) {
        } else {
            let index : NSInteger = (marker.title as NSString).integerValue
            self.infoDelegate.returnSelectedIndex!(index)
        }
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool
    {
        if(self.currMarkerPos == marker) {
            self.selectedMarker = marker
        } else {
            self.selectedMarker = marker
        }
        return true
    }

    /*========================================================
    * function Name: getAllEvents
    * function Purpose: Calling API to get all events
    * function Parameters: nil
    * function ReturnType: nil
    *=======================================================*/
    func getAllEvents()
    {
        self.clear()
        if(self.userDefault.valueForKey("catId") != nil)
        {
            self.startIndicator()
            let manager = AFHTTPRequestOperationManager()
            manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
            let cat_id = self.userDefault.valueForKey("catId") as! NSInteger
            let dis = 4000
            var stringURL : NSString = ""
            
            if(self.userDefault.valueForKey("lat") != nil && self.userDefault.valueForKey("lon") != nil)
            {
                
                
                if(cat_id == 0) {
                    stringURL = NSString(format: "%@", Near_Events)
                } else {
                    stringURL = NSString(format: Get_Events_By_CategoryID,cat_id)
                }
                
//                let lat = self.userDefault.valueForKey("lat") as! NSInteger
//               let lon = self.userDefault.valueForKey("lon") as! NSInteger
//               
//                if(cat_id == 0) {
//                     stringURL = NSString(format:Near_Events_with_gps,lat,lon,dis)
//                } else {
//                    stringURL = NSString(format: BASE_URL,lat,lon,dis,cat_id)
//                }
            } else {
                if(cat_id == 0) {
                    stringURL = NSString(format: "%@", Near_Events)
                } else {
                    stringURL = NSString(format: Get_Events_By_CategoryID,cat_id)
                }
            }
            
            if(stringURL.length > 0)
            {
                manager.GET(stringURL as String, parameters: nil, success: { (operation:AFHTTPRequestOperation? , responseObject:AnyObject?) -> Void in
                    if let response: AnyObject = responseObject
                    {
                        self.eventMapArray.removeAllObjects()
                        self.eventMapArray = NSMutableArray()
                        let arrayMarker:NSMutableArray = NSMutableArray()
                        for(var i : Int = 0; i < response.count; i++)
                        {
                            let eventObj : EventModal = EventModal()
                            let eventDic = response.objectAtIndex(i) as! NSMutableDictionary
                            
                            eventObj.address = eventDic.valueForKey("address") as? String ?? ""
                            eventObj.body1 = eventDic.valueForKey("body1") as? String ?? ""
                            eventObj.body2 = eventDic.valueForKey("body2") as? String ?? ""
                            eventObj.body5 = eventDic.valueForKey("body5") as? String ?? ""
                            eventObj.body6 = eventDic.valueForKey("body6") as? String ?? ""
                            eventObj.country = eventDic.valueForKey("country") as? String ?? ""
                            if let lati = eventDic.valueForKey("lat") as? String {
                                eventObj.lati = lati
                                if let longi = eventDic.valueForKey("lng") as? String {
                                    eventObj.longi = longi
                                    
                                    // Featured/Non Featured image
                                    var image = UIImage()
                                    if let key_feature = eventDic.valueForKey("number4") as? String {
                                        if key_feature == "1" {
                                            
                                            
                                            //image = UIImage(named:"Marker-5")!
                                            image = UIImage(named:"eventLocaton")!
                                            
                                        } else if key_feature == "0" {
                                            
                                            
                                           // image = UIImage(named:"Marker-6")!
                                            image = UIImage(named:"eventLocaton")!
                                            
                                            
                                        } else {
                                            
                                            image = UIImage(named:"eventLocaton")!
                                            //image = UIImage(named:"Marker-3")!
                                        }
                                    }
                                    
                                    let marker = GMSMarker()
                                    marker.position = CLLocationCoordinate2DMake((lati as NSString).doubleValue, (longi as NSString).doubleValue)
                                    marker.infoWindowAnchor = CGPointMake(0.5, 0.3)
                                    marker.title = NSString(format:"%d",i) as String
                                    marker.icon = image
                                    marker.map = self
                                    arrayMarker.addObject(marker)
                                   
                                }
                            }
                            if let mrkr = arrayMarker[0] as? GMSMarker{
                                var bounds_Map = GMSCoordinateBounds(coordinate: mrkr.position, coordinate: mrkr.position)
                                for mrkrtoAddPosition in arrayMarker {
                                  if let mrkr1 = mrkrtoAddPosition as? GMSMarker{
                                    
                                    bounds_Map = bounds_Map.includingCoordinate(mrkr1.position)
                                    
                                    }
                                }
                                self.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds_Map, withPadding: 50))

                            }
                            
                            eventObj.locality = eventDic.valueForKey("locality") as? String ?? ""
                            eventObj.name = eventDic.valueForKey("name") as? String ?? ""
                            eventObj.title = eventDic.valueForKey("title") as? String ?? ""
                            eventObj.type = eventDic.valueForKey("type") as? String ?? ""
                            eventObj.keyFeature = eventDic.valueForKey("number4") as? NSString ?? ""
                            if let start_Time = eventDic.valueForKey("number1") as? NSString
                            {
                                let dateTime = NSDate(timeIntervalSince1970: start_Time.doubleValue)
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle //Set time style
                                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle //Set date style
                                dateFormatter.timeZone = NSTimeZone()
                                let localDate = dateFormatter.stringFromDate(dateTime)
                                eventObj.startTime = localDate
                            }
                            if let end_Time = eventDic.valueForKey("number2") as? NSString
                            {
                                let dateTime = NSDate(timeIntervalSince1970: end_Time.doubleValue)
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle //Set time style
                                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle //Set date style
                                dateFormatter.timeZone = NSTimeZone()
                                let localDate = dateFormatter.stringFromDate(dateTime)
                                eventObj.endTime = localDate
                            }
                            if let img_Path = eventDic.valueForKey("img_path") as? String
                            {
                                let img = NSString(format: "http://%@", img_Path).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                                eventObj.imagePath = img
                            }
                            self.eventMapArray.addObject(eventObj)
                        }
                        
                        
                    } else {
                        NSLog("Error (getAllEvents): Response object found nil.")
                    }
                    self.stopIndicator()
                }, failure: { (operation, error) -> Void in
                    self.stopIndicator()
                    print("Failure (getAllEvents): ",error.description)
                })
            } else {
                self.stopIndicator()
            }
        }
    }
    
    /*========================================================
    * function Name: startIndicator() , stopIndicator()
    * function Purpose: start and stop indicator
    * function Parameters: nil
    * function ReturnType: nil
    *=======================================================*/
    func startIndicator() {
        self.stopIndicator()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        self.addSubview(self.activityIndicator)
        self.activityIndicator?.center = CGPointMake(AppUtilities.getScreenWidth() / 2, (AppUtilities.getScreenHeight() - 100) / 2)
        self.activityIndicator?.tintColor = UIColor(red: 239/255, green: 173/255, blue: 98/255, alpha: 1.0)
        self.activityIndicator?.color = UIColor(red: 239/255, green: 173/255, blue: 98/255, alpha: 1.0)
        self.activityIndicator?.startAnimating()
    }
    
    func stopIndicator() {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
}

// Main Class
class EventViewController: BaseViewController, SlidingContainerViewControllerDelegate, selectedIndexDelegate, CLLocationManagerDelegate, UITextViewDelegate
{
    var eventView : EventListView!
    var mapView : EventMap!
    var slidingContainerViewController:SlidingContainerViewController?
    var eventArray : NSMutableArray = NSMutableArray()
    var catObj : CategoryModal = CategoryModal()
    let locationManager = CLLocationManager()
    var latitude : NSNumber?
    var longtitude : NSNumber?
    var userDefault = NSUserDefaults.standardUserDefaults()
    var btnRight : UIButton = UIButton()
    var btnLeft : UIButton = UIButton()
    var termView : termWindow!
    var isAgree: String = ""
    var isAgreeChk : Bool = false
    var isHelpTutorialShown: NSString = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"getCategotyData:", name:"categorySelector", object: nil)
        
        self.navigationController?.interactivePopGestureRecognizer!.enabled = false
        
        let vc1 = viewControllerWithColorAndTitle(UIColor.clearColor(), title: "Event")
        let vc2 = viewControllerWithColorAndTitle(UIColor.clearColor(), title: "Map")
    
        //For removing view from superview.
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        self.slidingContainerViewController = SlidingContainerViewController (parent: self,contentViewControllers: [vc1, vc2],titles: ["Event", "Map"])
        self.slidingContainerViewController?.delegate = self
        view.addSubview(slidingContainerViewController!.view)
        
        slidingContainerViewController!.sliderView.appearance.outerPadding = 0
        slidingContainerViewController!.sliderView.appearance.innerPadding = 50
        slidingContainerViewController!.setCurrentViewControllerAtIndex(0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"getGpsLocation", name:"getGpsLocation", object: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let _: AnyObject = defaults.valueForKey("isAgree") {
            self.isAgree = defaults.valueForKey("isAgree") as! String
        }
        
        if (self.isAgree == "true") {
            self.setNavigationButton()
        } else {
            
            
            self.navigationItem.title = "Terms and Conditions"

            self.termView = UINib(nibName: "eventTermView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! termWindow
            self.termView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height);
          //  self.termView.btnChk.addTarget(self, action: Selector("btnChkClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
            self.termView.btnAgree.addTarget(self, action: Selector("btnAgreeClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
            let attributedString = NSMutableAttributedString(string: "By clicking on the Agree button below, I confirm that I have read and agreed to the EventHub Privacy Policy and Terms of Use.", attributes: [NSFontAttributeName:UIFont(name: "Gurmukhi MN",size: 17.0)!])
            attributedString.addAttribute(NSLinkAttributeName, value: "http://eventhubsacramento.com/index.php/registration/privacy", range: NSMakeRange(93, 14))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(int: 1), range: NSMakeRange(93, 14))
            attributedString.addAttribute(NSLinkAttributeName, value: "http://eventhubsacramento.com/index.php/registration/terms", range: NSMakeRange(111, 13))
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(int: 1), range: NSMakeRange(111, 13))
            self.termView.textview.attributedText = attributedString
            self.termView.textview.delegate = self
           // self.termView.btnChk.frame.origin.y  = self.termView.textview.frame.origin.y + 13
            self.view.addSubview(termView);
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // Check for category
        self.getGpsLocation()
    }
    
    func getCategotyData(notification: NSNotification)
    {
        let userInfo: NSDictionary = notification.userInfo!
        let catObj = userInfo.objectForKey("categoryObject") as! CategoryModal
        self.catObj = catObj
        self.setNavigationButton()
        var catId : NSInteger!
        if let _ = self.catObj.cat_Id {
            catId = self.catObj.cat_Id.integerValue
        } else {
            catId = 0
        }
        NSUserDefaults.standardUserDefaults().setValue(catId, forKey: "catId")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        print("Successfully received data from notification! %i", catObj.cat_Name)
        eventView.getAllEvents()
        mapView.getAllEvents()
    }
   
    /*========================================================
    * function Name: btnChkClicked
    * function Purpose: -
    * function Parameters: -
    * function ReturnType: nil
    *=======================================================*/
//    func  btnChkClicked(sender : UIButton) {
//        if(sender.selected) {
//            sender.selected = false
//            self.isAgreeChk = false
//        } else {
//           sender.selected = true
//           self.isAgreeChk = true
//        }
//    }
   
    /*========================================================
    * function Name: btnAgreeClicked
    * function Purpose: -
    * function Parameters: -
    * function ReturnType: nil
    *=======================================================*/
    func  btnAgreeClicked(sender : UIButton)
    {
//        if(self.isAgreeChk)
//        {
        
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject("true", forKey: "isAgree")
            defaults.synchronize()
            self.termView.removeFromSuperview()
            self.setNavigationButton()
            
            // Help Tutorial
            let userDefault = NSUserDefaults.standardUserDefaults()
            if let _: AnyObject = userDefault.valueForKey("isHelpTutorialShown") {
                self.isHelpTutorialShown = userDefault.valueForKey("isHelpTutorialShown") as! String
            }
            
            if (self.isHelpTutorialShown == "true") {
                
            } else {
                let helpTutorialVC = self.storyboard?.instantiateViewControllerWithIdentifier(HelpTutorialIdentifier) as! HelpTutorialViewController
                self.navigationController?.pushViewController(helpTutorialVC, animated: true)
            }
//        } else {
//             let alertController = UIAlertController(title: "EventHubSac", message: "Please check the checkbox", preferredStyle: UIAlertControllerStyle.Alert)
//            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
//            alertController.addAction(action)
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }
    }
    
    /*========================================================
    * function Name: setNavigationButton
    * function Purpose: Setting the left and right button in Navigation bar
    * function Parameters: nil
    * function ReturnType: nil
    *=======================================================*/
    func setNavigationButton()
    {
        // set right navigation button
        btnRight.frame = CGRectMake(0, 0, 30, 30)
        btnRight.addTarget(self, action: "didtapRightmenu:",forControlEvents: UIControlEvents.TouchUpInside)
        btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        btnRight.setBackgroundImage(UIImage(named: "moreOptions"), forState: UIControlState.Normal)
        let rightItem: UIBarButtonItem = UIBarButtonItem(customView: btnRight)
        self.navigationItem.rightBarButtonItem = rightItem
        
        // set left navigation button
        btnLeft.frame = CGRectMake(0, 0, 25, 25)
        btnLeft.addTarget(self, action: "didtapLeftmenu:",forControlEvents: UIControlEvents.TouchUpInside)
        btnLeft.setBackgroundImage(UIImage(named: "cat_icon"), forState: UIControlState.Normal)
        btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        let leftItem:UIBarButtonItem = UIBarButtonItem(customView: btnLeft)
        self.navigationItem.leftBarButtonItem = leftItem
        
        self.navigationController?.navigationBar.translucent = false
        if let title = catObj.cat_Name {
            self.navigationItem.title = title as String
        } else {
            self.navigationItem.title = "All events near me"
        }
    }
    
    // PRAGMA : TextView Delegate Method
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        UIApplication.sharedApplication().openURL(URL)
        return false
    }

    /*========================================================
    * function Name: getGpsLocation
    * function Purpose: check availability of GPS
    * function Parameters: -
    * function ReturnType: nil
    *=======================================================*/
    func getGpsLocation()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            let status = CLLocationManager.authorizationStatus()
            if(status == CLAuthorizationStatus.Denied)
            {
                self.userDefault.removeObjectForKey("lat")
                self.userDefault.removeObjectForKey("lon")
                self.userDefault.synchronize()
                if justOnce
                {
                    let alertController = UIAlertController(title: "EventHub", message: "Location access is currently disabled. Turn access on?", preferredStyle: .Alert)
                    let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                        var appSettings = NSURL()
                        if #available(iOS 8.0, *) {
                            appSettings = NSURL(string: UIApplicationOpenSettingsURLString)!
                        } else {
                            // Fallback on earlier versions
                        }
                        UIApplication.sharedApplication().openURL(appSettings)
                    })
                    alertController.addAction(yesAction)
                    let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        
                    })
                    alertController.addAction(noAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    justOnce = false
                }
            }
            else
            {
                if (CLLocationManager.locationServicesEnabled())
                {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    if ((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8)
                    {
                        if #available(iOS 8.0, *) {
                            locationManager.requestWhenInUseAuthorization()
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    locationManager.startUpdatingLocation()
                }
                else
                {
                    #if debug
                        println("Location services are not enabled");
                    #endif
                    
                }
                if(self.latitude != nil && self.longtitude != nil)
                {
                    self.userDefault.setDouble(self.latitude!.doubleValue, forKey: "lat")
                    self.userDefault.setDouble(self.longtitude!.doubleValue, forKey: "lon")
                    self.userDefault.synchronize()
                }
            }
        }

    }
    
    override func viewDidDisappear(animated: Bool) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("catId")
    }
    
    // PRAGMA: CLLocation manager delegate method
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        self.latitude = coord.latitude as NSNumber
        self.longtitude = coord.longitude as NSNumber
        if(self.latitude != nil && self.longtitude != nil)
        {
            self.userDefault.setDouble(self.latitude!.doubleValue, forKey: "lat")
            self.userDefault.setDouble(self.longtitude!.doubleValue, forKey: "lon")
            self.userDefault.synchronize()
            locationManager.stopUpdatingLocation()
        }
    }
    
    func didtapRightmenu(sender: UIButton)
        
        
    {
        var strSetting = String()
        if(self.userDefault.valueForKey("lat") == nil || self.userDefault.valueForKey("lon") == nil) {
            strSetting = "Enable Location Access"
        } else {
            strSetting = "Disable Location Access"
        }
        let settingAlert = UIAlertController(title: "Settings", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionGPS = UIAlertAction(title: strSetting, style: UIAlertActionStyle.Default) { (action) -> Void in
            var appSettings = NSURL()
            if #available(iOS 8.0, *) {
                appSettings = NSURL(string: UIApplicationOpenSettingsURLString)!
            } else {
                // Fallback on earlier versions
            }
            UIApplication.sharedApplication().openURL(appSettings)
        }
        settingAlert.addAction(actionGPS)
        let actionHelp = UIAlertAction(title: "Help", style: UIAlertActionStyle.Default) { (action) -> Void in
            let helpTutorialVC = self.storyboard?.instantiateViewControllerWithIdentifier(HelpTutorialIdentifier) as! HelpTutorialViewController
            self.navigationController?.pushViewController(helpTutorialVC, animated: true)
        }
        settingAlert.addAction(actionHelp)
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        settingAlert.addAction(actionCancel)
        
        self.presentViewController(settingAlert, animated: true, completion: nil)
    }
    
    func didtapLeftmenu(sender: UIButton)
        
        
    {
      
        
        let catVC = self.storyboard?.instantiateViewControllerWithIdentifier(RootViewIdentifier) as! RootViewController
        self.navigationController?.pushViewController(catVC, animated: true)
    }
    
    func viewControllerWithColorAndTitle (color: UIColor, title: String) -> UIViewController
    {
        let vc = UIViewController ()
        vc.view.backgroundColor = color
        var catId : NSInteger!
        if let _ = self.catObj.cat_Id
        {
            catId = self.catObj.cat_Id.integerValue
        }
        else
        {
            catId = 0
        }
        NSUserDefaults.standardUserDefaults().setValue(catId, forKey: "catId")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        if(title == "Event")
        {
            self.eventView = UINib(nibName: nibEventView, bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! EventListView
            self.eventView.backgroundColor = UIColor.clearColor()
            self.eventView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 101)
            self.eventView.delegate = self
            vc.view.addSubview(self.eventView)
        }
        else if(title == "Map")
        {
            self.mapView = UINib(nibName: nibEventMapView, bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! EventMap
            self.mapView.backgroundColor = UIColor.clearColor()
            self.mapView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)
            self.mapView.infoDelegate = self
            self.mapView.settings.compassButton = true
            vc.view.addSubview(self.mapView)
        }
        else
        {
            let label = UILabel (frame: vc.view.frame)
            label.textColor = UIColor.blackColor()
            label.textAlignment = .Center
            label.text = "No data found."
            label.sizeToFit()
            label.center = view.center
            vc.view.addSubview(label)
        }
        return vc
    }
    
    func returnSelectedItemIndex(index: Int)
    {
        var eventObj : EventModal = EventModal()
        if(self.eventView.searchArray.count > 0)
        {
            eventObj = self.eventView.searchArray.objectAtIndex(index) as! EventModal
            let eventInfoVC = self.storyboard?.instantiateViewControllerWithIdentifier(EventInfoIdentifier) as! EventInfoViewController
            eventInfoVC.eventObj = eventObj
            self.navigationController?.pushViewController(eventInfoVC, animated: true)
        }
        else if(self.eventView.eventArray.count > 0)
        {
            eventObj = self.eventView.eventArray.objectAtIndex(index) as! EventModal
            let eventInfoVC = self.storyboard?.instantiateViewControllerWithIdentifier(EventInfoIdentifier) as! EventInfoViewController
            eventInfoVC.eventObj = eventObj
            self.navigationController?.pushViewController(eventInfoVC, animated: true)
        }
    }
    func returnSelectedItemIndex(index: Int, section_number: Int) {
        
        var eventObj : EventModal = EventModal()
        if(self.eventView.searchArray.count > 0)
        {
            eventObj = self.eventView.searchArray.objectAtIndex(index) as! EventModal
            let eventInfoVC = self.storyboard?.instantiateViewControllerWithIdentifier(EventInfoIdentifier) as! EventInfoViewController
            eventInfoVC.eventObj = eventObj
            self.navigationController?.pushViewController(eventInfoVC, animated: true)
        }
        else
        {
            let sectionTitle = self.eventView.arrSections.objectAtIndex(section_number) as! String
            var arrData = NSArray()
            if(self.eventView.dictSectionValue.allKeys as NSArray!).containsObject(sectionTitle) {
                arrData = self.eventView.dictSectionValue.valueForKey(sectionTitle) as! NSArray
            }
            eventObj = arrData.objectAtIndex(index) as! EventModal
            if arrData.count > 0 {
                let eventInfoVC = self.storyboard?.instantiateViewControllerWithIdentifier(EventInfoIdentifier) as! EventInfoViewController
                eventInfoVC.eventObj = eventObj
                self.navigationController?.pushViewController(eventInfoVC, animated: true)
            }
        }
    }
    
    func returnSelectedIndex(index: Int) {
        var eventObj : EventModal = EventModal()
        if(self.mapView.eventMapArray.count > 0)
        {
            eventObj = self.mapView.eventMapArray.objectAtIndex(index) as! EventModal
            let eventInfoVC = self.storyboard?.instantiateViewControllerWithIdentifier(EventInfoIdentifier) as! EventInfoViewController
            eventInfoVC.eventObj = eventObj
            self.navigationController?.pushViewController(eventInfoVC, animated: true)
        }
    }
    
    // MARK: SlidingContainerViewControllerDelegate
    
    func slidingContainerViewControllerDidMoveToViewController(slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int) {
        self.eventView.txtSearch.resignFirstResponder()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

