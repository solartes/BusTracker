//
//  EscanearViewController.swift
//  BusTracker
//
//  Created by Julian Solarte on 5/1/18.
//  Copyright © 2018 unicauca. All rights reserved.
//

import UIKit
import AVFoundation

protocol EscanearViewControllerDelegate {
    func foundBarcode(barcode:String)
}

class EscanearViewController: UIViewController {
    
    var delegate:EscanearViewControllerDelegate?
    
    var captureSession: AVCaptureSession = AVCaptureSession()
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    let cameraDevice = AVCaptureDevice.default(for: AVMediaType.video)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let cameraDevice = AVCaptureDevice.default(for: AVMediaType.video)
        if cameraDevice == nil{
            return
        }
        guard let videoInput =
            try? AVCaptureDeviceInput(device: cameraDevice!)
            else {
                failed()
                return
        }
        //add video camera input to capture session
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else { failed();return }
        //Bar code detector
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
        } else { failed();return }
        //Customize metadata output
        metadataOutput.metadataObjectTypes =
            [AVMetadataObject.ObjectType.ean13]
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureSession.startRunning()
        //Add preview
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.frame
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func failed() {
        let ac = UIAlertController(title: "Detección de codigo de barras no soportado",
                                   message: "Su dispositivo no sporta la deteccion del codigo de barras.",
                                   preferredStyle: .alert)
        let alert = UIAlertAction(title: "OK", style: .default) { (action) in self.dismiss(animated: true, completion: nil)
        }
        ac.addAction(alert)
        present(ac, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension EscanearViewController:
AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput
        metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        if let metadataObject = metadataObjects.first as?
            AVMetadataMachineReadableCodeObject {
            captureSession.stopRunning()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "rutasEscaner") as! RutasEscanerTableViewController
            newViewController.lugarParadero = metadataObject.stringValue!
            self.present(newViewController, animated: true, completion: nil)
            dismiss(animated: true, completion: nil)
        }
    }
}
