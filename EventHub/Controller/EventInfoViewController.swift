//
//  EventInfoViewController.swift
//  EventHub
//
//  Created by BIGSCAL on 10/6/15.
//  Copyright (c) 2015 BIGSCAL. All rights reserved.
//

import UIKit
import UberRides

class EventInfoViewController: BaseViewController, UITextViewDelegate, UIWebViewDelegate
{
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblAddr : UITextView!
    @IBOutlet var lblCountry : UILabel!
    @IBOutlet var lblLocality : UILabel!
    @IBOutlet var lblType : UILabel!
    @IBOutlet var lblDescription : UITextView!
    @IBOutlet var descView : UIView!
    @IBOutlet var imgEvent : UIImageView!
    @IBOutlet var webDescView : UIWebView!
    @IBOutlet var btnUber : RequestButton!
    @IBOutlet var btnBuyTicket : UIButton!
    
    var btnRight : UIButton = UIButton()
    var userDefault = NSUserDefaults.standardUserDefaults()
    var eventObj : EventModal = EventModal()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setNavigationBarWithBackBtn()
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 370)
        self.navigationController?.interactivePopGestureRecognizer!.enabled = false
        
        btnRight.frame = CGRectMake(0, 0, 30, 30)
        btnRight.setBackgroundImage(UIImage(named: "Map-icon"), forState: UIControlState.Normal)
        btnRight.addTarget(self, action: "didtapRightmenu:",forControlEvents: UIControlEvents.TouchUpInside)
        btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        let rightItem:UIBarButtonItem = UIBarButtonItem(customView: btnRight)
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.navigationItem.title = "Event Hub"

        if let title = eventObj.title {
            self.lblTitle.text = title as String
        }
        
        if let imagePath = eventObj.imagePath {
            self.imgEvent?.sd_setImageWithURL(NSURL(string: imagePath as String), placeholderImage: UIImage(named: "no-image"))
            self.imgEvent.clipsToBounds = true
            self.imgEvent.contentMode = UIViewContentMode.ScaleAspectFit
        }
        
        if let addr = eventObj.address {
            if(addr.length > 0) {
                self.lblAddr.text = addr as String
            } else {
                self.lblAddr.text = "None"
            }
        }
        
        if let country = eventObj.country {
            if(country.length > 0) {
                
                
                self.lblCountry.text = country as? String
                
                
                
            } else {
                self.lblCountry.text = "None"
            }
        }
       
        if let descr = eventObj.body1 as NSString! {
            if(descr.length > 0) {
                var description : NSString = ""
                if let body2 = eventObj.body2 as NSString!
                {
                    if let body5 = eventObj.body5 as NSString! {
                        description = (descr as String) + (body2 as String) + (body5 as String)
                    } else {
                        description = (descr as String) + (body2 as String)
                    }
                } else {
                    description = (descr as String)
                }
                
                //Load Description in webview
                self.lblDescription.text = description as String
                self.webDescView.loadHTMLString(NSString(format: "<html> <body style='color:#AAAAAA'> %@ </body></html>", description.stringByReplacingOccurrencesOfString("\n", withString: "<br/>")) as String, baseURL: nil)
                self.lblDescription.sizeToFit()
            } else {
                self.lblDescription.text = "None"
            }
        }
        
//        if let locality = eventObj.locality {
//            if(locality.length > 0) {
//                //self.lblLocality.text = locality as? String
//            } else {
//                //self.lblLocality.text = "None"
//            }
//        }
        
        if let type = eventObj.type {
            if(type.length > 0) {
               // self.lblType.text = type as? String
            } else {
               // self.lblType.text = "None"
            }
        }
        
        if let startTime = eventObj.startTime {
            
            
            
            self.lblCountry.text = startTime as String
        }
//        
//        if let endTime = eventObj.endTime {
//            self.lblLocality.text = endTime as String
//        }
        
        if(eventObj.body6.length > 0) {
        } else {
            self.btnBuyTicket.hidden = true
            self.btnUber.frame.origin.x = self.descView.frame.origin.x
            self.btnUber.frame.size.width = self.descView.frame.size.width
        }
        
        if(self.userDefault.valueForKey("lat") == nil || self.userDefault.valueForKey("lon") == nil) {
        } else {
            
            btnUber.setPickupLocation(latitude: (self.userDefault.valueForKey("lat")?.doubleValue)!, longitude: (self.userDefault.valueForKey("lon")?.doubleValue)!, nickname: "Pickup Location")
        
            if let lat = eventObj.lati {
                if let longi = eventObj.longi {
                    
                    btnUber.setDropoffLocation(latitude: lat.doubleValue, longitude: longi.doubleValue, nickname: eventObj.address as String, address: eventObj.address as String)
                }
            }
        }
    }

    // PRAGMA :- UIWebView Delegate method
    func webViewDidFinishLoad(webView: UIWebView)
    {
        self.webDescView.frame.size.height = self.webDescView.scrollView.contentSize.height
        self.descView.frame.size.height = self.webDescView.frame.size.height + 40
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.webDescView.frame.size.height + 260)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        if(navigationType == UIWebViewNavigationType.LinkClicked){
            UIApplication.sharedApplication().openURL(request.URL as NSURL!)
            return false;
        }
        return true
    }
    
    // Open ticket url in browser.
    @IBAction func btnBuyTicketClick(sender : UIButton)
    {
        let ticketUrl = NSURL(string: NSString(format: "%@", eventObj.body6) as String)
        UIApplication.sharedApplication().openURL(ticketUrl!)
    }
    
    func didtapRightmenu(sender: UIButton)
    {
      
        
        
        let mapEvent = self.storyboard?.instantiateViewControllerWithIdentifier(EventOnMapIdentifier) as! EventOnMapViewController
        mapEvent.eventObj = self.eventObj
        self.navigationController?.pushViewController(mapEvent, animated: true)
    }
       
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        return true
    }
    
    @IBAction func btnUberClick(sender : UIButton)
    {
        if(self.userDefault.valueForKey("lat") == nil || self.userDefault.valueForKey("lon") == nil)
        {
        }
        else
        {
            let uberUrl = NSURL(string: "uber://")
            if(UIApplication.sharedApplication().canOpenURL(uberUrl!))
            {
            }
            else
            {
                let uberUrlWeb = NSURL(string: "http://m.uber.com/sign-up?client_id=svVziQvF29aQirfqr4vDh_HKZ73cYRls")
                UIApplication.sharedApplication().openURL(uberUrlWeb!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
