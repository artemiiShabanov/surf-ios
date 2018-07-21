//
//  CharacterEventPair.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 21.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import Foundation

struct CharacterEventPair {
    let character: MarvelCharacter
    let event: String
}

extension CharacterEventPair: Hashable {
    static func == (lhs: CharacterEventPair, rhs: CharacterEventPair) -> Bool {
        return lhs.character.id == rhs.character.id
    }
    
    public var hashValue: Int {
        return self.character.id.hashValue
    }
}
