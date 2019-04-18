//
//  UploadManager.swift
//  SampleImageUpload
//
//  Created by Amit on 14/04/19.
//  Copyright © 2019 AmitG. All rights reserved.
//

import Foundation
import Cloudinary

typealias UploadClosure = (CLDUploadResult?, NSError?) -> Void

class UploadManager {
    
    static let shared = UploadManager()
    
    var arrInfo = [ImageInfoUploader]()
    
    func addInfoToUpload(info:ImageInfo, closure:@escaping UploadClosure)  {
        if self.isInfoUploadInProgress(info: info) == false {

            let infoUploader : ImageInfoUploader = ImageInfoUploader(info: info)
            self.arrInfo.append(infoUploader)
            infoUploader.uploadInfo { (result, error) in
                closure(result, error)
            }
        }
    }
    
    func isInfoUploadInProgress(info:ImageInfo) -> Bool {
        let arr = self.arrInfo.filter { (infoUploader) -> Bool in
            return infoUploader.info == info
        }
        return arr.count > 0
    }
}


class ImageInfoUploader {
    var uploader : CLDUploader?
    var info : ImageInfo
    
    init(info:ImageInfo) {
        self.info = info
        self.uploader = CloudinaryManager.cloudinary.createUploader()
    }
    
    func uploadInfo(closure:@escaping UploadClosure)  {
        if let data = self.info.image!.jpegData(compressionQuality: 0.2) {
            self.uploader!.upload(data: data, uploadPreset: CloudinaryManager.preset) { (result, error) in
                if let error = error {
                    print("Failed to upload - \(error.description)")
                } else {
                    if let result = result, let publicId = result.publicId {
                        print(result)
                        self.info.publicId = publicId
                        self.info.image = nil
                    }
                }
                closure(result, error)
            }
        }
     }
}
