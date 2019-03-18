//
//  HttpGET.swift
//  MusicBrowser
//
//  Created by John Freidrich Cinco on 3/15/19.
//  Copyright © 2019 John5. All rights reserved.
//

import Foundation

open class HttpGET : HttpRESTRequest {
    
    private let METHOD:String = "GET"
    
    internal var onCompleteBlockJson:(Dictionary<String,Any?>?, HTTPURLResponse?, Error?)->Void = {(json:Dictionary<String,Any?>?, response:HTTPURLResponse?, error:Error?)->Void in}
   
    // Constructor
    public init(url:URL)
    {
        super.init(withHTTPMethod:METHOD, forUrl:url)
    }
    
    
    
    /**
     Executes the GET request
     
     - Parameters:
     - (Dictionary<String,Any?>?, HTTPURLResponse?, Error?)->Void completion block.
     */
    public func execute(onJsonRequestResult:@escaping (Dictionary<String,Any?>?, HTTPURLResponse?, Error?)->Void) {
        self.onCompleteBlockJson = onJsonRequestResult
        super.execute { (data, response, error) in
            var resultData:[String:Any?]?
            if (nil == error) {
                do {
                    if (nil != data) {
                        let dataStr = String(data: data!, encoding: .utf8)!
                        resultData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, Any?>
                        print("\(dataStr)")
                    }
                }
                catch let err as NSError {
                    print(err.localizedDescription)
                    self.onCompleteBlockJson(["data":data], response, error)
                    return
                }
            }
            self.onCompleteBlockJson(resultData, response, error)
        }
    }
    
    
}
