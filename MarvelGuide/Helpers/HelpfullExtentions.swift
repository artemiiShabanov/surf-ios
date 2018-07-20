//
//  HelpfullExtentions.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 18.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


extension Date {
    func toMillisString() -> String {
        return self.timeIntervalSince1970.description
    }
}

extension UIImageView {
    func download(image url: String) {
        guard let imageURL = URL(string:url) else {
            return
        }
        self.kf.setImage(with: ImageResource(downloadURL: imageURL))
    }
    
    func makeRound() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
}

extension String {
    func secureURL() -> String {
        if self.hasPrefix("http://") {
            let range = self.range(of: "http://")
            var newPath = self
            newPath.removeSubrange(range!)
            return "https://" + newPath
        } else {
            return self
        }
    }
}
