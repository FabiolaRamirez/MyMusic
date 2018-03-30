//
//  Util.swift
//  MyMusic
//
//  Created by Fabiola Ramirez on 3/30/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//

import Foundation

struct Util {

    
    static func convertToDate(_ input: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let date = dateFormatter.date(from: input)!
        return date
    }
    
    static func formatForShow(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    
}
