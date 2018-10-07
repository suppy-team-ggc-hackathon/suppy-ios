//
//  CO2Cell.swift
//  Suppy
//
//  Created by Daniel Montano on 06.10.18.
//  Copyright © 2018 Daniel Montano. All rights reserved.
//

import Foundation
import UIKit

class CO2Cell: UITableViewCell {
    
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var polutionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.separatorInset = .zero
        bottomBar.layer.borderWidth = 1.0
        bottomBar.layer.borderColor = Constants.greyDarker.cgColor
    }
    
}
