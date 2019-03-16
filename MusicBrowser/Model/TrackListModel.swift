//
//  TrackMediaModel.swift
//  MusicBrowser
//
//  Created by John Freidrich Cinco on 3/14/19.
//  Copyright © 2019 John5. All rights reserved.
//

import Foundation
import UIKit


/// TrackListModel
/// This singleton class will hold the results obtained from the itunes API
/// specified.
public class TrackListModel:NSObject, UITableViewDataSource {
    
    private var trackItems:[TrackItem]! = []
    private var trackResultsDict:Dictionary<String,Any?>?
    private let trackListFile:String = "\(TempFileManager.sharedInstance.temporaryDirPath!)/trackList.plist"
    
    private var _selectedTrackIndex:Int? = nil
    public var selectedTrackIndex:Int? {
        get {
            return _selectedTrackIndex
        }
    }
    
    // MARK: - Private methods
    private func parseResults() {
        if (nil != trackResultsDict) {
            let result = trackResultsDict!["results"] as! [Any?]
            // create TrackItem object array
            for item in result {
                let trackItem = TrackItem(details: item as! [String:Any?])
                
                trackItems.append(trackItem)
            }
        }
    }
    
    // MARK: - Data loading
    public func load() {
        
        if (TempFileManager.sharedInstance.fileExists(atPath: trackListFile)) {
            self.trackResultsDict = NSDictionary(contentsOfFile: trackListFile) as! Dictionary<String, Any?>
            self.parseResults()
        }
        else {
            // Default search items based on requirements
            queryServer(withTerm: "star", country: "au", media: "movie")
        }
    }
    
    /**
     Queries the iTunes server for track items.
     
     - Parameters:
        - term: String
        - country: String
        - media: String
     */
    public func queryServer(withTerm term:String?, country:String?, media:String?) {
        guard let inTerm = term,
            let inCountry = country,
            let inMedia = media else {
            return
        }
        
        ItunesSearch(withTerm: term!, country: country!, media: media!)
            .execute { (result:Dictionary<String,Any?>?, response, error) in
            
            if ((response?.statusCode)! >= 200 && (response?.statusCode)! < 300) {
                self.trackResultsDict = result
                // persist in file
                self.commit()
                self.parseResults()
            }
            
        }
    }
    
    
    // MARK: - Persistence
    public func commit() -> Bool {
        if (nil != self.trackResultsDict) {
            let state = (self.trackResultsDict! as NSDictionary).write(to:
                URL(fileURLWithPath: self.trackListFile), atomically: true)
            return state
        }
        return false
    }
    
    public func setSelectedItemIndex(index:Int?) {
        self._selectedTrackIndex = index
    }
    
    public func trackItem(forIndex index:Int)->TrackItem? {
        if (nil != trackItems) {
            if (index < trackItems.count) {
                return trackItems[index]
            }
        }
        return nil
    }
    
    // MARK: - UITableViewDataSource delegate methods
    
    /// Standard table view data loading routine.
    ///
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TrackCell = tableView.dequeueReusableCell(withIdentifier: "trackCell") as! TrackCell
        let item:TrackItem = self.trackItems[indexPath.row]
        cell.setTrackItem(item: item)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trackItems.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    // MARK: - Singleton implementation
    private static var INSTANCE:TrackListModel!
    public static var sharedInstance:TrackListModel {
        get {
            if nil == INSTANCE {
                INSTANCE = TrackListModel()
            }
            return INSTANCE
        }
    }
    private override init() {
        super.init()
    }
}
