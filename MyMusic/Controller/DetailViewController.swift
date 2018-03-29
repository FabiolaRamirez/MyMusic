//
//  DetailViewController.swift
//  MyMusic
//
//  Created by Fabiola Ramirez on 3/28/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    
    func setData() {
        self.songLabel.text = song?.trackName
        self.artistLabel.text = song?.artistName
        self.collectionLabel.text = song?.collectionName
        let date = self.convertToDate((song?.releaseDate)!)
        self.dateLabel.text = formatForShow(date)
        getImage(url: (song?.artworkUrl100)!)
    }
    
    func convertToDate(_ input: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let date = dateFormatter.date(from: input)!
        return date
    }
    
    func formatForShow(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getImage(url: String) {
        settingUI(true)
        Service.downloadImage(url: url, success: {(data: Data) in
            DispatchQueue.main.async {
                self.settingUI(false)
                self.artistImageView.image = UIImage(data: data as Data)
            }
        }, failure: {() in
            self.settingUI(false)
        })
    }
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        alert(self, message: "Would You Like To Add This Song To Favorites? If So, You Could Share The iTunes Link Of This Song In Social Networking.")
    }
    
}

extension DetailViewController {
    
    func settingUI(_ value: Bool){
        if value{
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        } else{
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
        
    }
    
    func alert(_ controller: UIViewController, message: String) {
        let AlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) {
            action in AlertController.dismiss(animated: true, completion: nil)
            //save to database
            self.saveSong(self.song!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            action in AlertController.dismiss(animated: true, completion: nil)
        }
        
        AlertController.addAction(okAction)
        AlertController.addAction(cancelAction)
        controller.present(AlertController, animated: true, completion: nil)
    }
}

// MARK: Methods for Database

extension DetailViewController {
    
    func saveSong(_ song: Song) {
        let songR = SongR()
        songR.trackId = song.trackId
        songR.trackName = song.trackName
        songR.artistId = song.artistId
        songR.artistName = song.artistName
        songR.artworkUrl100 = song.artworkUrl100
        songR.collectionName = song.collectionName
        songR.releaseDate = song.releaseDate
        songR.trackViewUrl = song.trackViewUrl
        Database.saveSong(songR)
    }
    
}


