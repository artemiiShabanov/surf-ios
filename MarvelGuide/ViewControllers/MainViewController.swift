//
//  ViewController.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 16.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet fileprivate weak var spinner: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var tableView: UITableView!
    private var characters = [MarvelCharacter]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = "Characters"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil), forCellReuseIdentifier: CharacterTableViewCell.reuseId)
        
        searchBar.delegate = self
        
        spinner.stopAnimating()
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
        cell.configure(name: character.name, thumbnail: character.thumbnail)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cvc = CharacterViewController(nibName: "CharacterViewController", bundle: nil)
        cvc.character = characters[indexPath.row]
        navigationController?.pushViewController(cvc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}

// MARK: searchBar section
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        if let searchText = searchBar.text {
//            if searchText != "" {
//                downloadCharacters(startsWith: searchText) { characters in
//                    self.characters = characters
//                    self.tableView.reloadData()
//                    self.tableView.isHidden = false
//                }
//            } else {
//                tableView.isHidden = true
//            }
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if searchText != "" {
                spinner.startAnimating()
                MarvelAPI.downloadCharacters(startsWith: searchText) { optCharacters in
                    guard let characters = optCharacters else{
                        self.hideTableWith(text: "Oops! Some problems with internet connection")
                        return
                    }
                    if characters.isEmpty{
                        self.hideTableWith(text: "Sorry. There are no characters starts like \"\(searchText)\"")
                        return
                    }
                    self.characters = characters
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.spinner.stopAnimating()
                }
            } else {
                statusLabel.text = "Start typing"
                tableView.isHidden = true
            }
        }
    }
    
    func hideTableWith(text: String) {
        self.tableView.isHidden = true
        self.statusLabel.text = text
        self.spinner.stopAnimating()
    }
}
















