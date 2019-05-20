//
//  FeedTableViewController.swift
//  ItunesMedia
//
//  Created by Leonardo Reis on 20/05/19.
//  Copyright © 2019 Leonardo Reis. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }

}

// MARK: - Navigation

extension FeedTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mediaType" {
            let mediaViewController = segue.destination as? ViewController
            mediaViewController?.urlString = sender as! String
        }
    }
}

// MARK: - Table view

extension FeedTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var mediaTypeURL = ""
        switch indexPath.section {
        case 0:
            mediaTypeURL = "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/20/explicit.json"
            break
        case 1:
            mediaTypeURL = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-apps-we-love/all/20/explicit.json"
            break
        case 2:
            mediaTypeURL = "https://rss.itunes.apple.com/api/v1/us/music-videos/top-music-videos/all/20/explicit.json"
            break
        default: break
        }
        
        self.performSegue(withIdentifier: "mediaType", sender: mediaTypeURL)
    }
}

