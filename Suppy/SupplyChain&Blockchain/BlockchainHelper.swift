//
//  Helpers.swift
//  Suppy
//
//  Created by Daniel Montano on 06.10.18.
//  Copyright © 2018 Daniel Montano. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import SwiftyJSON


class SupplyChainItem {
    
    var date: Date
    var prev_tx_ids: [String]
    var latitude: Double
    var longitude: Double
    var supplier_id: String
    var supplier_type: SupplierType
    var product_type: ProductType
    var product_title: String
    var co2: Double
    
    init(date: Date, prev_tx_ids: [String], latitude: Double, longitude: Double, supplier_id: String, supplier_type: SupplierType, product_type: ProductType, product_title: String, co2: Double){
        
        self.date = date
        self.prev_tx_ids = prev_tx_ids
        self.latitude = latitude
        self.longitude = longitude
        self.supplier_id = supplier_id
        self.supplier_type = supplier_type
        self.product_type = product_type
        self.product_title = product_title
        self.co2 = co2
        
    }

    func getParameters() -> Parameters{
        
        let parameters: Parameters = [
//            "date": self.date,
//            "prev_tx_ids": self.prev_tx_ids,
            "location": [
                "lat": self.latitude,
                "lng": self.longitude
            ],
            "supplier_id": self.supplier_id,
//            "supplier_type": self.supplier_type,
            "product_data": [
//                "type": self.product_type,
                "title": self.product_title
            ],
            "co2": self.co2
        ]
        
        
        return parameters
    }
    
}

class BlockchainManager{
    
    static let sharedInstance = BlockchainManager()
    
    private init(){}
    
    var blockchainURL: String?
    var apikey: String?
    
    func createAndSendSupplyChainItem (supplyChainItem: SupplyChainItem) {
        
        guard let apikey = self.apikey else {
            return
        }
        
        guard let blockchainURL = self.blockchainURL else {
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "apikey": apikey
        ]
        
        Alamofire.request(blockchainURL, method: .post, parameters: supplyChainItem.getParameters(), encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
