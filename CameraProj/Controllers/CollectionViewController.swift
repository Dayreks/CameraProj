//
//  CollectionView.swift
//  CameraProj
//
//  Created by Bohdan on 09.11.2022.
//

import Foundation
import UIKit


final class CollectionViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var media: [URL] = []
    var photos: [URL] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
       
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "media", for: indexPath) as! CollectionViewCell
        cell.configure(media[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let data = sender as? ([URL], Int) {
            (segue.destination as? PlayerViewController)?.media = data.0
            (segue.destination as? PlayerViewController)?.currentMediaIndex = data.1
        }
        if let data = sender as? URL {
            (segue.destination as? PhotoController)?.photo = data
        }
    }
    
}


extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (photos.contains(media[indexPath.row])) {
            performSegue(withIdentifier: "photo", sender: media[indexPath.row])
        } else {
            let videos = media.filter { !photos.contains($0) }
            let videoIndex = videos.firstIndex(where: {$0 == media[indexPath.row]})
            
            performSegue(withIdentifier: "player", sender: (videos,videoIndex))
        }
    }
}
