//
//  NetworkManager.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 17.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import Foundation
import Alamofire

func downloadCharacters(startsWith prefix:String, completion: @escaping ([MarvelCharacter]?) -> Void) {
 
    let url = NetworkConstants.baseURL + "/characters"
    let parameters: Parameters = [
        "nameStartsWith": prefix,
        "orderBy": "name",
        "limit": 20,
        "apikey": NetworkConstants.key
    ]
    
     Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
        guard response.result.isSuccess else {
            print("Error while fetching remote rooms: \(String(describing: response.result.error))")
            completion(nil)
            return
        }
        
        if let json = response.result.value {
            var characters =  [MarvelCharacter]()
            
            
            completion(characters)
        }
        
    }
}
