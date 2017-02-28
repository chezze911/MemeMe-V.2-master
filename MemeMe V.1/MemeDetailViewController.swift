//
//  MemeDetailViewController.swift
//  MemeMe V.1
//
//  Created by Chi Nguyen on 2017/02/22.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController
: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let meme = meme {
            imageView.image = meme.memedImage
        }
    }
}

