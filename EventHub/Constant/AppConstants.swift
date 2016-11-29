//
//  Appconstants.swift
//
//  Created by Bigscal 
//  Copyright (c) 2015 Bigscal. All rights reserved.
//

import UIKit
import Foundation

//Screen Resolution
let screenSize: CGRect = UIScreen.mainScreen().bounds
let IPHONE_4S_SIZE : CGFloat = 480
let IPHONE_5S_SIZE : CGFloat = 568
let IPHONE_6_SIZE : CGFloat = 667

///http://eventhubsacramento.com/index.php?module=eventhub&func=get_events&lat=%d&lng=%d&dis=%d&catid=%d
let BASE_URL = "http://eventhubsacramento.com/ws.php?module=eventhub&func=eventhub&type=native&lat=%d&lng=%d&dis=%d&catid=%d"
let Get_Events_By_CategoryID = "http://eventhubsacramento.com/ws.php?module=eventhub&func=get_events&type=native&catid=%d"
///http://www.eventhubsacramento.com/index.php?module=eventhub&func=get_events
let Near_Events = "http://eventhubsacramento.com/ws.php?module=eventhub&func=get_events&type=native"
///http://www.eventhubsacramento.com/index.php?module=eventhub&func=get_events&lat=%d&lng=%d&dis=%d
let Near_Events_with_gps = "http://www.eventhubsacramento.com/ws.php?module=eventhub&func=get_events&type=native&lat=%d&lng=%d&dis=%d"
///http://www.eventhubsacramento.com/index.php?module=eventhub&func=get_categories
let Get_All_Category = "http://www.eventhubsacramento.com/ws.php?module=eventhub&func=get_categories&type=native"

//Google Key
let GOOGLE_MAP_KEY = "AIzaSyBgOn_ZGEOsN31RguMRh7LWVtJ48R-Ihec" //"AIzaSyCM8IMU8Pnd3i98gdD2KGBcM4laxqkh29w"

//ViewController Identifier
let EventListIdentifier = "EventListVC"
let NetwokrUnAvailabelController = "NetworkUnRechableViewController"
let ViewControllerIdentifier = "ViewController"
let EventInfoIdentifier = "EventInfoVC"
let CategoryMenuIdentifier = "CategoryMenuVC"
let EventOnMapIdentifier = "EventOnMapVC"
let RootViewIdentifier = "RootViewIdentifier"
let HelpTutorialIdentifier = "HelpTutorialViewController"

//nib identifier
let nibEventViewCell = "EventListCell"
let EventViewCellIdentifier = "EventCell"
let nibEventView = "EventListView"
let nibEventMapView = "EventMapView"

//App theme constant
let APP_TITLE = "EventHub"
let IMAGE_BACK = "back_nav"
let IMAGE_BACK_WHITE = "back_white_icon"
let IMAGE_NAV = "Navigation"

//Cell Theme
let CELL_VIEW_RADIUS : CGFloat = 4.0
let CELL_VIEW_SHADOW_COLOR : CGColor = UIColor.grayColor().CGColor


