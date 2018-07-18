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

func downloadCharacters(startsWith prefix:String, completion: @escaping ([MarvelCharacter]) -> Void) {
 
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
            print(json)
            for (_, subjson) in json["data"]["results"] {
                let thumbnail = subjson["thumbnail"]
                if let id = subjson["id"].int, let name = subjson["name"].string, let disc = subjson["discription"].string, let path = thumbnail["path"].string, let ext = thumbnail["extension"].string {
                    characters.append(MarvelCharacter(id: id, name: name, description: disc == "" ? nil : disc, thumbnail: (path, ext)))
                }
            }
            completion(characters)
            
        case .failure(let error):
            print(error)
        }
        
    }
}
