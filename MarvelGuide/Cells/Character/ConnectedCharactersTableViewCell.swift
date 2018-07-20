//
//  ConnectedCharactersTableViewCell.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 20.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class ConnectedCharactersTableViewCell: UITableViewCell {

    @IBOutlet public weak var collectionView: UICollectionView!
    
    func setDelegateAndDataSourse(view: CharacterViewController) {
        collectionView.delegate = view
        collectionView.dataSource = view
        
        collectionView.register(ConnectedCharacterCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ConnectedCharacterCollectionViewCell.self))
        
        collectionView.reloadData()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

