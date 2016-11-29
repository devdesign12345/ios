//
//  BaseViewController.swift
//  CompareCity
//
//  Created by ved on 04/06/15.
//  Copyright (c) 2015 bigscal. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController , UIGestureRecognizerDelegate {
    
    var internetReachability = Reachability()
    var activityIndicator : UIActivityIndicatorView!
    var actInd : UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reachabilityChanged:"), name: kReachabilityChangedNotification, object: nil)
        self.internetReachability = Reachability.reachabilityForInternetConnection()
        self.internetReachability.startNotifier()
        self.updateInterfaceWithReachability(self.internetReachability)
    }
    
    /*========================================================
    * function Name: updateInterfaceWithReachability
    * function Purpose: check network connection.
    * function Parameters: Reachability
    * function ReturnType: nil
    *=======================================================*/
    func updateInterfaceWithReachability(reachability : Reachability)
    {
        let netStatus : NetworkStatus = reachability.currentReachabilityStatus()
        switch (netStatus.rawValue) {
        case NotReachable.rawValue:
            let checkConn = self.storyboard?.instantiateViewControllerWithIdentifier(NetwokrUnAvailabelController) as! NetworkUnRechableViewController
            self.view.addSubview(checkConn.view)
            self.addChildViewController(checkConn)
            view.endEditing(true)
            self.view.alpha = 1
            self.navigationController?.navigationBar.userInteractionEnabled = false
            
            if let recognizers = view.gestureRecognizers {
                for recognizer in recognizers {
                    (recognizer ).enabled = false
                }
            }
            
        case ReachableViaWWAN.rawValue:
            self.navigationController?.navigationBar.userInteractionEnabled = true
            self.view.userInteractionEnabled = true
            if let recognizers = view.gestureRecognizers {
                for recognizer in recognizers {
                    (recognizer ).enabled = true
                }
            }
            
        case ReachableViaWiFi.rawValue:
            self.navigationController?.navigationBar.userInteractionEnabled = true
            self.view.userInteractionEnabled = true
            if let recognizers = view.gestureRecognizers {
                for recognizer in recognizers {
                    (recognizer ).enabled = true
                }
            }
            
        default :
            self.navigationController?.navigationBar.userInteractionEnabled = true
            self.view.userInteractionEnabled = true
            if let recognizers = view.gestureRecognizers {
                for recognizer in recognizers {
                    (recognizer ).enabled = true
                }
            }
        }
    }
    
    func reachabilityChanged(sender : NSNotification!) {
        let curReach : Reachability = sender.object as! Reachability
        self.updateInterfaceWithReachability(curReach)
    }
   
    /*========================================================
    * function Name: setNavigationBarWithBackBtn
    * function Purpose: to set navigation bar with back button
    * function Parameters: nil
    * function ReturnType: nil
    *=======================================================*/
    func setNavigationBarWithBackBtn() {
        let btnLeft:UIButton! = UIButton()
        btnLeft!.frame = CGRectMake(0, 0, 10, 15)
        let addImage:UIImage = UIImage(named: "Back")!
        btnLeft!.setBackgroundImage(addImage, forState: UIControlState.Normal)
        btnLeft!.addTarget(self, action: "handleBack:",forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem:UIBarButtonItem = UIBarButtonItem(customView: btnLeft!)
        self.navigationItem.leftBarButtonItem = leftItem
    }

    /*========================================================
    * function Name: handleBack
    * function Purpose: for pop the view
    * function Parameters: sender
    * function ReturnType: nil
    *=======================================================*/
    func handleBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*========================================================
    * function Name: startIndicator() , stopIndicator()
    * function Purpose: Start & stop indicator
    * function Parameters: nil
    * function ReturnType: nil
    *=======================================================*/
    func startIndicator() {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.view.addSubview(self.activityIndicator!)
        self.activityIndicator?.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height - 49) / 2)
        self.activityIndicator?.tintColor = UIColor(red: 239/255, green: 173/255, blue: 98/255, alpha: 1.0)
        self.activityIndicator?.color = UIColor(red: 239/255, green: 173/255, blue: 98/255, alpha: 1.0)
        self.activityIndicator?.startAnimating()
    }
    
    func stopIndicator() {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }

    /*========================================================
    * function Name: startIndicator , stopIndicatorView
    * function Purpose: startIndicator & Stop indicator
    * function Parameters: nil
    * function ReturnType: nil
    *=======================================================*/
    func startIndicator(uiView:UIView) {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let container: UIView = UIView()
        container.frame = CGRectMake(0, 0, uiView.bounds.size.width, uiView.bounds.size.height)
        container.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(uiView.bounds.size.width / 2 - 75, (uiView.bounds.size.height - 49 ) / 2 - 50, 150, 60)
        
        loadingView.backgroundColor = UIColor.blackColor()
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        self.actInd = UIActivityIndicatorView()
        self.actInd?.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        self.actInd?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.actInd?.bounds = CGRectMake(-5,-10, loadingView.frame.size.width / 2, loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd!)
        
        let label = UILabel(frame: CGRectMake(48, 21,120,20))
        label.text = "Please Wait"
        label.textColor = UIColor.whiteColor()
        loadingView.addSubview(label)
        
        container.addSubview(loadingView)
        uiView.addSubview(container)
        self.actInd!.startAnimating()
    }
    
    func stopIndicatorView() {
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        self.actInd!.stopAnimating()
        ((self.actInd!.superview as UIView!).superview as UIView!).removeFromSuperview()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
    }
}
