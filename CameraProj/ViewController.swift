//
//  ViewController.swift
//  CameraProj
//
//  Created by Bohdan on 08.11.2022.
//

import UIKit
import Photos

class ViewController: UIViewController {

    let camera = Camera()
    
    private var touchTimer: Timer?
    private var videoRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try camera.prepare()
            try camera.add(to: view)
        } catch {
            print(error)
        }
        
        camera.delegate = self
    }

    @IBAction func switchCamera() {
        do {
            try camera.switchCamera()
        } catch {
            print(error)
        }
    }
    @IBAction func capture() {
        resetTimer()
    }
    
    @IBAction func stopCapture(){
        touchTimer?.invalidate()
        
        videoRecording ? camera.stopVideRecording() : camera.capturePhoto()
        videoRecording = false
    }
    
    func resetTimer() {
        touchTimer?.invalidate()
        touchTimer = .scheduledTimer(withTimeInterval: 0.2, repeats: false)
        { [weak self] timer in
            self?.camera.startVideoRecording()
            self?.videoRecording = true
            
            timer.invalidate()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let url = sender as? URL {
            (segue.destination as? PlayerViewController)?.url = url
        }
    }
}

extension ViewController: CameraDelegate {
    func camera(_ camera: Camera, didCapture imageData: Data) {
        PHPhotoLibrary.shared().performChanges{
            PHAssetCreationRequest.forAsset().addResource(with: .photo, data: imageData, options: nil)
        }
    }
    
    func camera(_ camera: Camera, didFinishRecordingVideo url: URL) {
        performSegue(withIdentifier: "player", sender: url)
    }
    
    
}

