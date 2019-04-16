//
//  ImageInfo.swift
//  SampleImageUpload
//
//  Created by Amit on 13/04/19.
//  Copyright © 2019 AmitG. All rights reserved.
//

import UIKit

class ImageInfo: NSObject, NSCoding {
    
    struct PropertyKey {
        static let image = "image"
        static let publicId = "publicId"
    }
    
    var publicId : String
    var image : UIImage?
    
    init(publicId:String, image:UIImage) {
        self.publicId = publicId
        self.image = image
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(publicId, forKey: PropertyKey.publicId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.publicId = aDecoder.decodeObject(forKey: PropertyKey.publicId) as! String
    }
}

extension ImageInfo {
    
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("Images")
    
    static func loadImages() -> [ImageInfo]? {
        print(ImageInfo.archiveURL)
        return NSKeyedUnarchiver.unarchiveObject(withFile: ImageInfo.archiveURL.path) as? [ImageInfo]
    }
    
    static func saveImageInfo(_ info:[ImageInfo]) {
        let arr = info.filter { (imageInfo) -> Bool in
            return imageInfo.publicId != ""
        }
        _ = NSKeyedArchiver.archiveRootObject(arr, toFile: ImageInfo.archiveURL.path)
    }
}

