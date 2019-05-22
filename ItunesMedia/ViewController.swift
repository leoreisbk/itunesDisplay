//
//  ViewController.swift
//  ItunesMedia
//
//  Created by Leonardo Reis on 19/05/19.
//  Copyright © 2019 Leonardo Reis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var playlists: [Playlist] = []
    var urlString: String = ""
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPlaylist(urlString: urlString)
    }
}

// MARK: - Request

extension ViewController {
    @objc func requestPlaylist(urlString: String) {
        let url = URL(string:urlString)
		APINetworking.shared.loadLibraries(url) { (results, title, error) in
            if let resultsDict = results {
                self.playlists = resultsDict
				self.title = title
                self.tableView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Error", message: "Sorry! There was an error!!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                let reloadAction = UIAlertAction(title: "Fetch", style: .default, handler: { (action) in
                    self.requestPlaylist(urlString: urlString)
                })
                alertController.addAction(okAction)
                alertController.addAction(reloadAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Table view data source

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlist = playlists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlayListTableViewCell
        cell.setupCell(playlist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        let urlString = playlist.url
        self.performSegue(withIdentifier: "showWebView", sender: urlString)
    }
    
}

// MARK: - Navigation

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            let contentWebViewController = segue.destination as? ContentWebViewController
            contentWebViewController?.urlString = sender as! String
        }
    }
}

