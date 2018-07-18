//
//  ViewController.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 16.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var tableView: UITableView!
    private var characters = [MarvelCharacter]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: CharacterTableViewCell.reuseId)
        
        searchBar.delegate = self
        
    }

}



// MARK: tableView section
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseId) as? CharacterTableViewCell
            else { fatalError("Fatal error") }
        let character = characters[indexPath.row]
        cell.configure(name: character.name, thumbnail: character.thumbnail.path)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //adding word to realm
//        let word = Word()
//        word.word = filteredWords[indexPath.row]
//        word.definition = dict[word.word]
//        if !alreadyHaveWords.contains(word.word) {
//            try? realm.write {
//                realm.add(word)
//            }
//            self.dismiss(animated: true, completion: nil)
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

// MARK: searchBar section
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        downloadCharacters(startsWith: searchBar.text!) {characters1 in
            self.characters = characters1
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        downloadCharacters(startsWith: searchBar.text!) {characters1 in
            self.characters = characters1
            self.tableView.reloadData()
        }
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        downloadCharacters(startsWith: searchText) {characters1 in
//            self.characters = characters1
//            self.tableView.reloadData()
//        }
//    }
}
