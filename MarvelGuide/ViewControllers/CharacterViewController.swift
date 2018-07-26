//
//  CharacterViewController.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 18.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController {

    public var character: MarvelCharacter?
    private var connectedCharacters = [(character: MarvelCharacter, event: String)]()
    private var charactersCell: ConnectedCharactersTableViewCell?
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCells()
        
        navigationItem.title = character?.name
        let shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 9)!, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItem = shareButton
        
        MarvelAPI.downloadByOneCharactersConnected(with: character!) { characterEventPairs in
            guard let characterEventPairsNotNil = characterEventPairs else {
                self.charactersCell?.cleanData(with: "Fail during characters loading")
                self.charactersCell?.stopLoadAnimating()
                return
            }
            guard characterEventPairsNotNil.count != 0 else{
                self.charactersCell?.cleanData(with: "No connected characters")
                self.charactersCell?.stopLoadAnimating()
                return
            }
            self.connectedCharacters = characterEventPairsNotNil.filter {
                $0.character.id != self.character?.id
            }
            self.charactersCell?.reloadData()
            self.charactersCell?.stopLoadAnimating()
        }
            
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: String(describing: ThumbnailTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ThumbnailTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: DescriptionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DescriptionTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: ConnectedCharactersTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConnectedCharactersTableViewCell.self))
    }
    
    @objc func share() {
        if let charecterNotNil = character {
            let activityVC = UIActivityViewController(activityItems: ["marvelguide://\(charecterNotNil.id)"], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
}

// MARK:- TableView section
extension CharacterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let characterNotNil = character {
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ThumbnailTableViewCell.self)) as? ThumbnailTableViewCell {
                    let state = ThumbnailTableViewCell.State(thumbnail: characterNotNil.thumbnail)
                    cell.configure(with: state)
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DescriptionTableViewCell.self)) as? DescriptionTableViewCell {
                    if let description = characterNotNil.description {
                        print("?" + description + "?")
                        let state = DescriptionTableViewCell.State(description: description)
                        cell.configure(with: state)
                        return cell
                    } else {
                        let state = DescriptionTableViewCell.State(description: "Sorry. Character description is empty")
                        cell.configure(with: state)
                        return cell
                    }
                }
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConnectedCharactersTableViewCell.self)) as? ConnectedCharactersTableViewCell {
                    cell.setDelegateAndDataSourse(view: self)
                    charactersCell = cell
                    return cell
                }
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}


//MARK: -CollectionView section
extension CharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return connectedCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ConnectedCharacterCollectionViewCell.self), for: indexPath) as? ConnectedCharacterCollectionViewCell else { fatalError("Fatal error") }
        let characterEvent = connectedCharacters[indexPath.row]
        let state = ConnectedCharacterCollectionViewCell.State(name: characterEvent.character.name, thumbnail: characterEvent.character.thumbnail, event: characterEvent.event)
        cell.configure(with: state)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cvc = CharacterViewController(nibName: "CharacterViewController", bundle: nil)
        cvc.character = connectedCharacters[indexPath.row].character
        navigationController?.pushViewController(cvc, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? ConnectedCharacterCollectionViewCell {
                cell.animateIn()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? ConnectedCharacterCollectionViewCell {
                cell.animateOut()
            }
        }
    }
    
}
