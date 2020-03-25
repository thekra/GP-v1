//
//  TicketsListEmpTableViewCell.swift
//  GP-v1
//
//  Created by Thekra Faisal on 29/07/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit

class TicketsListEmpTableViewCell: UITableViewCell {

    @IBOutlet weak var ticketImg: UIImageView!
    @IBOutlet weak var ticketStatus: UILabel!
    @IBOutlet weak var ticketDate: UILabel!
    @IBOutlet weak var ticketInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
