//
//  PlayListTableViewCell.swift
//  ItunesMedia
//
//  Created by Leonardo Reis on 22/05/19.
//  Copyright © 2019 Leonardo Reis. All rights reserved.
//

import UIKit

class PlayListTableViewCell: UITableViewCell {
	@IBOutlet var imageViewCell: UIImageView!
	@IBOutlet var name: UILabel!
	@IBOutlet var artistName: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
    }
}

extension PlayListTableViewCell {
	func setupCell(_ playlist: Playlist) {
		name.text = playlist.name
		artistName.text = playlist.artistName
		
		let url = URL(string: playlist.artworkURL)
		imageViewCell.loadImageWithURL(url)
	}
}

extension UIImageView {
	func loadImageWithURL(_ url: URL?) {
		APINetworking.shared.loadDataWithURL(url) { (response, error) in
			if let response = response, let image = UIImage(data: response) {
				self.image = image
			}
		}
	}
}
