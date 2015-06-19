//
//  Meme.swift
//  MemeMe
//
//  Created by Julius Danek on 18.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var bottomText: String
    var topText: String
    var image: UIImage
    var memedImage: UIImage
    
    init (bottomText: String, topText: String, image: UIImage, memedImage: UIImage) {
        self.bottomText = bottomText
        self.topText = topText
        self.image = image
        self.memedImage = memedImage
    }
}