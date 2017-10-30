//
//  CountryCodeCell.swift
//  Seken
//
//  Created by Seken InfoSys on 17/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import UIKit

class CountryCodeCell: UITableViewCell {
    
    @IBOutlet weak var imgCountry: UIImageView!
    
    @IBOutlet weak var lblCountryName: UILabel!
    
    @IBOutlet weak var lblDialCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
