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
    var activityIndicator = UIActivityIndicatorView()
    let musicList = ["aa","bb","cc","dd"]
    var filteredList: [Song] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingUI()
        settingUIActivityI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    func searchBySong(songName: String) {
        Service.getMusicBySong(songName: songName, success: {(songList: [Song]) in
            DispatchQueue.main.async {
                self.settingUI(false)
                if songList.count == 0 {
                    print("No Results Found")
                } else {
                    self.filteredList = songList
                    self.tableView.reloadData()
                }
            }
        }, failure: {(error) in
            DispatchQueue.main.async {
                self.settingUI(false)
                self.alertError(self, error: error.message)
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
    
}

extension PlaylistViewController {
    
    func alertError(_ controller: UIViewController, error: String) {
        let AlertController = UIAlertController(title: "", message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) {
            action in AlertController.dismiss(animated: true, completion: nil)
        }
        AlertController.addAction(cancelAction)
        controller.present(AlertController, animated: true, completion: nil)
    }
    
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
}

extension PlaylistViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredList.count
        }
        return musicList.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playListCell", for: indexPath) as! PlayListCell
        if isFiltering() {
            cell.titleLabel.text = filteredList[indexPath.row].trackName
        } else {
            cell.titleLabel.text = musicList[indexPath.row]
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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



