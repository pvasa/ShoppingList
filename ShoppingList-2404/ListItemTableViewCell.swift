//
//  ListItemTableViewCell.swift
//  ShoppingList-2404
//
//  Created by Ryan on 2017-02-21. - 300872404
//  Copyright © 2017 Centennial College. All rights reserved.
//

import UIKit

class ListItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel! // Name of item - Label
    @IBOutlet weak var quantity: UILabel! // Quantity of item - label
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
