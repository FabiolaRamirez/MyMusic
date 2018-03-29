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
        Service.downloadImage(url: url, success: {(data: Data) in
            DispatchQueue.main.async {
                print("success!!!")
                self.artistImageView.image = UIImage(data: data as Data)
            }
        }, failure: {() in
            print("failure")
        })
    }
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


