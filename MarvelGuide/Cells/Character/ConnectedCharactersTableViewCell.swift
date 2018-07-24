//
//  ConnectedCharactersTableViewCell.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 20.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class ConnectedCharactersTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var spinner: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        startLoadAnimating()
    }
    
    func setDelegateAndDataSourse(view: CharacterViewController) {
        collectionView.delegate = view
        collectionView.dataSource = view
        
        collectionView.register(UINib(nibName: String(describing: ConnectedCharacterCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ConnectedCharacterCollectionViewCell.self))
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func reloadDataForEmptyState() {
        collectionView.frame = CGRect(x:0, y: 0, width:0, height:0)
        titleLabel.text = "No connected characters"
    }
    
    func startLoadAnimating() {
        spinner.startAnimating()
    }
    
    func stopLoadAnimating() {
        spinner.stopAnimating()
    }
}

