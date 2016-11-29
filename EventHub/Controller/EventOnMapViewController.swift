//
//  EventOnMapViewController.swift
//  EventHub
//
//  Created by BIGSCAL on 10/31/15.
//  Copyright (c) 2015 BIGSCAL. All rights reserved.
//

import UIKit

enum TravelModes: Int {
    case driving
    case walking
    case bicycling
}

class EventOnMapViewController: BaseViewController, GMSMapViewDelegate
{
    var eventObj : EventModal = EventModal()
    var userDefault = NSUserDefaults.standardUserDefaults()
    var mapTasks = MapTasks()
    
    @IBOutlet var mapView : GMSMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarWithBackBtn()
        self.navigationController?.interactivePopGestureRecognizer!.enabled = false
        if let title = eventObj.title {
            if(title.length > 0) {
                self.navigationItem.title = title as String
            }
        }
        
        if(self.userDefault.valueForKey("lat") != nil && self.userDefault.valueForKey("lon") != nil)
        {
            if let _ = eventObj.lati
            {
                let source = (CLLocationCoordinate2DMake(self.userDefault.valueForKey("lat")!.doubleValue, self.userDefault.valueForKey("lon")!.doubleValue))

                let sourceString : NSString = NSString(format: "%f,%f",self.userDefault.valueForKey("lat")!.doubleValue,self.userDefault.valueForKey("lon")!.doubleValue)
                
                let destinstion = CLLocationCoordinate2DMake(eventObj.lati.doubleValue, eventObj.longi.doubleValue)
                let destString : NSString = NSString(format: "%@,%@", eventObj.lati, eventObj.longi)

                let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destinstion)
                self.mapView!.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 40))
                
                self.mapTasks.getDirections(sourceString as String, destination: destString as String, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
                    if success
                    {
                        let marker = GMSMarker()
                        marker.position = (CLLocationCoordinate2DMake(self.userDefault.valueForKey("lat")!.doubleValue, self.userDefault.valueForKey("lon")!.doubleValue))
                        //marker.icon = UIImage(named:"Marker-4")
                        //marker.icon = UIImage(named:"currentLocation")
                        marker.icon = UIImage(named:"currentLocation")
                        marker.map = self.mapView
                        marker.title = "Current Location"
                        
                        let route = self.mapTasks.overviewPolyline["points"] as! String
                        let path: GMSPath = GMSPath(fromEncodedPath: route)
                        let routePolyline = GMSPolyline(path: path)
                        routePolyline.map = self.mapView
                        routePolyline.strokeWidth = 4
                    }
                    else
                    {
                        // Camera position
                        let camera = GMSCameraPosition.cameraWithLatitude(self.eventObj.lati.doubleValue, longitude: self.eventObj.longi.doubleValue, zoom: 5)
                        self.mapView?.camera = camera
                    }
                })
            }
        } else {
            if let _ = eventObj.lati {
                // Camera position
                let camera = GMSCameraPosition.cameraWithLatitude(eventObj.lati.doubleValue, longitude: eventObj.longi.doubleValue, zoom: 5)
                self.mapView?.camera = camera
            }
        }
        
        if let lati = eventObj.lati
        {
            if let longi = eventObj.longi
            {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake((lati as NSString).doubleValue, (longi as NSString).doubleValue)
                //marker.icon = UIImage(named:"Marker-3")
                marker.icon = UIImage(named:"currentLocation")
                marker.map = self.mapView
                marker.title = eventObj.title as String
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
