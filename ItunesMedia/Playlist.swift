//
//  Playlist.swift
//  ItunesMedia
//
//  Created by Leonardo Reis on 19/05/19.
//  Copyright © 2019 Leonardo Reis. All rights reserved.
//

import UIKit


//"id": "pl.426a1044619f47d6b1f86b3f79ecf857",
//"name": "#OnRepeat",
//"kind": "playlist",
//"artworkUrl100": "https://is3-ssl.mzstatic.com/image/thumb/Features113/v4/9b/9a/3e/9b9a3efe-597c-170d-2f57-39c29f4d4431/source/200x200cc.png",
//"genres": [],
//"url": "https://itunes.apple.com/us/playlist/onrepeat/pl.426a1044619f47d6b1f86b3f79ecf857?app=music"

struct Playlist: Decodable {
    let identifier: String
    let name: String
	let artistName: String
    let kind: String
    let artworkURL: String
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case kind
        case artworkURL = "artworkUrl100"
        case url
		case artistName
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try values.decode(String.self, forKey: .identifier)
        name = try values.decode(String.self, forKey: .name)
        kind = try values.decode(String.self, forKey: .kind)
        artworkURL = try values.decode(String.self, forKey: .artworkURL)
        url = try values.decode(String.self, forKey: .url)
		artistName = try values.decode(String.self, forKey: .artistName)
    }
}
