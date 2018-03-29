//
//  Service.swift
//  MyMusic
//
//  Created by Fabiola Ramirez on 3/27/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//

import Foundation

import UIKit

class Service {
    
    
    static func getMusicBySong(songName: String, success: @escaping(_ songList: [Song]) -> (), failure: @escaping(_ errorResponse: ErrorResponse)-> ()){
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://itunes.apple.com/search?term=\(songName)")! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                let e = ErrorResponse(message: "Request error: \(String(describing: error))")
                failure(e)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let e = ErrorResponse(message: "Your Request Returned A Status Code Other Than 2..")
                failure(e)
                return
            }
            
            guard let data = data else {
                let e = ErrorResponse(message: "No Data Was Returned By The Request!")
                failure(e)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                let e = ErrorResponse(message: "Could not Parse The Data As JSON")
                failure(e)
                return
            }
            let parsedResult = try? JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dictionary = parsedResult as? [String: Any] else {
                let e = ErrorResponse(message: "Can not convert as a Dictionary")
                failure(e)
                return
            }
            
            
            guard let results = dictionary["results"] as? [[String: Any]] else {
                let e = ErrorResponse(message: "Cannot find Key Results In parsedResult")
                failure(e)
                return
            }
            
            let songResults = dictionary["results"] as? [[String: Any]]
            var songList: [Song] = []
            for obj in songResults! {
                let song = Song(dictionary: obj)
                songList.append(song!)
            }
            success(songList)
        }
        task.resume()
        
    }
    
    static func getSongs(success: @escaping(_ songList: [Song]) -> (), failure: @escaping(_ errorResponse: ErrorResponse)-> ()){
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://itunes.apple.com/search?term=*&entity=song")! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                let e = ErrorResponse(message: "Request error: \(String(describing: error))")
                failure(e)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let e = ErrorResponse(message: "Your Request Returned A Status Code Other Than 2..")
                failure(e)
                return
            }
            
            guard let data = data else {
                let e = ErrorResponse(message: "No Data Was Returned By The Request!")
                failure(e)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                let e = ErrorResponse(message: "Could not Parse The Data As JSON")
                failure(e)
                return
            }
            let parsedResult = try? JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dictionary = parsedResult as? [String: Any] else {
                let e = ErrorResponse(message: "Can not convert as a Dictionary")
                failure(e)
                return
            }
            
            
            guard let results = dictionary["results"] as? [[String: Any]] else {
                let e = ErrorResponse(message: "Cannot find Key Results In parsedResult")
                failure(e)
                return
            }
            
            let songResults = dictionary["results"] as? [[String: Any]]
            var songList: [Song] = []
            for obj in songResults! {
                let song = Song(dictionary: obj)
                songList.append(song!)
            }
            success(songList)
        }
        task.resume()
        
    }
    
    
    static func downloadImage(url: String, success: @escaping(_ data: Data) -> (), failure: @escaping()-> ()){
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            if error == nil {
                success(data!)
            } else {
                print("Error: \(String(describing: error))")
            }
            
            }
            .resume()
    }
    
    
    
}
