//
//  ViewController.swift
//  MusicBrowser
//
//  Created by John Freidrich Cinco on 3/14/19.
//  Copyright © 2019 John5. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var trackTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lastDate = UserDefaults.standard.string(forKey: "lastVisitedDate")
        self.navigationController?.navigationBar.topItem?.title = lastDate ?? ""
        
        // set the datasource to the model
        self.trackTableView.dataSource = TrackListModel.sharedInstance
        self.trackTableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        TrackListModel.sharedInstance.load()
        
        // Check if the last screen was the detail screen
        let lastScreen = UserDefaults.standard.string(forKey: "lastScreen")
        if ("DETAIL_SCREEN" == lastScreen) {
            // launch the detail screen
            performSegue(withIdentifier: "trackDetail", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set user default for this screen
        UserDefaults.standard.set("LIST_SCREEN", forKey: "lastScreen")
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:TrackCell = tableView.cellForRow(at: indexPath) as! TrackCell
        TrackListModel.sharedInstance.setSelectedItemIndex(index:indexPath.row)
        cell.isSelected = false
        // launch the detail screen
        performSegue(withIdentifier: "trackDetail", sender: cell)
    }
    
   

}


