//
//  LogCell.swift
//  BoilerFlex
//
//  Created by Tobi Ola on 3/2/19.
//  Copyright © 2019 Jeremy Chang. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var calorieCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
