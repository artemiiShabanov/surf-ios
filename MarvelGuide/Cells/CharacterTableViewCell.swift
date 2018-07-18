//
//  CharacterTableViewCell.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 18.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    public static let reuseId = "CharacterTableViewCell_reuseId"
    
    public func configure(name: String) {
        nameLabel.text = name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
