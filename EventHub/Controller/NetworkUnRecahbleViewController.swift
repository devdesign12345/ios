//
//  NetworkUnRecahbleViewController.swift
//  CompareCity
//
//  Created by ved on 04/06/15.
//  Copyright (c) 2015 bigscal. All rights reserved.
//

import UIKit

class NetworkUnRechableViewController: BaseViewController {

    @IBOutlet var lblClose: UILabel!
    @IBOutlet var lblSetting: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblSetting.layer.cornerRadius = 8.0
        self.lblClose.layer.cornerRadius = 8.0
        
        let tapGestureSetting : UITapGestureRecognizer  = UITapGestureRecognizer(target: self, action: "moveToSetting:")
        lblSetting.addGestureRecognizer(tapGestureSetting)
        
        let tapGestureClose : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "closeTheApp:")
        lblClose.addGestureRecognizer(tapGestureClose)
    }

    /*========================================================
    * function Name: moveToSetting
    * function Purpose: move to general setting
    * function Parameters: gesture
    * function ReturnType: nil
    *=======================================================*/
    func moveToSetting(gesture: UITapGestureRecognizer) {
        self.view.removeFromSuperview()
        var appSettings = NSURL()
        if #available(iOS 8.0, *) {
            appSettings = NSURL(string: UIApplicationOpenSettingsURLString)!
        } else {
            // Fallback on earlier versions
        }
        UIApplication.sharedApplication().openURL(appSettings)
    }
    
    /*========================================================
    * function Name: closeTheApp
    * function Purpose: To close the app
    * function Parameters: gesture
    * function ReturnType: nil
    *=======================================================*/
    func closeTheApp(gesture: UITapGestureRecognizer) {
        exit(0)
    }
    
    /*========================================================
    * function Name: updateInterfaceWithReachability
    * function Purpose: Check the network rechability.
    * function Parameters: reachability
    * function ReturnType: nil
    *=======================================================*/
    override func updateInterfaceWithReachability(let reachability : Reachability)
    {
        let netStatus : NetworkStatus = reachability.currentReachabilityStatus()
        switch (netStatus.rawValue)
        {
        case NotReachable.rawValue: break
        case ReachableViaWWAN.rawValue:
            self.view.removeFromSuperview()
        case ReachableViaWiFi.rawValue:
            self.view.removeFromSuperview()
        default: break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
