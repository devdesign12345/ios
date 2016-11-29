//
//  EventModal.swift
//  EventHub
//
//  Created by BIGSCAL on 10/6/15.
//  Copyright (c) 2015 BIGSCAL. All rights reserved.
//

import UIKit

class EventModal: NSObject {
    
    var id: NSString!
    var category_id: NSString!
    var category_name: NSString!
    
    var name : NSString! //event name ID
    var title : NSString! //event title
    
    var body1 : NSString! //detail description
    var body2 : NSString! //ticket details
    var body3 : NSString! //transit details
    var body5 : NSString! //event venue
    var body6 : NSString! //purchase URL
    
    var startTime : NSString! //number1
    var endTime : NSString! //number2
    var keyFeature : NSString! //number4
    
    var imagePath : NSString!
    var address : NSString!
    var locality : NSString!
    var country : NSString!
    var lati : NSString!
    var longi : NSString!
    var type : NSString!
    
    var startDate : NSDate!
}
