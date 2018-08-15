//
//  ScannerViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/14/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: PryntTabViewController {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var codeFound = false
    private var areProfilesVisible = false
    
    @IBOutlet weak var profilesButton : UIButton!
    @IBOutlet weak var headerView : UIView!
    @IBOutlet weak var cameraView : UIView!
    @IBOutlet weak var profileViewTopConstraint : NSLayoutConstraint!
    @IBOutlet weak var profileViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var profilesTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pryntTBC = self.tabBarController as? PryntTabBarController {
            self.user = pryntTBC.user
        }
        
        view.backgroundColor = UIColor.white
        setupCaptureSession()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        endCaptureSession()
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    fileprivate func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failedScan()
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failedScan()
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    func failedScan() {
        let ac = UIAlertController(title: "Scanning not supported",
                                   message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
        
    }
    
    func endCaptureSession() {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        //dismiss(animated: true) // potential problem here
    }
    
    func found(code: String) {
        if !codeFound {
            endCaptureSession()
            performSegue(withIdentifier: "pearProfileSelectionSegue", sender: code)
            codeFound = true
        }
    }
}
