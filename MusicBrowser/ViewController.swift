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
        
        // set the datasource to the model
        self.trackTableView.dataSource = TrackListModel.sharedInstance
        self.trackTableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        TrackListModel.sharedInstance.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:TrackCell = tableView.cellForRow(at: indexPath) as! TrackCell
        TrackListModel.sharedInstance.setSelectedItemIndex(index:indexPath.row)
        // launch the detail screen
        performSegue(withIdentifier: "trackDetail", sender: cell)
    }
    
   

}

