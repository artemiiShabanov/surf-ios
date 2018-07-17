//
//  NetworkDelegate.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 17.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import Foundation

protocol NetworkDelegate {
    func didReceive(characters: String?)
    func didReceive(characterInfo: Bool)
}
