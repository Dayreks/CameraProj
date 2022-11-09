//
//  PlayerViewController.swift
//  CameraProj
//
//  Created by Bohdan on 08.11.2022.
//

import Foundation
import AVFoundation
import UIKit

final class PlayerViewController: UIViewController {
    
    var player: AVPlayer?
    var url: URL!
    private var isPlaying = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = .init(url: url)
        
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspect
        layer.frame = playerContainer.bounds
        
        playerContainer.layer.addSublayer(layer)
    }
    
    @IBOutlet weak var playerContainer: UIView!
    
    @IBAction func togglePlay() {
        isPlaying.toggle()
        isPlaying ? player?.play() : player?.pause()
    }
    
}

