//
//  ImageListController.swift
//  SampleImageUpload
//
//  Created by Amit on 10/04/19.
//  Copyright © 2019 AmitG. All rights reserved.
//

import UIKit
import Cloudinary

class ImageListViewController: UITableViewController {

    var arrImageInfo : [ImageInfo] = {
        return ImageInfo.loadImages() ?? []
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrImageInfo.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellImg = cell as? ImageCell
        cellImg?.imageView?.image = nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as? ImageCell else {
            fatalError("Unable to fetch cell")
        }
        let info = arrImageInfo[indexPath.row]
        if info.publicId == "" {
            if let image = info.image {
                cell.imgView.image = image
            }
            cell.loader.isHidden = false
            cell.loader.startAnimating()
        } else {
            cell.loader.isHidden = true
            let transformation = CLDTransformation().setWidth(Int(self.tableView.frame.size.width)).setHeight(Int(self.tableView.frame.size.width)).setCrop(.fit)
            cell.imgView?.cldSetImage(publicId: info.publicId, cloudinary: CloudinaryManager.cloudinary, signUrl: false, resourceType: .image, transformation: transformation, placeholder: nil)
        }
        return cell
    }
    
    
    @IBAction func addImageAction(_ sender: Any) {
        
        var preferredStyle : UIAlertController.Style?
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredStyle =  .alert
        } else {
            preferredStyle = .actionSheet
        }
        let actionSheetController: UIAlertController = UIAlertController(title: "Upload Photo", message: "", preferredStyle: preferredStyle!)
        let btnCameraAction = UIAlertAction(title: "Camera", style: .default)
        { _ in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        actionSheetController.addAction(btnCameraAction)
        let btnLibAction = UIAlertAction(title: "Photo Library", style: .default)
        { _ in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        actionSheetController.addAction(btnLibAction)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let previewController = segue.destination as? PreviewController
        if let indexPath = self.tableView.indexPathForSelectedRow {
            previewController?.imageInfo = self.arrImageInfo[indexPath.row]
        }
    }
}

extension ImageListViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage  {
             let info = ImageInfo.init(publicId: "", image: image)
            self.uplodImageInfo(info: info) { (state) in
                if state == true {
                    print("Save Success")
                } else {
                    print("Save Failed")
                }
                self.tableView.reloadData()
                DispatchQueue.global().async {
                    ImageInfo.saveImageInfo(self.arrImageInfo)
                }
            }
            self.arrImageInfo.append(info)
            self.tableView.reloadData()
            self.moveTableToBottom()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
         self.dismiss(animated: true, completion: nil)
    }
    
    private func uplodImageInfo(info : ImageInfo, closure:@escaping (Bool)->Void) {
        UploadManager.shared.addInfoToUpload(info: info) { (result, error) in
            if error != nil {
                closure(false)
            } else {
                closure(true)
            }
        }
    }
    
    private func moveTableToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.arrImageInfo.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
