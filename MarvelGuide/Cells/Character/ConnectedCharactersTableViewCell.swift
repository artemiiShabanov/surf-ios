//
//  ConnectedCharactersTableViewCell.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 20.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class ConnectedCharactersTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var isLonelyLabel: UILabel!
    @IBOutlet fileprivate weak var spinner: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        isLonelyLabel.isHidden = true
    }
    
    func setDelegateAndDataSourse(view: CharacterViewController) {
        collectionView.delegate = view
        collectionView.dataSource = view
        
        collectionView.register(UINib(nibName: String(describing: ConnectedCharacterCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ConnectedCharacterCollectionViewCell.self))
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func startLoadAnimating() {
        isLonelyLabel.isHidden = true
        spinner.startAnimating()
    }
    
    func stopLoadAnimating() {
        spinner.stopAnimating()
//        if collectionView.numberOfItems(inSection: 0) == 0 {
//            isLonelyLabel.isHidden = false
//        }
    }
}

