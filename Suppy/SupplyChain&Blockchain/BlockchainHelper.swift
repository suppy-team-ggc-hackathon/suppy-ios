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
    
    
    func fetchSupplyChain(cb: @escaping ([SupplyChainItem],Error?) -> Void ) {
        
        let res = [SupplyChainItem]()
        
        guard let blockchainURL = self.blockchainURL else { cb(res,CustomErrors.blockchainURLNotDefined); return }
        
        let supplyChainURL = "\(blockchainURL)/tx"
        
        Alamofire.request(supplyChainURL, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if let results = json["result"].array {
                    for res in results {
                        print(res["product_data"]["img"].string!.replacingOccurrences(of: "\\/", with: "/"))
                    }
                }
                
                print("JSON: \(json)")
                cb(res, nil)
            case .failure(let error):
                cb(res,error)
            }
        }
    }
    
    func fetchTxByID(id:String, cb: @escaping (SupplyChainItem?,Error?) -> Void ){
        
        guard let blockchainURL = self.blockchainURL else { cb(nil,CustomErrors.blockchainURLNotDefined); return }
        
        let supplyChainItemURL = "\(blockchainURL)/supply-chain/\(id)"
        
        Alamofire.request(supplyChainItemURL, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print(json)
                
                if let item = SupplyChainItem.parseFromJSON(json: json) {
                    print("made it!")
                    cb(item,nil)
                }else{
                    cb(nil, CustomErrors.itemCouldNotBeFetched)
                }
                
            case .failure(let error):
                cb(nil,error)
            }
        }
    }
    
    func fetchEndProduct(cb: @escaping (SupplyChainItem?,Error?) -> Void ){
        
        guard let blockchainURL = self.blockchainURL else { cb(nil,CustomErrors.blockchainURLNotDefined); return }
        
        let supplyChainItemURL = "\(blockchainURL)/end-product"
        
        Alamofire.request(supplyChainItemURL, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print(json)
                
                if let item = SupplyChainItem.parseFromJSON(json: json) {
                    print("made it!")
                    cb(item,nil)
                }else{
                    cb(nil, CustomErrors.itemCouldNotBeFetched)
                }
                
            case .failure(let error):
                cb(nil,error)
            }
        }
    }
    
    
    func fetchOriginAndLocation(id:String, cb: @escaping (JSON?,Error?) -> Void ){
        
        guard let blockchainURL = self.blockchainURL else { cb(nil,CustomErrors.blockchainURLNotDefined); return }
        
        let url = "\(blockchainURL)/origin-and-location/\(id)"
        
        Alamofire.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                cb(json,nil)
            case .failure(let error):
                cb(nil,error)
            }
        }
    }
    
}
