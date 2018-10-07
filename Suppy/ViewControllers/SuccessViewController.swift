//
//  SuccessViewController.swift
//  Suppy
//
//  Created by Daniel Montano on 06.10.18.
//  Copyright © 2018 Daniel Montano. All rights reserved.
//

import Foundation
import UIKit

class SuccessViewController: UIViewController {
    
    
    @IBOutlet weak var newTXButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newTXButton.layer.cornerRadius = 7.0
        self.newTXButton.layer.borderWidth = 1
        self.newTXButton.layer.borderColor = Constants.buttonBlue.cgColor
        self.newTXButton.backgroundColor = Constants.buttonBlue
        
        self.doneButton.layer.cornerRadius = 7.0
        self.doneButton.layer.borderWidth = 1
        self.doneButton.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
        
    }
    
    @IBAction func newTxButtonPressed(_ sender: UIButton) {
        
        let theVC = self.navigationController!.viewControllers[3]
        
        self.navigationController?.popToViewController(theVC, animated: true)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}
