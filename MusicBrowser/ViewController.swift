//
//  ViewController.swift
//  MusicBrowser
//
//  Created by John Freidrich Cinco on 3/14/19.
//  Copyright © 2019 John5. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, TrackListModelDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var trackTableView: UITableView!
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // display last date on tab bar
        let lastDate = UserDefaults.standard.string(forKey: "lastVisitedDate")
        self.navigationController?.navigationBar.topItem?.title = lastDate ?? ""
        
        // set the datasource to the model
        self.trackTableView.dataSource = TrackListModel.sharedInstance
        self.trackTableView.delegate = self
       
        
        TrackListModel.sharedInstance.delegate = self
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
        self.hideSpinnerView()
        self.searchBar.delegate = self
        // Set user default for this screen
        UserDefaults.standard.set("LIST_SCREEN", forKey: "lastScreen")
    }
    
    // MARK: - helper methods
    private func showSpinnerView() {
        self.spinnerView.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func hideSpinnerView() {
        self.spinnerView.isHidden = true
        self.activityIndicator.startAnimating()
    }
    
    
    // MARK: - TrackListModelDelegate
    
    func onData() {
        self.trackTableView.reloadData()
        self.hideSpinnerView()
    }
    
    
    // MARK: - TableView delegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:TrackCell = tableView.cellForRow(at: indexPath) as! TrackCell
        TrackListModel.sharedInstance.setSelectedItemIndex(index:indexPath.row)
        cell.isSelected = false
        // launch the detail screen
        performSegue(withIdentifier: "trackDetail", sender: cell)
    }
    
   

    // MARK: - UISearchBar delegate
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        TrackListModel.sharedInstance.queryServer(withTerm: searchBar.text, country: "au", media: "all")
        self.showSpinnerView()
    }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        return true
    }
    
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


