//
//  ImageCell.swift
//  SampleImageUpload
//
//  Created by Amit on 13/04/19.
//  Copyright © 2019 AmitG. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        self.imgView.layer.borderColor = UIColor.black.cgColor
        self.imgView.layer.cornerRadius = 10
    }
}
