//
//  FavoriteTableViewController.swift
//  MyMusic
//
//  Created by FabiolaRamirez on 3/29/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//

import UIKit
import CoreData

class FavoriteTableViewController: UITableViewController {
    
    var songsList: [SongCR] = []
    var urliTunesSong: String!
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.songsList = Database.fetchSongs()
        do {
            songsList = try context.fetch(SongCR.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
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
        let date = Util.convertToDate(song.releaseDate!)
        cell.dateLabel.text = Util.formatForShow(date)
        cell.collectionLabel.text = song.collectionName
        cell.url = song.trackViewUrl
        cell.viewController = self
        
        //donwload image
        Service.sharedInstance.downloadImage(url: song.artworkUrl100!, success: {(data: Data) in
            DispatchQueue.main.async {
                cell.artistImageView.image = UIImage(data: data as Data)
            }
        }, failure: {(message: ErrorMessage) in
            DispatchQueue.main.async {
                self.alertError(self, error: message.rawValue)
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
            let songCR: SongCR = songsList[indexPath.row]
            deleteSong(songCR)
            do {
                songsList = try context.fetch(SongCR.fetchRequest())
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            self.tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
}

// MARK: Methods for Darabase
extension FavoriteTableViewController {
    
    func deleteSong(_ songCR: SongCR) {
        //Database.deleteSong(songR)
        context.delete(songCR)
    }
    
}


