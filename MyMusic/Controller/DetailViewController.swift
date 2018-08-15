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
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    
    func setData() {
        songLabel.text = song?.trackName
        artistLabel.text = song?.artistName
        collectionLabel.text = song?.collectionName
        let date = Util.convertToDate((song?.releaseDate)!)
        dateLabel.text = Util.formatForShow(date)
        getImage(url: (song?.artworkUrl100)!)
    }
    
    
    func getImage(url: String) {
        //show activity indicator
        settingUI(true)
        Service.sharedInstance.downloadImage(url: url, success: {(data: Data) in
            DispatchQueue.main.async {
                //hide activity indicator
                self.settingUI(false)
                self.artistImageView.image = UIImage(data: data as Data)
            }
        }, failure: {(message: ErrorMessage) in
            DispatchQueue.main.async {
                //hide activity indicator
                 self.settingUI(false)
                 self.alertMessage(self, message: message.rawValue)
            }
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
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        
    }
    
    
    func alertMessage(_ controller: UIViewController, message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) {
            action in alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    
    func alert(_ controller: UIViewController, message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) {
            action in alertController.dismiss(animated: true, completion: nil)
            if self.exist(self.song!) {
               self.alertMessage(self, message: "This Song Is Already Kept!")
            } else {
               self.saveSong(self.song!)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            action in alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true, completion: nil)
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
        let songCR = SongCR(entity: SongCR.entity(), insertInto: context)
        songCR.trackId = Int32(song.trackId)
        
        
        
    }
    
    func exist(_ song: Song) -> Bool {
        let songR = SongR()
        songR.trackId = song.trackId
        return Database.exist(songR)
    }
    
}


