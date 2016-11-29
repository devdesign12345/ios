//
//  HelpTutorialViewController.swift
//  EventHub
//
//  Created by Bigscal on 5/4/16.
//  Copyright © 2016 BIGSCAL. All rights reserved.
//

import UIKit

class HelpTutorialViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var infoView: UIView!
    @IBOutlet var lblHeading: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var btnSkip: UIButton!
    
    @IBOutlet weak var txtDEscription: UITextView!
    @IBOutlet weak var btnShowMe: UIButton!
    var minIndex: Int = 0
    var maxindex: Int = 5
    var prevIndex: Int = 0
    
    var arrImages: NSMutableArray = NSMutableArray()
    var arrHeadings: NSMutableArray = NSMutableArray()
    var arrDesc: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        lblDescription.hidden = true
        self.arrImages = ["help1","1","2","event_location","4","5"]
        self.arrHeadings = ["Welcome to EventHub Sacramento","Event Categories","Highlighted Events","Events Location","Event Info","Get Tickets and Rides"]
        self.arrDesc = ["Explore our new app with all the best Sacramento events. Come back here anytime to check out features you may have missed.","Our easy way to explore events tailored to your taste.","Check out our featured events and events that are happening soon- highlighted for quick scanning.","Easily find events that are nearby, featured, and happening soon- color coded on the map","Dig into a specific event to find out more details.","Purchase tickets seamlessly, and get a ride to the event using Uber."]
        
        // Vertical page control
        self.pageControl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        let y : CGFloat = (self.imageView.frame.size.height - 320)/2
        self.pageControl.frame = CGRectMake(self.view.frame.size.width - self.pageControl.frame.size.width, y, self.pageControl.frame.size.width, 320)
        self.pageControl.addTarget(self, action: "pageTurn:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        lblDescription.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func btnShowMe(sender: AnyObject) {
        
        if self.minIndex == 5{
            
            self.minIndex = -1
            self.prevIndex = -1
        }
        
        self.prevIndex = self.minIndex
        self.minIndex = self.minIndex + 1
        if(self.minIndex > self.maxindex) {
            self.minIndex = self.maxindex
        } else {
            self.changeImageAndDescription()
        }
        
        
        
    }
    /*========================================================
    * function Name: swipeUP
    * function Purpose: for swipe the image up
    * function Parameters: sender
    * function ReturnType: nil
    *=======================================================*/
    @IBAction func swipeUP(sender : UISwipeGestureRecognizer) {
        
        
        self.prevIndex = self.minIndex
        self.minIndex = self.minIndex + 1
        if(self.minIndex > self.maxindex) {
            self.minIndex = self.maxindex
        } else {
            
            self.changeImageAndDescription()
        }
        
       
        
    }
    
    /*========================================================
    * function Name: swipeDown
    * function Purpose: to swipe down the image
    * function Parameters: sender
    * function ReturnType: nil
    *=======================================================*/
    @IBAction func swipeDown(sender : UISwipeGestureRecognizer) {
        self.prevIndex = self.minIndex
        self.minIndex = self.minIndex - 1
        if(self.minIndex < 0) {
            self.minIndex = 0
        } else {
            self.changeImageAndDescription()
        }
    }
    
    /*========================================================
    * function Name: pageTurn
    * function Purpose: when page control index change
    * function Parameters: page
    * function ReturnType: nil
    *=======================================================*/
    func pageTurn(page: UIPageControl) {
        
        let c = page.currentPage
        self.prevIndex = self.minIndex
        self.minIndex = c
        self.changeImageAndDescription()
    }
    
    /*========================================================
    * function Name: changeImageAndDescription
    * function Purpose: change image and description according to current page index
    * function Parameters: nil
    * function ReturnType: nil
    *=======================================================*/
    func changeImageAndDescription()
    {
        if prevIndex > self.minIndex {
            
            self.imageView.image = UIImage(named: self.arrImages.objectAtIndex(self.minIndex) as! String)
            AppUtilities.viewSlideInFromTopToBottom(self.imageView)
        } else {
            self.imageView.image = UIImage(named: self.arrImages.objectAtIndex(self.minIndex) as! String)
            AppUtilities.viewSlideInFromBottomToTop(self.imageView)
        }
        
        self.lblHeading.text = NSString(format: "%@", String(self.arrHeadings.objectAtIndex(self.minIndex))) as String
        self.txtDEscription.text = NSString(format: "%@", String(self.arrDesc.objectAtIndex(self.minIndex))) as String
        self.pageControl.currentPage = self.minIndex
    }
    
    /*========================================================
    * function Name: btnSkipClick
    * function Purpose: for skip the help tutorial
    * function Parameters: sender
    * function ReturnType: nil
    *=======================================================*/
    @IBAction func btnSkipClick(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
