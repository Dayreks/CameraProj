//
//  PlayerViewController.swift
//  CameraProj
//
//  Created by Bohdan on 08.11.2022.
//

import Foundation
import AVFoundation
import UIKit
import Photos

final class PlayerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var media: [URL] = []
    var currentMediaIndex = 0
    private var isPlaying = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeVideo()
        
        playButtons.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        volumeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        
        self.playerContainer.isUserInteractionEnabled = true
        self.playerContainer.addGestureRecognizer(lpgr)
        
        
    }
    
    @IBOutlet weak var playerContainer: UIView!
    
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButtons: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func volume(_ sender: Any) {
        player?.isMuted.toggle()
        player!.isMuted ? (player?.isMuted = true) : (player?.isMuted = false)
    }
    
    @IBAction func togglePlay() {
        isPlaying.toggle()
        isPlaying ? player?.play() : player?.pause()
    }
    
    @IBAction func back() {
        if self.currentMediaIndex - 1 >= 0 {
            self.isPlaying = false
            self.currentMediaIndex = self.currentMediaIndex - 1
            changeVideo()
        }
    }
    
    @IBAction func next() {
        if self.currentMediaIndex + 1 < media.count {
            self.isPlaying = false
            self.currentMediaIndex = self.currentMediaIndex + 1
            changeVideo()
        }
        
    }
    
    func changeVideo(){
        clearVideo()
        
        player = .init(url: media[self.currentMediaIndex])
        player?.isMuted = false
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.videoGravity = .resizeAspect
        playerLayer!.frame = playerContainer.bounds
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        playerContainer.layer.addSublayer(playerLayer!)
    }
    
    func clearVideo(){
        if let player = self.player{
            player.pause()
            self.player = nil
            
        }
        if let layer = self.playerLayer{
            layer.removeFromSuperlayer()
            self.playerLayer = nil
        }
        
        self.playerContainer.layer.sublayers?.removeAll()
    }
    
    @objc func buttonTapped(_ sender: UIButton){
        sender.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sender.alpha = 1.0
        }
    }
    @objc func playerDidFinishPlaying(note: NSNotification){
        if self.currentMediaIndex + 1 < media.count{
            self.currentMediaIndex = self.currentMediaIndex + 1
            self.isPlaying = true
            changeVideo()
            player?.play()
        } else {
            self.player?.seek(to: CMTime.zero)
            self.isPlaying = false
        }
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.ended {

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.media[self.currentMediaIndex])
            }) { saved, error in
                if saved {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
}

