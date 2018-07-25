//
//  NetworkManager.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 17.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CryptoSwift

struct MarvelAPI {
    
    static func downloadCharacters(startsWith prefix:String, completion: @escaping ([MarvelCharacter]?) -> Void) {
     
        let url = NetworkConstants.baseURL + "/characters"
        let ts = Date().toMillisString()
        let parameters: Parameters = [
            "nameStartsWith": prefix,
            "orderBy": "name",
            "limit": 20,
            "ts": ts,
            "apikey": NetworkConstants.publicKey,
            "hash": "\(ts)\(NetworkConstants.privateKey)\(NetworkConstants.publicKey)".md5()
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var characters =  [MarvelCharacter]()
                for (_, subjson) in json["data"]["results"] {
                    let thumbnail = subjson["thumbnail"]
                    if let id = subjson["id"].int, let name = subjson["name"].string, let disc = subjson["description"].string, let path = thumbnail["path"].string, let ext = thumbnail["extension"].string {
                        characters.append(MarvelCharacter(id: id, name: name, description: disc == "" ? nil : disc, thumbnail: (path, ext)))
                    }
                }
                DispatchQueue.main.async {
                    completion(characters)
                }
                
            case .failure(_):
                completion(nil)
            }
            
        }
    }
    
    //calls completion with nil when outer request is finished
    static func downloadByOneCharactersConnected(with character: MarvelCharacter, completion: @escaping ( [(character: MarvelCharacter, event: String)]? ) -> Void) {
        
        //First getting events for character Id
        let url = NetworkConstants.baseURL + "/characters/\(character.id)/events"
        let ts = Date().toMillisString()
        let parameters: Parameters = [
            "limit": 5,
            "ts": ts,
            "apikey": NetworkConstants.publicKey,
            "hash": "\(ts)\(NetworkConstants.privateKey)\(NetworkConstants.publicKey)".md5()
        ]
        
        var resultCharacters = [(character: MarvelCharacter, event: String)]()
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let events = json["data"]["results"].prefix(5)
                if events.isEmpty {
                    completion(resultCharacters)
                    return
                }
                for (i, subjson) in events {
                    let characters = subjson["characters"]["items"].prefix(5)
                    for (j, subSubjson) in characters {
                        downloadCharacterBy(uri: subSubjson["resourceURI"].stringValue) { character in
                            if let characterNotNil = character {
                                resultCharacters.append((character: characterNotNil, event: subjson["title"].stringValue))
                            }
                            if (Int(i) == events.count - 1) && (Int(j) == characters.count - 1) {
                                completion(resultCharacters)
                            }
                        }
                    }
                }
                
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    static private func downloadCharacterBy(uri: String, completion: @escaping (MarvelCharacter?) -> Void) {
        let ts = Date().toMillisString()
        let parameters: Parameters = [
            "ts": ts,
            "apikey": NetworkConstants.publicKey,
            "hash": "\(ts)\(NetworkConstants.privateKey)\(NetworkConstants.publicKey)".md5()
        ]
        
        Alamofire.request(uri, method: .get, parameters: parameters).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let characters = json["data"]["results"]
                if characters.isEmpty {
                    completion(nil)
                }
                for (_, subjson) in characters {
                    let thumbnail = subjson["thumbnail"]
                    if let id = subjson["id"].int, let name = subjson["name"].string, let disc = subjson["description"].string, let path = thumbnail["path"].string, let ext = thumbnail["extension"].string {
                        completion(MarvelCharacter(id: id, name: name, description: disc == "" ? nil : disc, thumbnail: (path, ext)))
                    }
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    static func downloadCharacterBy(id: Int, completion: @escaping (MarvelCharacter?) -> Void) {
        
        let url = NetworkConstants.baseURL + "/characters/" + String(id)
        downloadCharacterBy(uri: url, completion: completion)
    }
}
