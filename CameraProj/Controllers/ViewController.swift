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
    
    
    @IBOutlet weak var captureButton: UIButton!
    
    @IBAction func switchCamera() {
        do {
            try camera.switchCamera()
        } catch {
            print(error)
        }
    }
    @IBAction func capture() {
        captureButton.alpha = 0.5
        resetTimer()
    }
    
    @IBAction func gallery() {
        performSegue(withIdentifier: "collection", sender: (camera.media, camera.photos))
    }
    
    @IBAction func stopCapture(){
        touchTimer?.invalidate()
        captureButton.alpha = 1.0
    
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
        if let urls = sender as? ([URL], [URL]) {
            (segue.destination as? CollectionViewController)?.media = urls.0
            (segue.destination as? CollectionViewController)?.photos = urls.1
        }
    }
}

extension ViewController: CameraDelegate {
    func camera(_ camera: Camera, didCapture imageData: Data) {
        
        guard let url = FileManager.default.urls(for:
                .documentDirectory, in:
                .userDomainMask).first?.appending(path: "mymovie\(Date.init()).mov")
        else { return }
        
        do {
            try imageData.write(to: url)
        } catch {
            print(error)
        }
        
        camera.addMedia(url)
        camera.addPhoto(url)
    }
    
    func camera(_ camera: Camera, didFinishRecordingVideo url: URL) {
        camera.addMedia(url)
    }
    
    
}

