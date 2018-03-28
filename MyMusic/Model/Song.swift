//
//  Song.swift
//  MyMusic
//
//  Created by Fabiola Ramirez on 3/27/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//

import Foundation

import MapKit

struct Song {
    
    let trackId: Int
    let trackName: String
    let artistId: Int
    let artistName: String
    let previewUrl: String
    let artworkUrl60: String
    let trackPrice: String
    let collectionId: Int
    let collectionName: String
    let releaseDate: String
    
    
    init?(dictionary: [String: Any]) {
        self.trackId = dictionary["trackId"] as? Int ?? 0
        self.trackName = dictionary["trackName"] as? String ?? ""
        self.artistId = dictionary["artistId"] as? Int ?? 0
        self.artistName = dictionary["artistName"] as? String ?? ""
        self.previewUrl = dictionary["previewUrl"] as? String ?? ""
        self.artworkUrl60 = dictionary["artworkUrl60"] as? String ?? ""
        self.trackPrice = dictionary["trackPrice"] as? String ?? ""
        self.collectionId =  dictionary["collectionId"] as? Int ?? 0
        self.collectionName = dictionary["collectionName"] as? String ?? ""
        self.releaseDate = dictionary["releaseDate"] as? String ?? ""
    }
    
}
