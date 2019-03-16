//
//  ItunesGET.swift
//  MusicBrowser
//
//  Created by John Freidrich Cinco on 3/15/19.
//  Copyright © 2019 John5. All rights reserved.
//

import Foundation

public class ItunesSearch:HttpGET {
   internal let path:String = "https://itunes.apple.com/search?term=%@&amp;country=%@&amp;media=%@"
   
    /**
     Constructor.
     
     - Parameters:
        - term: text string you want to search for.
        - country: The two-letter country code for the store you want to search.  (i.e. us, au, de, ph)
        - media: the type of media to search for.(i.e. movie, podcast, music, musicVideo, audiobook, shortFilm, tvShow, software, ebook, all)
     */
    public init(withTerm term:String, country:String, media:String) {
        // based on the spec in https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/#searching,
        // term must be url encoded, and spaces must be replaced with "+"
        let formattedTerm = term.replacingOccurrences(of: " ", with: "+").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        // format the path based on supplied query inputs
        let formattedPath = String(format: path, formattedTerm! , country, media)
        super.init(url: URL(string:"\(formattedPath)")!)
        
        // Setting accept and content-type headers
        addHeader(value: "application/json", forHTTPHeaderField: "Accept")
        addHeader(value: "application/json", forHTTPHeaderField: "Content-Type")
    }
    
    
    
}
