//
//  MealTableViewCell.swift
//  rankStars
//
//  Created by 马宝森 on 2019/4/20.
//  Copyright © 2019 马宝森. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: ratingControl!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var neededTime: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
