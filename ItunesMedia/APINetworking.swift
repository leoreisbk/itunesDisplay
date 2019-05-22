//
//  APINetworking.swift
//  ItunesMedia
//
//  Created by Leonardo Reis on 22/05/19.
//  Copyright © 2019 Leonardo Reis. All rights reserved.
//

import UIKit

class APINetworking: NSObject {

	static let shared = APINetworking()
	
	private override init(){}
	
	func loadDataWithURL(_ url: URL?, completion: @escaping (_ response: Data?, _ error: Error?) -> ()) {
		let session = URLSession(configuration: URLSessionConfiguration.default)
		
		if let imageURL = url {
			session.dataTask(with: imageURL, completionHandler: { (response, data, error) in
				DispatchQueue.main.async(execute: { () -> Void in
					if error != nil {
						completion(nil, error)
					} else if let response = response {
						completion(response, nil)
					} else {
						completion(nil, NSError(domain: "ErrorDomain", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Couldn't load object"]))
					}
					session.finishTasksAndInvalidate()
				})
			}).resume()
		} else {
			completion(nil, NSError(domain: "ErrorDomain", code: -2, userInfo: [ NSLocalizedDescriptionKey: "object URL not found."]))
		}
	}
	
	func loadLibraries(_ url: URL?, completion: @escaping (_ results: [Playlist]?, _ title: String?, _ error: Error?) ->  ()) {
		loadDataWithURL(url) { (results, error) in
			if error != nil {
				completion(nil, nil, error)
			} else if let results = results {
				do {
					if let json = try? JSONSerialization.jsonObject(with: results, options: []) {
						if let jsonDict = json as? [String: Any] {
							if let feedDict = jsonDict["feed"] as? [String: Any], let title = feedDict["title"] as? String, let resultsDict = feedDict["results"] as? [[String: Any]] {
								let data = try JSONSerialization.data(withJSONObject: resultsDict, options: .prettyPrinted)
								let playlists = try JSONDecoder().decode([Playlist].self, from: data)
								
								completion(playlists, title, nil)
							}
						}
					}
				} catch( let error) {
					completion(nil, nil, error)
				}
			}
		}
	}
}
