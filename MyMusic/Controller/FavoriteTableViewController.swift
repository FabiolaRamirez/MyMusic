//
//  FavoriteTableViewController.swift
//  MyMusic
//
//  Created by FabiolaRamirez on 3/29/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    var songsList: [SongR] = []
    var urliTunesSong: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.songsList = Database.fetchSongs()
        self.tableView.reloadData()
    }
    
    
    func  settingUI() {
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 189.0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
        let song = songsList[indexPath.row]
        cell.songLabel.text = song.trackName
        cell.artistLabel.text = song.artistName
        let date = Util.convertToDate(song.releaseDate)
        cell.dateLabel.text = Util.formatForShow(date)
        cell.collectionLabel.text = song.collectionName
        cell.url = song.trackViewUrl
        cell.viewController = self
        
        //donwload image
        Service.downloadImage(url: song.artworkUrl100, success: {(data: Data) in
            DispatchQueue.main.async {
                cell.artistImageView.image = UIImage(data: data as Data)
            }
        }, failure: {(error) in
            DispatchQueue.main.async {
                self.alertError(self, error: error.message)
            }
        })
        
        return cell
    }
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let songR: SongR = songsList[indexPath.row]
            deleteSong(songR)
            self.songsList = Database.fetchSongs()
            self.tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
}

extension FavoriteTableViewController {
    
    func alertError(_ controller: UIViewController, error: String) {
        let AlertController = UIAlertController(title: "", message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) {
            action in AlertController.dismiss(animated: true, completion: nil)
        }
        AlertController.addAction(cancelAction)
        controller.present(AlertController, animated: true, completion: nil)
    }
    
    
}

// MARK: Methods for Darabase
extension FavoriteTableViewController {
    
    func deleteSong(_ songR: SongR) {
        Database.deleteSong(songR)
    }
    
}


