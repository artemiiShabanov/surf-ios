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
                
            case .failure(let error):
                print(error)
                completion(nil)
            }
            
        }
    }
    
    //TODO: array result + 2nd complition
    //calls completion with nil when outer request is finished
    static func downloadByOneCharactersConnected(with character: MarvelCharacter, completion: @escaping ((character: MarvelCharacter, event: String)?) -> Void) {
        
        //First getting events for character Id
        let url = NetworkConstants.baseURL + "/characters/\(character.id)/events"
        let ts = Date().toMillisString()
        let parameters: Parameters = [
            "limit": 5,
            "ts": ts,
            "apikey": NetworkConstants.publicKey,
            "hash": "\(ts)\(NetworkConstants.privateKey)\(NetworkConstants.publicKey)".md5()
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let events = json["data"]["results"]
                if events.isEmpty {
                    completion((MarvelCharacter(id: 0, name: "", description: nil, thumbnail: ("", "")), ""))
                }
                for (_, subjson) in events {
                    var i = 5
                    for (_, subSubjson) in subjson["characters"]["items"] {
                        downloadCharacterBy(uri: subSubjson["resourceURI"].stringValue, with: subjson["title"].stringValue, completion: completion)
                        i -= 1
                        if i == 0 { break }
                    }
                }
                completion(nil)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static private func downloadCharacterBy(uri: String, with event: String, completion: @escaping ((character: MarvelCharacter, event: String)) -> Void) {
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
                //print(json)
                for (_, subjson) in json["data"]["results"] {
                    let thumbnail = subjson["thumbnail"]
                    if let id = subjson["id"].int, let name = subjson["name"].string, let disc = subjson["description"].string, let path = thumbnail["path"].string, let ext = thumbnail["extension"].string {
                        completion((MarvelCharacter(id: id, name: name, description: disc == "" ? nil : disc, thumbnail: (path, ext)), event))
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
