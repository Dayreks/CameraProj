//
//  UICollectionViewCEll.swift
//  CameraProj
//
//  Created by Bohdan on 09.11.2022.
//

import Foundation
import UIKit
import AVFoundation

final class CollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var preview: UIImageView!
    
    
    
    func configure(_ url: URL) {
        guard let data = try? Data(contentsOf: url) else { return }
        preview.image = UIImage(data: data)
        
        if preview.image == nil {
            self.getThumbnailImageFromVideoUrl(url: url) { (thumbNailImage) in
                self.preview.image = thumbNailImage
            }
        }
        
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 0, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}


