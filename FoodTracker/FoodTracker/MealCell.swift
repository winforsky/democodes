//
//  MealCell.swift
//  FoodTracker
//
//  Created by zsp on 2019/8/21.
//  Copyright © 2019 woop. All rights reserved.
//

import UIKit

class MealCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
