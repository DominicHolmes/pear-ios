//
//  ScannerViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/14/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import AVFoundation

protocol RootPageControllable {
    func userDidSelectActivity(_ controller: PryntTabViewController)
    func userDidSelectPersonal(_ controller: PryntTabViewController)
}

class ScannerViewController: PryntTabViewController {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var delegate: RootPageControllable?
    
    private var codeFound = false
    private var areProfilesVisible = false
    
    @IBOutlet weak var profilesButton : UIButton!
    @IBOutlet weak var cameraView : UIView!
    @IBOutlet weak var profileViewTopConstraint : NSLayoutConstraint!
    @IBOutlet weak var profileViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var profilesTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pryntTBC = self.tabBarController as? PryntTabBarController {
            self.user = pryntTBC.user
        }
        
        fetchAllProfiles()
        
        view.backgroundColor = UIColor.white
        
        #if targetEnvironment(simulator)
        print("Running on device!")
        #else
        setupCaptureSession()
        #endif
    }
    
    func fetchAllProfiles() {
        ProfileNetworkingManager.shared.fetchAllProfiles(for: user.id) { (success, profiles) in
            if success, let profiles = profiles {
                self.user.profiles = profiles
            } else {
                self.displayAlert("Error", "Could not fetch profiles. Please make sure you have access to internet and try again.", nil)
            }
        }
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
    
    @IBAction func bankButtonSelected() {
        performSegue(withIdentifier: "ViewBankSegue", sender: nil)
    }
    
    @IBAction func activityButtonSelected() {
        delegate?.userDidSelectActivity(self)
    }
    
    @IBAction func personalButtonSelected() {
        delegate?.userDidSelectPersonal(self)
    }
}

// MARK: - QR Code Detected
extension ScannerViewController {
    fileprivate func found(code: String) {
        if !codeFound {
            codeFound = true
            confirmTransaction(with: code)
        }
    }
    
    private func confirmTransaction(with code: String) {
        print("Found: " + code)
        let transactionAccept = TransactionAccept(id: user.id, transactionId: code, secondaryApproval: false)
        TransactionNetworkingManager.shared.acceptTransaction(from: transactionAccept) { (success, transaction) in
            if success, let transaction = transaction {
                self.performSegue(withIdentifier: "ViewTransactionSegue", sender: transaction)
                self.endCaptureSession()
            } else {
                self.displayAlert("Error", "Could not complete transaction. Please make sure you have internet and try again.", nil)
            }
        }
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
                                   message: "Your device does not support scanning QR codes. Please use a device with a camera.",
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
}

// MARK: - Confirm Transaction Logic
extension ScannerViewController {
}

// MARK: - Segue Control
extension ScannerViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewBankSegue" {
            let nav = segue.destination as! UINavigationController
            let controller = nav.topViewController as! BankViewController
            controller.user = self.user
        } else if segue.identifier == "ViewTransactionSegue", let sender = sender as? Transaction {
            let nav = segue.destination as! UINavigationController
            let controller = nav.topViewController as! ExternalNavigationController
            controller.user = self.user
            controller.fullTransaction = sender
        }
    }
}
