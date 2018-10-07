//
//  TopBar.swift
//  Suppy
//
//  Created by Daniel Montano on 06.10.18.
//  Copyright © 2018 Daniel Montano. All rights reserved.
//

import Foundation
import UIKit


protocol TopBarDelegate {
    func touched()
}

class TopBar: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var delegate: TopBarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("Hey")
    }
    
}
