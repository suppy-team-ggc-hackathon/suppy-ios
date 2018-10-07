//
//  SupplyChainItem.swift
//  Suppy
//
//  Created by Daniel Montano on 06.10.18.
//  Copyright © 2018 Daniel Montano. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SupplyChainItem {
    
    var date: String
    var prev_tx_ids: [String]
    var latitude: Double
    var longitude: Double
    var supplier_id: String
    var supplier_type: SupplierType
    var product_type: String
    var product_title: String
    var co2: Double
    var sapKey: String
    var img: String
    
    init(date: String, prev_tx_ids: [String], latitude: Double, longitude: Double, supplier_id: String, supplier_type: SupplierType, product_type: String, product_title: String, co2: Double, sapKey: String, img: String){
        
        self.date = date
        self.prev_tx_ids = prev_tx_ids
        self.latitude = latitude
        self.longitude = longitude
        self.supplier_id = supplier_id
        self.supplier_type = supplier_type
        self.product_type = product_type
        self.product_title = product_title
        self.co2 = co2
        self.sapKey = sapKey
        self.img = img
        
    }
    
    func getParameters() -> Parameters{
        
        let parameters: Parameters = [
            "date": self.date,
            "prev_tx_ids": self.prev_tx_ids,
            "location": [
                "lat": self.latitude,
                "lng": self.longitude
            ],
            "supplier_id": self.supplier_id,
            "supplier_type": self.supplier_type,
            "product_data": [
                "type": self.product_type,
                "title": self.product_title
            ],
            "co2": self.co2
        ]
        
        
        return parameters
    }
    
    static func parseFromJSON(json: JSON) -> SupplyChainItem? {
        
        print(json)
        
        var supplyChainData = json["result"]
        
        let supplier_id = supplyChainData["supplier_id"].string
        let latitude = supplyChainData["location"]["lat"].double
        let longitude = supplyChainData["location"]["lon"].double
        let supplier_type = supplyChainData["supplier_type"].string
        let product_type = supplyChainData["product_data"]["type"].string
        let product_image = supplyChainData["product_data"]["img"].string
        let product_title = supplyChainData["product_data"]["title"].string
        
        var prev_tx_ids = [String]()
        
        
        guard let u_prev_tx_ids = supplyChainData["prev_tx_ids"].array else { print("missing supplier_id"); return nil}
        
        for tx_id in u_prev_tx_ids {
            if let prex_tx_id =  tx_id.string {
                prev_tx_ids.append(prex_tx_id)
            }
        }
        
        let co2 = supplyChainData["co2"].double
        let sapKey = supplyChainData["sapKey"].string
        let date = supplyChainData["date"].string
        
        
        // Process ENUMS
        
        var enum_supplier_type: SupplierType?
        
        if(supplier_type == "PRODUCER"){
            enum_supplier_type = SupplierType.PRODUCER
        }else if(supplier_type == "TRANSPORT"){
            enum_supplier_type = SupplierType.TRANSPORT
        }else if(supplier_type == "RETAIL"){
            enum_supplier_type = SupplierType.RETAIL
        }else if(supplier_type == "STORAGE"){
            enum_supplier_type = SupplierType.STORAGE
        }
        
        guard let u_supplier_id = supplier_id else { print("missing supplier_id"); return nil}
        guard let u_latitude = latitude else { print("missing latitude"); return nil}
        guard let u_longitude = longitude else { print("missing longitude"); return nil}
        guard let u_enum_supplier_type = enum_supplier_type else { print("missing enum_supplier_type"); return nil}
        guard let u_product_type = product_type else { print("missing product_type"); return nil}
        guard let u_product_image = product_image else { print("missing product_image"); return nil}
        guard let u_product_title = product_title else { print("missing product_title"); return nil}
        guard let u_co2 = co2 else { print("missing co2"); return nil}
        guard let u_sapKey = sapKey else { print("missing sapKey"); return nil}
        guard let u_date = date else { print("missing date"); return nil}
        
        
        let supplyChainItem = SupplyChainItem(date: u_date, prev_tx_ids: prev_tx_ids, latitude: u_latitude, longitude: u_longitude, supplier_id: u_supplier_id, supplier_type: u_enum_supplier_type, product_type: u_product_type, product_title: u_product_title, co2: u_co2, sapKey: u_sapKey, img: u_product_image)
        
        return supplyChainItem
    }
    
}
