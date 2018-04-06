//
//  Util.swift
//  MyMusic
//
//  Created by Fabiola Ramirez on 3/30/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//

import Foundation

enum ErrorMessage: String {
    case noConnection = "Looks like you have an unstable network, please try again later"
    case statusCode = "Your Request Returned A Status Code Other Than 2.."
    case noFound = "No Data Was Returned By The Request!"
    case unableToParse = "Could not Parse The Data As JSON"
    case unableToConvert = "Can not convert as a Dictionary"
    case noKeyFound = "Cannot find Key Results In parsedResult"
}

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





