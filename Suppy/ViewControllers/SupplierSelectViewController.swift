//
//  SupplierSelectViewController.swift
//  Suppy
//
//  Created by Daniel Montano on 06.10.18.
//  Copyright © 2018 Daniel Montano. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SupplierSelectViewController: UIViewController, QRCodeReaderViewControllerDelegate{
    
     @IBOutlet weak var topBarView: UIView!
     @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var manufacturersView: UIView!
    @IBOutlet weak var distributorsView: UIView!
    @IBOutlet weak var importsView: UIView!
    @IBOutlet weak var retailView: UIView!
    
    let grayStrength: CGFloat = 0.9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topBarView.backgroundColor = Constants.blueColor
        self.view.backgroundColor = Constants.greyLight
        
        self.manufacturersView.layer.cornerRadius = 10.0
        self.manufacturersView.layer.borderWidth = 0.5
        self.manufacturersView.layer.borderColor = UIColor(red: grayStrength, green: grayStrength, blue: grayStrength, alpha: 1.0).cgColor
        
        self.distributorsView.layer.cornerRadius = 10.0
        self.distributorsView.layer.borderWidth = 0.5
        self.distributorsView.layer.borderColor = UIColor(red: grayStrength, green: grayStrength, blue: grayStrength, alpha: 1.0).cgColor
        
        self.importsView.layer.cornerRadius = 10.0
        self.importsView.layer.borderWidth = 0.5
        self.importsView.layer.borderColor = UIColor(red: grayStrength, green: grayStrength, blue: grayStrength, alpha: 1.0).cgColor
        
        self.retailView.layer.cornerRadius = 10.0
        self.retailView.layer.borderWidth = 0.5
        self.retailView.layer.borderColor = UIColor(red: grayStrength, green: grayStrength, blue: grayStrength, alpha: 1.0).cgColor
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func manuButtonPressed(_ sender: UIButton) {
        SupplyChainItemBuilder.sharedInstance.building = true
        SupplyChainItemBuilder.sharedInstance.supplier_type = SupplierType.PRODUCER
        doTheModalScan()
    }
    
    @IBAction func distButtonPressed(_ sender: UIButton) {
        SupplyChainItemBuilder.sharedInstance.building = true
        SupplyChainItemBuilder.sharedInstance.supplier_type = SupplierType.TRANSPORT
        doTheModalScan()
    }
    
    @IBAction func retailButtonPressed(_ sender: UIButton) {
        SupplyChainItemBuilder.sharedInstance.building = true
        SupplyChainItemBuilder.sharedInstance.supplier_type = SupplierType.RETAIL
        doTheModalScan()
        
    }
    @IBAction func importsButtonPressed(_ sender: UIButton) {
        SupplyChainItemBuilder.sharedInstance.building = true
        SupplyChainItemBuilder.sharedInstance.supplier_type = SupplierType.STORAGE
        doTheModalScan()
    }
    
    func goAhead(){
        self.performSegue(withIdentifier: "TheCrazySegue2", sender: nil)
    }
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = false
            $0.showSwitchCameraButton  = false
            $0.showOverlayView         = true
            $0.preferredStatusBarStyle = .lightContent
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - Actions
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    func doTheModalScan(){
        
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        
        present(readerVC, animated: true, completion: nil)
    }
    
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
            self!.goAhead()
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}
