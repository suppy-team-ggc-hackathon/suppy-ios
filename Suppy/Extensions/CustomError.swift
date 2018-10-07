//
//  CustomError.swift
//  Suppy
//
//  Created by Daniel Montano on 07.10.18.
//  Copyright © 2018 Daniel Montano. All rights reserved.
//

import Foundation

struct CustomError: LocalizedError {
    
    var title: String?
    var code: Int
    var errorDescription: String { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
    
    func append(str: String) -> CustomError {
        return CustomError(title: self.title, description: "\(self._description): \(str)", code: self.code)
    }
}

class CustomErrors {
    
    static let blockchainURLNotDefined = CustomError(title: "URL Error", description: "blockchain URL not defined", code: 100)
    static let itemCouldNotBeFetched = CustomError(title: "Fetching Error", description: "Supply chain item could not be fetched", code: 101)
    
}
