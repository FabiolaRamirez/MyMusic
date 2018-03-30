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
        Service.downloadImage(url: url, success: {(data: Data) in
            DispatchQueue.main.async {
                //hide activity indicator
                self.settingUI(false)
                self.artistImageView.image = UIImage(data: data as Data)
            }
        }, failure: {(error) in
            DispatchQueue.main.async {
                //hide activity indicator
                 self.settingUI(false)
                 self.alertError(self, error: error.message)
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
    
    
    func alertError(_ controller: UIViewController, error: String) {
        let AlertController = UIAlertController(title: "", message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) {
            action in AlertController.dismiss(animated: true, completion: nil)
        }
        AlertController.addAction(cancelAction)
        controller.present(AlertController, animated: true, completion: nil)
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


