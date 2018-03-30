//
//  DataBase.swift
//  MyMusic
//
//  Created by FabiolaRamirez on 3/29/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//

import Foundation
import RealmSwift


class Database {
    
    static func saveSong(_ song: SongR) {
        let realm = try! Realm()
        if realm.object(ofType: SongR.self, forPrimaryKey: song.trackId) != nil {
            return
        }
        try! realm.write {
            realm.add(song)
        }
    }
    
    static func deleteSong(_ song: SongR) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(song)
        }
    }
    
    
    static func fetchSongs() -> [SongR] {
        let realm = try! Realm()
        let songs = realm.objects(SongR.self)
        return Array(songs)
    }
    
    static func exist(_ song: SongR) -> Bool {
        let realm = try! Realm()
        if realm.object(ofType: SongR.self, forPrimaryKey: song.trackId) != nil {
            return true
        } else {
            return false
        }
    }
    
}
