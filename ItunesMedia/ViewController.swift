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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        requestPlaylist(playlistName: "hot-tracks")
    }


}

// MARK: - Request

extension ViewController {
    func loadDataWithURL(_ url: URL?, completion: @escaping (_ results: [Playlist]?, _ error: Error?) -> ()) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        if let url = url {
            session.dataTask(with: url, completionHandler: { (response, data, error) in
                DispatchQueue.main.async(execute: { () -> Void in
                    if error != nil {
                        completion(nil, error)
                    } else if let response = response {
                        do {
                            if let json = try? JSONSerialization.jsonObject(with: response, options: []) {
                                if let jsonDict = json as? [String: Any] {
                                    if let feedDict = jsonDict["feed"] as? [String: Any], let resultsDict = feedDict["results"] as? [[String: Any]] {
                                        let data = try JSONSerialization.data(withJSONObject: resultsDict, options: .prettyPrinted)
                                        let playlists = try JSONDecoder().decode([Playlist].self, from: data)
                                        
                                        completion(playlists, nil)
                                    }
                                }
                            }
                        } catch( let error) {
                            print(error)
                        }
                    } else {
                        completion(nil, NSError(domain: "ErrorDomain", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Couldn't load Data"]))
                    }
                    session.finishTasksAndInvalidate()
                })
            }).resume()
        } else {
            completion(nil, NSError(domain: "ErrorDomain", code: -2, userInfo: [ NSLocalizedDescriptionKey: "Data URL not found."]))
        }
    }
    
    @objc func requestPlaylist(playlistName: String) {
        let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/\(playlistName)/all/100/explicit.json")
        loadDataWithURL(url) { (results, error) in
            if let resultsDict = results {
                self.playlists = resultsDict
                self.tableView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Error", message: "Sorry! There was an error!!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                let reloadAction = UIAlertAction(title: "Fetch", style: .default, handler: { (action) in
                    self.requestPlaylist(playlistName: "")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath)
        cell.textLabel?.text = playlist.name
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

