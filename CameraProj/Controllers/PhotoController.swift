//
//  PhotoController.swift
//  CameraProj
//
//  Created by Bohdan on 10.11.2022.
//

import Foundation
import UIKit
import Photos

final class PhotoController: UIViewController, UIGestureRecognizerDelegate {
    
    var photo: URL?
    var imageData: Data?
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        
        self.image.isUserInteractionEnabled = true
        self.image.addGestureRecognizer(lpgr)
        
        do {
            guard let photo = self.photo else {return}
            imageData = try Data(contentsOf: photo)
            image.image = UIImage(data: imageData!)
        } catch {
            print(error)
        }
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.ended {
            PHPhotoLibrary.shared().performChanges{
                PHAssetCreationRequest.forAsset().addResource(with: .photo, data: self.imageData!, options: nil)
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Your photo was successfully saved", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
            
        }
    }
}
