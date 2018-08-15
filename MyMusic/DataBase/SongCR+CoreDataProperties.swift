//
//  SongCR+CoreDataProperties.swift
//  MyMusic
//
//  Created by AVANTICA BOLIVIA on 8/15/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//
//

import Foundation
import CoreData


extension SongCR {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SongCR> {
        return NSFetchRequest<SongCR>(entityName: "SongCR")
    }

    @NSManaged public var trackId: Int32
    @NSManaged public var trackName: String?
    @NSManaged public var artistId: Int32
    @NSManaged public var artistName: String?
    @NSManaged public var artworkUrl100: String?
    @NSManaged public var collectionName: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var trackViewUrl: String?

}
