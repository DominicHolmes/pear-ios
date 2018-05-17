//
//  ScanViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/25/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController : PearTabViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var areProfilesVisible = false
    
    @IBOutlet weak var profilesButton : UIButton!
    @IBOutlet weak var headerView : UIView!
    @IBOutlet weak var cameraView : UIView!
    @IBOutlet weak var profileViewTopConstraint : NSLayoutConstraint!
    @IBOutlet weak var profileViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var profilesTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
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
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        cameraView.layer.addSublayer(previewLayer)
        hideProfilesTableView()
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported",
                                   message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        performSegue(withIdentifier: "performPearSegue", sender: code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// MARK: - ProfilesButtonMethod
extension ScannerViewController {
    
    @IBAction func toggleProfileSelector() {
        // toggle profiles value
        areProfilesVisible = !areProfilesVisible
        
        if areProfilesVisible {
            showProfilesTableView()
        } else {
            hideProfilesTableView()
        }
    }
    
    private func showProfilesTableView() {
        UIView.animate(withDuration: 0.3) {
            self.profileViewTopConstraint.constant = 140.0
            if self.activeUser != nil {
                self.profileViewHeightConstraint.constant = CGFloat(self.activeUser!.profiles.count) * 60.0
            } else {
                self.profileViewHeightConstraint.constant = 60.0
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideProfilesTableView() {
        UIView.animate(withDuration: 0.3) {
            self.profileViewTopConstraint.constant = self.view.bounds.maxY + 50.0
            if self.activeUser != nil {
                self.profileViewHeightConstraint.constant = CGFloat(self.activeUser!.profiles.count) * 60.0
            } else {
                self.profileViewHeightConstraint.constant = 60.0
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - TableView Data Source
extension ScannerViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activeUser != nil {
            return activeUser!.profiles.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScannableProfileCell")
        
        let profileNameLabel = cell?.viewWithTag(100) as? UILabel
        if activeUser != nil {
            profileNameLabel?.text = activeUser!.profiles[indexPath.row].getName()
        }
        
        return cell!
    }
}

// MARK: - TableView Delegate
extension ScannerViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // segue to correct profile
        performSegue(withIdentifier: "viewCodeSegue", sender: activeUser!.profiles[indexPath.row])
    }
}

// MARK: - View QRCode Popover
extension ScannerViewController: UIPopoverPresentationControllerDelegate {
    
    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController) {
        //do stuff from popover
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
    
}

// MARK: - Segue Control
extension ScannerViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewCodeSegue" {
            let controller = segue.destination as? QRCodeViewController
            controller?.popoverPresentationController!.delegate = self
            if let socialProfile = sender as? SocialProfile {
                controller?.socialProfile = socialProfile
                controller?.userProfile = activeUser
            }
        } else if segue.identifier == "pearProfileSelectionSegue" {
            let controller = segue.destination as? PearProfileSelectionTVC
            controller?.activeUser = self.activeUser
            controller?.databaseRef = self.databaseRef
        }
        
        /*else if segue.identifier == "performPearSegue" {
            let controller = segue.destination as? PearingAnimationViewController
            controller?.activeUser = self.activeUser
            controller?.databaseRef = self.databaseRef
            controller?.scannedCode = (sender as? String)
        }*/
    }
}
