//
//  ViewController.swift
//  MyMusic
//
//  Created by Fabiola Ramirez on 3/27/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var data = [Song]()
    var activityIndicator = UIActivityIndicatorView()
    var songList : [Song] = []
    var filteredList: [Song] = []
    
    var selectedSong: Song?
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
        settingUIActivityI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getSongs()
    }
    
    func searchBySong(songName: String) {
        settingUI(true)
        Service.sharedInstance.getMusicBySong(songName: songName, success: {(songList: [Song]) in
            DispatchQueue.main.async {
                self.settingUI(false)
                if songList.count == 0 {
                    print("No Results Found")
                } else {
                    self.filteredList = songList
                    self.data = self.filteredList
                    self.tableView.reloadData()
                }
            }
        }, failure: {(messaje: ErrorMessage) in
            DispatchQueue.main.async {
                self.settingUI(false)
                self.alertError(self, error: messaje.rawValue)
            }
        })
    }
    
    func getSongs() {
        settingUI(true)
        Service.sharedInstance.getSongs(success: {(songList: [Song]) in
            DispatchQueue.main.async {
                self.settingUI(false)
                self.songList = songList
                self.data = self.songList
                self.tableView.reloadData()
            }
        }, failure: {(messaje: ErrorMessage) in
            DispatchQueue.main.async {
                self.settingUI(false)
                self.alertError(self, error: messaje.rawValue)
            }
        })
    }
    
    
    func  settingUI() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        }
        searchController.searchBar.placeholder = "Search"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search By Song"
    }
    
    
    func settingUIActivityI() {
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.color = UIColor.darkGray
    }
    
    
    func filterContentForSearchText(searchText: String){
        if searchText.count >= 3 {
            let escapedString = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            searchBySong(songName: escapedString!)
        }
    }
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailCV" {
            let destination = segue.destination as! DetailViewController
            destination.song = self.selectedSong
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.data = self.songList
        self.tableView.reloadData()
    }
    
}

extension PlaylistViewController {
    
    func settingUI(_ value: Bool){
        if value{
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        } else{
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        
    }
}

extension UIViewController {
    
    func alertError(_ controller: UIViewController, error: String) {
        let alertController = UIAlertController(title: "", message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) {
            action in alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}

extension PlaylistViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredList.count
        }
        return data.count
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 77.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playListCell", for: indexPath) as! PlayListCell
        let song: Song = data[indexPath.row]
        cell.songLabel.text = song.trackName
        cell.artistNameLabel.text = song.artistName

        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedSong = data[indexPath.row]
        performSegue(withIdentifier: "showDetailCV", sender: nil)
    }
    
}

extension PlaylistViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!)
    }
}

extension PlaylistViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}



