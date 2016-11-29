
//
//  AppDelegate.swift
//  EventHub
//
//  Created by BIGSCAL on 10/5/15.
//  Copyright (c) 2015 BIGSCAL. All rights reserved.
//

import UIKit
import UberRides

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    var latitude : NSNumber?
    var longtitude : NSNumber?
    var userDefault = NSUserDefaults.standardUserDefaults()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        RidesClient.sharedInstance.configureClientID("svVziQvF29aQirfqr4vDh_HKZ73cYRls")
        
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(GOOGLE_MAP_KEY)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    
       
        if (CLLocationManager.locationServicesEnabled())
        {
            let status = CLLocationManager.authorizationStatus()
            
            if(status == CLAuthorizationStatus.Denied)
            {
                print("status of location is denied")
                if(self.latitude != nil && self.longtitude != nil)
                {
                    self.userDefault.removeObjectForKey("lat")
                    self.userDefault.removeObjectForKey("lon")
                    self.userDefault.synchronize()
                }
            }
            else
            {
            print("status of location is allow")
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
               print("current lat long val:-")
                print(locationManager.location?.coordinate.latitude)
                print(locationManager.location?.coordinate.longitude)
             if(locationManager.location?.coordinate.latitude != nil && locationManager.location?.coordinate.longitude != nil)
             {
                self.userDefault.setDouble((locationManager.location?.coordinate.latitude)!, forKey: "lat")
                self.userDefault.setDouble((locationManager.location?.coordinate.longitude)!, forKey: "lon")
                self.userDefault.synchronize()
            }
                
            locationManager.startUpdatingLocation()
            }
        } else {
           
                print("Location services are not enabled");
           
        }
//        if(self.latitude != nil && self.longtitude != nil)
//        {
//            print("user default is available")
//            self.userDefault.setDouble(self.latitude!.doubleValue, forKey: "lat")
//            self.userDefault.setDouble(self.longtitude!.doubleValue, forKey: "lon")
//            self.userDefault.synchronize()
//        }
//        else
//        {
//            print("user default is not available")
//            self.userDefault.removeObjectForKey("lat")
//            self.userDefault.removeObjectForKey("lon")
//            
////            print("after removing object:-")
////            print(self.userDefault.valueForKey("lat"))
////            print(self.userDefault.valueForKey("lon"))
//        }
        return true
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError!)
    {
        print("did fail with error")
        self.userDefault.removeObjectForKey("lat")
        self.userDefault.removeObjectForKey("lon")
         self.userDefault.synchronize()
        
        locationManager.stopUpdatingLocation()
        if(error != nil)
        {
            print(error, terminator: "")
        }
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
        
            NSNotificationCenter.defaultCenter().postNotificationName("getLocation", object: nil)
            locationManager.stopUpdatingLocation()
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NSNotificationCenter.defaultCenter().postNotificationName("getLocation", object: nil)
         NSNotificationCenter.defaultCenter().postNotificationName("getGpsLocation", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("getListOfEvent", object: nil)
        
    }

    func applicationWillTerminate(application: UIApplication) {
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

  //called when the applaction is about to terminal.save data f appropriate. see also appication
}

