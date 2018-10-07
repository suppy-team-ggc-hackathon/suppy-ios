//
//  ViewController.swift
//  Suppy
//
//  Created by Daniel Montano on 06.10.18.
//  Copyright © 2018 Daniel Montano. All rights reserved.
//

import AVFoundation
import UIKit
import Alamofire
import BitcoinKit

class ViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    var latestItem: SupplyChainItem?
    
    @IBOutlet weak var qrcodeScannerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func scannerButtonPressed(_ sender: UIButton) {
        
//        do {
//            // Generate mnemonic
//            let mnemonic = try Mnemonic.generate()
//
//            let seed = Mnemonic.seed(mnemonic: mnemonic)
//
//            let wallet = HDWallet(seed: seed, network: .testnet)
//
//
//
//        } catch {
//            print(error)
//        }
        
//        BlockchainManager.sharedInstance.createAndSendSupplyChainItem(supplyChainItem: SupplyChainItem(date: Date(), prev_tx_ids: ["testaerwefwef"], latitude: 53.0, longitude: 13.0, supplier_id: "somestring", supplier_type: SupplierType.MANUFACTURER, product_type: ProductType.DELIVERY, product_title: "Some title", co2: 50.0))

//        BlockchainManager.sharedInstance.fetchSupplyChain(cb: { (supplyChainItems, errror) in
//            print(supplyChainItems.count)
//        })
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block:  { _ in
            self.doTheModalScan()
        })
        
    }
    
    @IBAction func addSupplyButtonPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "AuthenticateSegue", sender: nil)
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
//            let alert = UIAlertController(
//                title: "QRCodeReader",
//                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
//            self?.present(alert, animated: true, completion: nil)
            
//            Alamofire.request(blockchainURL).responseJSON { response in
//                print("Request: \(String(describing: response.request))")   // original url request
//                print("Response: \(String(describing: response.response))") // http url response
//                print("Result: \(response.result)")                         // response serialization result
//
//                if let json = response.result.value {
//                    print("JSON: \(json)") // serialized json response
//                }
//
//                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {He
//                    print("Data: \(utf8Text)") // original server data as UTF8 string
//                }
//            }
            
            BlockchainManager.sharedInstance.fetchEndProduct(cb: {(item:SupplyChainItem?, error: Error?) in
                if let item = item {
                    self?.latestItem = item
                    self?.performSegue(withIdentifier: "DetailsSegue", sender: nil)
                }else{
                    print(error!)
                }
            })
            
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            guard let identifier = segue.identifier else {
                return
            }
            
            switch identifier {
                
            case "DetailsSegue":
                let destinationVC = segue.destination as! DetailsViewController
                destinationVC.supplyChainItem = self.latestItem
            default:
                return
        }
    }
}
