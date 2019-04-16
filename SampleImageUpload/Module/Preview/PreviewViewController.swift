//
//  PreviewViewController.swift
//  SampleImageUpload
//
//  Created by Amit on 14/04/19.
//  Copyright © 2019 AmitG. All rights reserved.
//

import UIKit
import Cloudinary


class PreviewController : UIViewController {
    var imageInfo : ImageInfo?
    
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        self.imgView.layer.borderColor = UIColor.black.cgColor
        self.imgView.layer.cornerRadius = 10
        if let image = self.imageInfo?.image {
            self.imgView.image = image
        }
        if self.imageInfo?.publicId == "" {
            if let image = self.imageInfo?.image {
                self.imgView.image = image
            }
        } else {
            let transformation = CLDTransformation().setWidth(Int(self.imgView.frame.size.width)).setHeight(Int(self.imgView.frame.size.width)).setCrop(.fit)
            self.imgView?.cldSetImage(publicId: self.imageInfo!.publicId, cloudinary: CloudinaryManager.cloudinary, signUrl: false, resourceType: .image, transformation: transformation, placeholder: nil)
        }
    }
    
    @IBAction func action1ImagePreview(_ sender: Any) {
        if let publicId = self.imageInfo?.publicId, publicId != "" { self.imgView.cldSetImage(CloudinaryManager.cloudinary.createUrl().setTransformation(CLDTransformation().setEffect(CLDTransformation.CLDEffect.blackwhite)).generate(self.getUniqueImageName())!, cloudinary: CloudinaryManager.cloudinary)
        }
    }
    
    @IBAction func action2ImagePreview(_ sender: Any) {
        self.imgView.cldSetImage(CloudinaryManager.cloudinary.createUrl().setTransformation(CLDTransformation().setAngle(["hflip"])).generate(self.getUniqueImageName())!, cloudinary: CloudinaryManager.cloudinary)
    }
    
    @IBAction func action3ImagePreview(_ sender: Any) {
    }
    
    func getUniqueImageName() -> String {
        return "\(Int64(NSDate.init().timeIntervalSince1970 * 1000)).jpg"
    }
}
