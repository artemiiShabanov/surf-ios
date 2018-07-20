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
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate weak var charactersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charactersTableView.delegate = self
        charactersTableView.dataSource = self
        
        if let charcterNotNil = character {
            navigationItem.title = charcterNotNil.name
            
            if let description = charcterNotNil.description {
                descriptionLabel.text = description
            } else {
                descriptionLabel.text = "Sorry. Character description is empty"
            }
            
            let thumbnail = charcterNotNil.thumbnail
            if thumbnail.path.hasSuffix("image_not_available") {
                thumbnailImageView.image = #imageLiteral(resourceName: "question")
            } else {
                thumbnailImageView.download(image: thumbnail.path.secureURL() + "." + thumbnail.ext)
            }
            
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.size.width / 2
            thumbnailImageView.clipsToBounds = true
            thumbnailImageView.layer.borderWidth = 1
            thumbnailImageView.layer.borderColor = UIColor.white.cgColor
            
        
            
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: charactersTableView.bottomAnchor).isActive = true
            
            //TODO: tableview
        }
    }
}

// MARK: tableView section
extension CharacterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectedCharacters.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConnectedCharacterTableViewCell.reuseId) as? ConnectedCharacterTableViewCell
            else { fatalError("Fatal error") }
        let characterEvent = connectedCharacters[indexPath.row]
        cell.configure(name: characterEvent.character.name, thumbnail: characterEvent.character.thumbnail, event: characterEvent.event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cvc = CharacterViewController(nibName: "CharacterViewController", bundle: nil)
//        cvc.character = connectedCharacters[indexPath.row]
//        navigationController?.pushViewController(cvc, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}
