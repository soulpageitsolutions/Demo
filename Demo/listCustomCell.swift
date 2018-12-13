//
//  listCustomCell.swift
//  Demo
//
//  Created by Soulpage Machintosh 1 on 27/11/18.
//  Copyright © 2018 Soulpage Machintosh 1. All rights reserved.
//

import UIKit

class listCustomCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBOutlet weak var sampleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sampleImageView.setRounded()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

