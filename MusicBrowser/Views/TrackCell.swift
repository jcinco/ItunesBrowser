//
//  TrackCell.swift
//  MusicBrowser
//
//  Created by John Freidrich Cinco on 3/15/19.
//  Copyright © 2019 John5. All rights reserved.
//

import Foundation
import UIKit

public class TrackCell:UITableViewCell {
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackGenreLabel: UILabel!
    @IBOutlet weak var trackPriceLabel: UILabel!
 
    private var _trackItem:TrackItem?
    public var trackItem:TrackItem? {
        get {
            return self._trackItem
        }
    }
    
    public func setTrackItem(item:TrackItem) {
        self._trackItem = item
        
        // set the image of this row.
        trackImageView.image = fetchImage(url: (trackItem?.artworkUrl60)!)
        trackNameLabel.text = trackItem?.trackName ?? ""
        trackGenreLabel.text = trackItem?.genre ?? ""
        trackPriceLabel.text = "\((trackItem?.currency)!) \((trackItem?.trackPrice)!)"
    }
    
    private func fetchImage(url:URL)->UIImage? {
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)

        }
        catch let e as NSError {
            print(e.localizedFailureReason)
        }
        return nil
    }
    
}
