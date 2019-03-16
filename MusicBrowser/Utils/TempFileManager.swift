//
//  TempFileManager.swift
//  MusicBrowser
//
//  Created by John Freidrich Cinco on 3/15/19.
//  Copyright © 2019 John5. All rights reserved.
//

import Foundation


public class TempFileManager {
    // Keep an instance of the default file manager
    private let fileManager:FileManager = FileManager.default
    private var tempDir:String!
    
    public var temporaryDirPath:String! {
        get {
            return tempDir
        }
    }
    
    private init() {
        // get the application's documents directory
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        tempDir = "\(paths[0])/TEMP"
        
        do {
            // Create the temp dir
            // this way we ensure that the temp directory exists.
            var isDir:ObjCBool = true
            if (false == fileManager.fileExists(atPath: tempDir, isDirectory: &isDir)) {
                try fileManager.createDirectory(at: URL(fileURLWithPath: tempDir), withIntermediateDirectories: true, attributes: nil)
                
            }
        }
        catch let e as NSError {
            print(e.localizedFailureReason)
        }
        
    }
    
    // MARK: - Public methods
    
    /**
     Saves the data to a specified file name in a tempoary storage.
     
     - Parameters:
        - data: Data - the data to be saved.
        - name: String - the name of the file the data is to be saved in the TEMP dir.
     */
    public func saveToTempDir(data:Data, withFileName name:String)->String? {
        let filePath:String = "\(tempDir!)/\(name)"
        let fileURL:URL = URL(fileURLWithPath: filePath)
        if (!fileManager.fileExists(atPath: fileURL.path)) {
            do {
                try data.write(to: fileURL, options: .atomic)
                return filePath
            }
            catch let e as NSError {
                print(e.localizedFailureReason!)
            }
        }
        return nil
    }
    
    
    /**
     Saves the data to a specified file name in a tempoary storage.
     
     - Parameters:
        - data: Data - the data to be saved.
        - name: String - the name of the file the data is to be saved.
     */
    public func save(data:Data, withFilePath filePath:String)->Bool {
    
        let fileURL:URL = URL(fileURLWithPath: filePath)
        if (!fileManager.fileExists(atPath: fileURL.path)) {
            do {
                try data.write(to: fileURL, options: .atomic)
                return true
            }
            catch let e as NSError {
                print(e.localizedFailureReason!)
            }
        }
        return false
    }
    
    
    
    /**
     Deletes the file
     
     - Parameters:
        - filePath: String - path to the file to remove.
     */
    public func delete(filePath:String)->Bool {
        do {
            if (fileManager.fileExists(atPath: filePath)) {
                try fileManager.removeItem(atPath: filePath)
                return true
            }
        }
        catch let e as NSError {
            print(e.localizedFailureReason)
        }
        return false
    }
    
    /**
     Wrapper method for checking existence of file
     */
    public func fileExists(atPath path:String)->Bool {
        return fileManager.fileExists(atPath:path)
    }
    
    
    // MARK: - Singleton implementation
    private static var INSTANCE:TempFileManager!
    public static var sharedInstance:TempFileManager! {
        get {
            if nil == INSTANCE {
                INSTANCE = TempFileManager()
            }
            return INSTANCE
        }
    }
    
}
