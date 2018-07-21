//
//  CharacterTableViewCell.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 18.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    struct State {
        let name: String
        let thumbnail: (path: String, ext: String)
    }
    
    @IBOutlet fileprivate weak var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    
    public func configure(with state: State) {
        nameLabel.text = state.name
        if state.thumbnail.path.hasSuffix("image_not_available") {
            thumbnailImageView.image = #imageLiteral(resourceName: "question")
        } else {
            thumbnailImageView.download(image: state.thumbnail.path.secureURL() + "." + state.thumbnail.ext)
        }
        thumbnailImageView.makeRound()
    }
    
    public func animateIn() {
        thumbnailImageView.transform = .init(scaleX: 0.95, y: 0.95)
    }
    
    public func animateOut() {
        thumbnailImageView.transform = .identity
    }
    
}
