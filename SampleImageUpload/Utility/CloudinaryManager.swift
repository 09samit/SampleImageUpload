//
//  Configuration.swift
//  SampleImageUpload
//
//  Created by Amit on 12/04/19.
//  Copyright © 2019 AmitG. All rights reserved.
//

import Foundation
import Cloudinary

class CloudinaryManager {

    static var cloudName: String {
        return "amitgarg"
    }
    
    static var preset: String {
        return "dnfs3jgj"
    }
    
    static var cloudinary: CLDCloudinary {
        return CLDCloudinary(configuration: CLDConfiguration(cloudName: CloudinaryManager.cloudName, secure: true))
    }
    
}
