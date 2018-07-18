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
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        downloadCharacters(startsWith: "doctor") {characters1 in
            self.characters = characters1
            self.tableView.reloadData()
        }
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
        cell.configure(name: characters[indexPath.row].name)
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
}
