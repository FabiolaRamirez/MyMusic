//
//  FavoriteCell.swift
//  MyMusic
//
//  Created by FabiolaRamirez on 3/29/18.
//  Copyright © 2018 FabiolaRamirez. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    var url: String!
    var viewController: FavoriteTableViewController!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func shareLink(_ sender: UIButton) {
        
        let url = NSURL(string: self.url)
        let share = [url as Any]
        let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.viewController.view
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
