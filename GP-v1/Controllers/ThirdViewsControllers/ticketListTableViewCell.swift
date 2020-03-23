//
//  ticketListTableViewCell.swift
//  GP-v1
//
//  Created by Thekra Faisal on 26/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit

class ticketListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ticketInfo: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    //    @IBOutlet weak var content: UIView!
    //
    //    override open var frame: CGRect {
    //        get {
    //            return super.frame
    //        }
    //        set (newFrame) {
    //            var frame =  newFrame
    //            frame.origin.y += 10
    //            frame.origin.x += 10
    //            frame.size.height -= 1
    //            frame.size.width -= 2 * 10
    //            super.frame = frame
    //        }
    //    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = 15
        layer.masksToBounds = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
