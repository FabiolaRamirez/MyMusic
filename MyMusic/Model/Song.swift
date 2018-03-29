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
    let artworkUrl100: String
    let collectionName: String
    let releaseDate: String
    let trackViewUrl: String
    
    
    init?(dictionary: [String: Any]) {
        self.trackId = dictionary["trackId"] as? Int ?? 0
        self.trackName = dictionary["trackName"] as? String ?? ""
        self.artistId = dictionary["artistId"] as? Int ?? 0
        self.artistName = dictionary["artistName"] as? String ?? ""
        self.artworkUrl100 = dictionary["artworkUrl100"] as? String ?? ""
        self.collectionName = dictionary["collectionName"] as? String ?? ""
        self.releaseDate = dictionary["releaseDate"] as? String ?? ""
        self.trackViewUrl = dictionary["trackViewUrl"] as? String ?? ""
    }
    
}
