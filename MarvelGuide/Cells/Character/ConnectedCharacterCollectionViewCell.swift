//
//  ConnectedCharacterCollectionViewCell.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 20.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class ConnectedCharacterCollectionViewCell: UICollectionViewCell {

    struct State {
        let name: String
        let thumbnail: (path: String, ext: String)
        let event: String
    }
    
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var eventLabel: UILabel!
    @IBOutlet fileprivate weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
    
    public func configure(with state: State) {
        nameLabel.text = state.name
        eventLabel.text = state.event
        if state.thumbnail.path.hasSuffix("image_not_available") {
            thumbnailImageView.image = #imageLiteral(resourceName: "question")
        } else {
            thumbnailImageView.download(image: state.thumbnail.path.secureURL() + "." + state.thumbnail.ext)
        }
        thumbnailImageView.makeRound()
    }
    
    public func animateIn() {
        thumbnailImageView.transform = .init(scaleX: 0.95, y: 0.95)
        self.layer.borderColor = UIColor.yellow.cgColor
    }
    
    public func animateOut() {
        thumbnailImageView.transform = .identity
        self.layer.borderColor = UIColor.white.cgColor
    }
    
}
