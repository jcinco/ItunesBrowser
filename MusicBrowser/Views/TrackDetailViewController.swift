//
//  TrackDetailViewController.swift
//  MusicBrowser
//
//  Created by John Freidrich Cinco on 3/15/19.
//  Copyright © 2019 John5. All rights reserved.
//

import Foundation
import UIKit

public class TrackDetailViewController:UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public var trackItem:TrackItem?
    
    override public func viewDidLoad() {
        // set the vertical alignment of the Description UI Label
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.sizeToFit()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
        
        // Set this screen as default
        UserDefaults.standard.set("DETAIL_SCREEN", forKey: "lastScreen")
    }
    
    // called when back is pressed
    override public func didMove(toParent parent: UIViewController?) {
        if (self.parent != parent) {
            // Mark nil the track details if view is moving back to parent
            UserDefaults.standard.set(nil, forKey: "trackDetails")
        }
    }
    
    
    private func populateUI(withTrackItem trackItem:TrackItem) {
        
        // Set UI
        self.titleLabel.text = trackItem.trackName ?? ""
        self.artistNameLabel.text = trackItem.artistName ?? ""
        self.genre.text = trackItem.genre ?? "Unknown"
        self.priceLabel.text = "\((trackItem.currency)!) \((trackItem.trackPrice)!)"
        self.descriptionLabel.text = (trackItem.description.isEmpty == false) ? trackItem.description : "No Description"
        do {
            self.trackImageView.image = UIImage(data: try Data(contentsOf: trackItem.artworkUrl100!))
        }
        catch let e as NSError {
            print(e.localizedFailureReason)
        }
    }
    
    
    public func loadData() {
        
        let model = TrackListModel.sharedInstance
        if nil != model.selectedTrackIndex {
            let trackItem = model.trackItem(forIndex: model.selectedTrackIndex!)
            if (nil != trackItem) {
                populateUI(withTrackItem: trackItem!)
                UserDefaults.standard.set(trackItem?.innerDictionary, forKey: "trackDetails")
            }
            else {
                self.dismiss(animated: true) {
                    
                }
            }
        }
        else {
            let lastTrackItemDetails = UserDefaults.standard.object(forKey: "trackDetails") as? [String:Any?] ?? nil
            if (nil != lastTrackItemDetails) {
                let lastTrackItem = TrackItem(details: lastTrackItemDetails)
                populateUI(withTrackItem: lastTrackItem)
            }
            else {
                self.dismiss(animated: true) {
                    
                }
            }
        }
        
    }
}
