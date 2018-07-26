//
//  ConnectedCharactersTableViewCell.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 20.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class ConnectedCharactersTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var spinner: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    // MARK: - BaseClass
    
    override func awakeFromNib() {
        startLoadAnimating()
    }
    
    // MARK: - Internal methods
    
    func setDelegateAndDataSourse(view: CharacterViewController) {
        collectionView.delegate = view
        collectionView.dataSource = view
        
        collectionView.register(UINib(nibName: String(describing: ConnectedCharacterCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ConnectedCharacterCollectionViewCell.self))
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func cleanData(with text: String) {
        titleLabel.text = text
        collectionView.frame.size.height = 0
    }
    
    func startLoadAnimating() {
        spinner.startAnimating()
    }
    
    func stopLoadAnimating() {
        spinner.stopAnimating()
    }
}

