//
//  SupplyChainItemBuilder.swift
//  Suppy
//
//  Created by Daniel Montano on 06.10.18.
//  Copyright © 2018 Daniel Montano. All rights reserved.
//

import Foundation


class SupplyChainItemBuilder {
    
    static let sharedInstance = SupplyChainItemBuilder()

    private init(){}
    
    var building: Bool = false
    
    var supplier_type: SupplierType?
    
    func reset(){
        building = false
    }
    
    func buildSupplyChainItem() -> SupplyChainItem?{
        
        // Do some checks
        
        return nil
        
    }
    
}
