//
//  SongR.swift
//  MyMusic
//
//  Created by Fabiola Ramirez on 3/29/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//

import Foundation

import RealmSwift

class SongR: Object {
    
    @objc dynamic var trackId: Int = 0
    @objc dynamic var trackName: String = ""
    @objc dynamic var artistId: Int = 0
    @objc dynamic var artistName: String = ""
    @objc dynamic var artworkUrl100: String = ""
    @objc dynamic var collectionName: String = ""
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var trackViewUrl: String = ""
    
    override static func primaryKey() -> String? {
        return "trackId"
    }
}
