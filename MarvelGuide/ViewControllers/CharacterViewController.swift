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
    private var cv: UICollectionView?
    private var charactersCell: ConnectedCharactersTableViewCell?
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCells()
        
        MarvelAPI.downloadByOneCharactersConnected(with: character!) { characterEventPair in
            self.connectedCharacters.append(characterEventPair)
            self.charactersCell?.reloadData()
        }
        
        connectedCharacters = [(character: character, event: "aaa"), (character: character, event: "aaa"),(character: character, event: "aaa"), (character: character, event: "aaa")] as! [(character: MarvelCharacter, event: String)]
        
        navigationItem.title = character?.name
        
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: String(describing: ThumbnailTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ThumbnailTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: DescriptionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DescriptionTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: ConnectedCharactersTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConnectedCharactersTableViewCell.self))
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
    
    
}
