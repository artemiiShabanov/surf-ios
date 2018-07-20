//
//  DescriptionTableViewCell.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 20.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    struct State {
        let description: String
    }
    
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    
    public func configure(with state: State) {
        descriptionLabel.text = state.description
    }
    
}
