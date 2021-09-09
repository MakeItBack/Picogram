//
//  DetailViewController.swift
//  Picogram
//
//  Created by Bear Cahill on 1/2/20.
//  Copyright © 2020 Bear Cahill. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var ivImage: UIImageView!
    
    var detailItem: PicogramItem?
    
    func configureView() {
        if let detail = detailItem {
            ivImage.image = detail.image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }


}

