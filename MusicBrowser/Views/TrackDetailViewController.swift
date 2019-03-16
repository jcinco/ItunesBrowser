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
    }
    
    public func loadData() {
        do {
        let model = TrackListModel.sharedInstance
        if nil != model.selectedTrackIndex {
            let trackItem = model.trackItem(forIndex: model.selectedTrackIndex!)
            
            if (nil != trackItem) {
                // Set UI
                self.titleLabel.text = trackItem!.trackName ?? ""
                self.trackImageView.image = UIImage(data: try Data(contentsOf: trackItem!.artworkUrl100!))
                self.artistNameLabel.text = trackItem!.artistName ?? ""
                self.genre.text = trackItem!.genre ?? "Unknown"
                self.priceLabel.text = "\((trackItem!.currency)!) \((trackItem!.trackPrice)!)"
                self.descriptionLabel.text = trackItem!.description
            }
            else {
                self.dismiss(animated: true) {
                    
                }
            }
        }
        else {
            self.dismiss(animated: true) {
                
            }
        }
        }
        catch let e as NSError {
            print(e.localizedFailureReason!)
        }
    }
}
