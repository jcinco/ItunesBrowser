//
//  HttpRESTRequest.swift
//  MusicBrowser
//
//  Created by John Freidrich Cinco on 3/15/19.
//  Copyright © 2019 John5. All rights reserved.
//

import Foundation

public protocol HttpResponseDelegate
{
    func httpResponse(withData data:Data?, response:HTTPURLResponse?, error:Error?)
}


struct UrlParam {
    public var name:String?
    public var value:String?
    
    public init(name:String, value:String) {
        self.name = name
        self.value = value
    }
}

/**
 The base class for all REST requests.
 This class encapsulates the process for
 */
open class HttpRESTRequest {
    // default request timeout
    internal let defaultTimeOut:TimeInterval = 30
    
    // MARK: - Properties and member variables
    public var urlRequest:URLRequest?
    internal var urlSession:URLSession?
    internal var urlSessionTimeOut:TimeInterval?
    
    internal var host:String?
    internal var method:String?
    
    internal var onCompleteBlock:(Data?, HTTPURLResponse?, Error?)->Void = {(data:Data?, response:HTTPURLResponse?, error:Error?)->Void in}
    
    private var urlParams:Array<UrlParam>?
    
    
    
    open var url:String? {
        if nil != urlRequest {
            return urlRequest!.url?.absoluteString
        }
        return nil
    }
    
    open var session:URLSession? {
        get {
            return self.urlSession
        }
    }
    
    open var request:URLRequest? {
        get {
            return self.urlRequest
        }
    }
    
    private var _delegate:HttpResponseDelegate?
    public var delegate:HttpResponseDelegate
    {
        set
        {
            _delegate = newValue
        }
        get {
            return _delegate!
        }
    }
    
    /**
     Request time out value in seconds.
     */
    public var timeOut:TimeInterval
    {
        set (newTimeOut)
        {
            if (newTimeOut < 1)
            {
                urlSessionTimeOut = defaultTimeOut
            }
            else
            {
                urlSessionTimeOut = newTimeOut
            }
            
            if (nil != urlSession) {
                urlSession!.configuration.timeoutIntervalForRequest = urlSessionTimeOut!
                urlSession!.configuration.timeoutIntervalForResource = urlSessionTimeOut!
            }
        }
        get
        {
            return urlSessionTimeOut!
        }
    }
    
    
    /**
     Constructor.
     - Parameters:
     - method: the request method i.e. "POST", "GET", "PUT", etc.
     - url: the host address
     */
    public init(withHTTPMethod method:String, forUrl url:URL)
    {
       print(String(format:"Creating %@ request for %@", method, url.absoluteString))
        
        urlRequest = URLRequest(url: url)
        urlRequest!.httpMethod = method
        
        urlSessionTimeOut = defaultTimeOut
        
        // Create the url session if it's nil
        if (urlSession == nil)
        {
            let urlSessionConfiguration = URLSessionConfiguration.default
            urlSessionConfiguration.timeoutIntervalForRequest = urlSessionTimeOut!
            urlSessionConfiguration.timeoutIntervalForResource = urlSessionTimeOut!
            
            urlSession = URLSession(configuration: urlSessionConfiguration)
        }
    }
    
    // MARK: - Internal methods
    
    /**
     The internal callback for the URLRequest object.
     */
    internal func requestComplete(withData data:Data?, response:URLResponse?, error:Error?)
    {
        var httpResponse:HTTPURLResponse?
        
        if (error != nil)
        {
            print(String(format: "Error: %@", error!.localizedDescription))
            print(String(format: "Debug desc: %@", error.debugDescription))
        }
        else
        {
            httpResponse = (response as? HTTPURLResponse)!
            print(String(format: "Http Request Completed: %@", (response?.url?.absoluteString)!))
            print(String(format: "Status: %d", httpResponse!.statusCode))
        }
        
        if (_delegate != nil) {
            _delegate?.httpResponse(withData: data, response: httpResponse, error: error)
        }
        
        // Execute the completion block
        onCompleteBlock(data, httpResponse, error)
    }
    
    
    // MARK: - Public methods
    
    /**
     Adds a url parameter. The key/value parameter will reflect as: "/path/to/endpoint?key=value&key2=value2"
     
     - Parameters:
     - key: the variable name of the parameter
     - value: the value of the parameter
     */
    public func addUrlParam(key:String, value:String) {
        if (nil == urlParams) {
            urlParams = Array<UrlParam>()
        }
        
        let param = UrlParam(name: key, value: value)
        
        urlParams?.append(param)
    }
    
    
    /**
     Adds a header parameter.
     
     - Parameters:
     - value: the parameter value
     - field: the header parameter name
     */
    public func addHeader(value:String, forHTTPHeaderField field:String)
    {
        if (urlRequest != nil)
        {
            print(String(format: "Setting %@ = %@", field, value))
            urlRequest!.addValue(value, forHTTPHeaderField: field)
        }
    }
    
    /**
     Adds a set of header parameters.
     
     - Parameters:
     - values: a list of parameters in a Dictionary<key,value>
     */
    public func addHeaders(values:Dictionary<String, String?>?) {
        if (nil != values) {
            for (key, value) in values! {
                addHeader(value: value!, forHTTPHeaderField: key)
            }
        }
    }
    
    private func processUrlParams() {
        if (nil != urlParams) {
            let url = urlRequest?.url
            var urlString:String? = url?.absoluteString
            var urlParamStr = "?"
            
            // Removing the url params set on the URL string and replace it with the
            // ones specified using addUrlParam().
            if urlString!.contains("?") {
                let substring:[Substring] = urlString!.split(separator: "?")
                let baseUrlPathString = String(substring[0])
                urlString = baseUrlPathString;
            }
            
            // count the number of params to identify when to stop adding "&"
            var index = 0
            for i in 0..<urlParams!.count { //var param:UrlParam in urlParams! {
                let param:UrlParam = urlParams![i]
                print("param \(param.name!)=\(param.value!)")
                let amp:String = (index > 0) ? "&" : ""
                urlParamStr = urlParamStr + amp + param.name! + "=" + param.value!
                index += 1
            }
            
            print(urlParamStr)
            urlString = urlString! + urlParamStr
            
            print(urlString!)
            urlRequest?.url = URL(string: urlString!)
        }
    }
    
    /**
     Executes the request
     
     - Parameters:
     - withCompletion: (Data?, HTTPURLResponse?, Error?)->Void completion block that is called when the execution completes.
     */
    public func execute(withCompletion:@escaping (Data?, HTTPURLResponse?, Error?)->Void) {
        self.onCompleteBlock = withCompletion
        self.execute()
    }
    
    
    /**
     Executes the request.
     */
    public func execute()
    {
        print(String(format:"Sending %@ request.", (urlRequest?.httpMethod!)!))
        processUrlParams()
        
        //VerboseLog(tag: "LMHttpRESTRequest::execute", info: "attempting to send request")
        self.urlSession?.dataTask(with: self.urlRequest!, completionHandler: { (data, response, error) in
            self.requestComplete(withData: data, response: response, error: error)
            
        }).resume()
    }
    
    public func description()->String {
        return String(describing: self)
    }
    
}
