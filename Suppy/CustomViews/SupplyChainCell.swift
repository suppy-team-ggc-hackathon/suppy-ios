//
//  SupplyChainCell.swift
//  Suppy
//
//  Created by Daniel Montano on 06.10.18.
//  Copyright © 2018 Daniel Montano. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SupplyChainCell: UITableViewCell {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.separatorInset = .zero
    }
    
    
    func loadImage(url:String){
        let newUrl = url.replacingOccurrences(of: "\\", with: "")
        
        let url = URL(string: newUrl)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        self.productImage.image = UIImage(data: data!)
        
        
//        Alamofire.download(newUrl).responseData { response in
//
//            print("image response \(response)")
//            if let data = response.result.value {
//                let image = UIImage(data: data)
//                self.productImage.image = image
//            }
//        }
    }
}
