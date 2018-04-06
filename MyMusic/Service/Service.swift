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
    
    
    static func getMusicBySong(songName: String, success: @escaping(_ songList: [Song]) -> (), failure: @escaping(_ errorResponse: ErrorMessage)-> ()){
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://itunes.apple.com/search?term=\(songName)")! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                failure(.noConnection)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                failure(.statusCode)
                return
            }
            
            guard let data = data else {
                failure(.noFound)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                failure(.unableToParse)
                return
            }
            let parsedResult = try? JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dictionary = parsedResult as? [String: Any] else {
                failure(.unableToConvert)
                return
            }
            
            guard let results = dictionary["results"] as? [[String: Any]] else {
                failure(.noKeyFound)
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
    
    static func getSongs(success: @escaping(_ songList: [Song]) -> (), failure: @escaping(_ errorResponse: ErrorMessage)-> ()){
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://itunes.apple.com/search?term=*&entity=song")! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
               failure(.noConnection)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                failure(.statusCode)
                return
            }
            
            guard let data = data else {
                failure(.noFound)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                failure(.unableToParse)
                return
            }
            let parsedResult = try? JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dictionary = parsedResult as? [String: Any] else {
                failure(.unableToConvert)
                return
            }
            
            
            guard let results = dictionary["results"] as? [[String: Any]] else {
                failure(.noKeyFound)
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
    
    
    static func downloadImage(url: String, success: @escaping(_ data: Data) -> (), failure: @escaping(_ errorResponse: ErrorMessage)-> ()){
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            if error == nil {
                success(data!)
            } else {
                print("Error: \(String(describing: error))")
                failure(.noConnection)
            }
            
            }
            .resume()
    }
    
    
    
}
