//
//  NetworkManager.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 17.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    public var delegate: NetworkDelegate
    
    init(delegate: NetworkDelegate) {
        self.delegate = delegate
    }
    
    
}
