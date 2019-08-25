//
//  ViewController.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 16.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var spinner: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var characters = [MarvelCharacter]()
    public var initialCharacter: MarvelCharacter? //is not nil when app is launched throw url
    private var lastRequestId = 0
    
    // MARK: - BaseClass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = "Characters2"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CharacterTableViewCell.self))
        
        searchBar.delegate = self
        
        spinner.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //if app is launched throw url with character id
        if let character = initialCharacter {
            initialCharacter = nil
            push(with: character)
        }
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self)) as? CharacterTableViewCell
            else { fatalError("Fatal error") }
        let character = characters[indexPath.row]
        let cellState = CharacterTableViewCell.State(name: character.name, thumbnail: character.thumbnail)
        cell.configure(with: cellState)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(with: characters[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as?  CharacterTableViewCell {
            cell.animateIn()
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as?  CharacterTableViewCell {
            cell.animateOut()
        }
    }
    
}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //throttling magic
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(onSearch), object: nil)
        self.perform(#selector(onSearch), with: nil, afterDelay: 0.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
}

// MARK: - Private methods

private extension MainViewController {
    
    func push(with character: MarvelCharacter) {
        let cvc = CharacterViewController(nibName: "CharacterViewController", bundle: nil)
        cvc.character = character
        navigationController?.pushViewController(cvc, animated: true)
    }
    
    @objc func onSearch() {
        tableView.setContentOffset(.zero, animated: true)
        if let searchText = searchBar.text {
            if searchText != "" {
                spinner.startAnimating()
                lastRequestId += 1
                let requestId = lastRequestId
                MarvelAPI.downloadCharacters(startsWith: searchText) { characters in
                    if requestId != self.lastRequestId {
                        return
                    }
                    guard let charactersNotNil = characters else{
                        self.hideTableWith(text: "Oops! Some problems with internet connection")
                        return
                    }
                    if charactersNotNil.isEmpty{
                        self.hideTableWith(text: "Sorry. There are no characters starts like \"\(searchText)\"")
                        return
                    }
                    self.characters = charactersNotNil
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









