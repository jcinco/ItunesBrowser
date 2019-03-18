//
//  TrackItem.swift
//  MusicBrowser
//
//  Created by John Freidrich Cinco on 3/14/19.
//  Copyright © 2019 John5. All rights reserved.
//

import Foundation

public class TrackItem {
    
    // MARK: - Properties
    private var _innerDictionary:[String:Any?]! = [:]
    public var innerDictionary:[String:Any?]! {
        get {
            return _innerDictionary
        }
    }
    
    public var trackId:Int! {
        get {
            return _innerDictionary["trackId"] as! Int
        }
    }
    
    public var trackName:String? {
        get {
            return _innerDictionary["trackName"] as? String ?? nil
        }
    }
    
    
    public var artworkUrl100:URL? {
        get {
            let urlString = _innerDictionary["artworkUrl100"] as? String ?? "http://"
            return URL(string:urlString)
        }
    }
    
    public var artworkUrl60:URL? {
        get {
            let urlString = _innerDictionary["artworkUrl60"] as? String ?? "http://"
            return URL(string:urlString)
        }
    }
    
    
    public var artworkUrl30:URL? {
        get {
            let urlString = _innerDictionary["artworkUrl30"] as? String ?? "http://"
            return URL(string:urlString)
        }
    }
    
    
    public var trackPrice:Float! {
        get {
            let price = _innerDictionary["trackPrice"] as? NSNumber ?? 0.0
            
            return price.floatValue
        }
    }
    
    public var genre:String? {
        get {
            return _innerDictionary["primaryGenreName"] as? String
        }
    }
    
    public var currency:String! {
        get {
            let cur = _innerDictionary["currency"] as! String
            return cur
        }
    }
    
    public var artistName:String! {
        get {
            return _innerDictionary["artistName"] as! String
        }
    }
    
    public var description:String! {
        get {
            return _innerDictionary["longDescription"] as? String ?? ""
        }
    }
    
    
    // MARK: - Constructor
    /**
     Constructor
     
     - Parameters:
     - details [String:Any?]? - the track detailed information search response.
     */
    public init(details:[String:Any?]?) {
        // We keep the specific track item's JSON data as a dictionary.
        // This will come in handy when we want to persist its data in a PLIST file.
        self._innerDictionary = details ?? [:]
    }
    
    
}
