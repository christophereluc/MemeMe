//
//  DetailsViewController.swift
//  MemeMe
//
//  Created by Christopher Luc on 11/28/15.
//  Copyright © 2015 Christopher Luc. All rights reserved.
//

import UIKit

class DetailsViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme:Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView!.image = meme.memeImage
    }
}
