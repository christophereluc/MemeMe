//
//  Meme.swift
//  MemeMe
//
//  Created by Christopher Luc on 9/25/15.
//  Copyright © 2015 Christopher Luc. All rights reserved.
//

import UIKit

class Meme {
    
    var topText: String
    var bottomText: String
    var image: UIImage
    var memeImage: UIImage
    
    init(topText: String, bottomText: String, image: UIImage, memeImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memeImage = memeImage
    }

}