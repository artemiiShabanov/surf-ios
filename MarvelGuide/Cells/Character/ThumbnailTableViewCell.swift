//
//  ThumbnailTableViewCell.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 20.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class ThumbnailTableViewCell: UITableViewCell {

    // MARK: - Additional struct
    
    struct State {
        let thumbnail: (path: String, ext: String)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var thumbnailImageView: UIImageView!
    
    // MARK: - Internal methods
    
    public func configure(with state: State) {
        if state.thumbnail.path.hasSuffix("image_not_available") {
            thumbnailImageView.image = #imageLiteral(resourceName: "question")
        } else {
            thumbnailImageView.download(image: state.thumbnail.path.secureURL() + "." + state.thumbnail.ext)
        }
        thumbnailImageView.makeRound()
    }
    
}
