//
//  ErrorResponse.swift
//  MyMusic
//
//  Created by Fabiola Ramirez on 3/27/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//

import Foundation


struct ErrorResponse {
    
    //let code: Int
    let message: String
    
    init(message: String) {
        //self.code = code
        self.message = message
    }
    
}
