//
//  EventViewCell.swift
//  EventHub
//
//  Created by Bigscal on 05/10/15.
//  Copyright (c) 2015 Bigscal. All rights reserved.
//

import UIKit

class EventViewCell: UITableViewCell {

    @IBOutlet var containerView : UIView!
    @IBOutlet var eventImg : UIImageView!
    @IBOutlet var lblEventTitle : UILabel!
    @IBOutlet var lblEventAddr : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
