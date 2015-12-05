//
//  MasterTableViewCell.swift
//  HelloZoo
//
//  Created by Laibit on 2015/11/24.
//  Copyright © 2015年 Laibit. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var animalLbl : UILabel!
    @IBOutlet weak var detailLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
