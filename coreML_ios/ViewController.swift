//
//  ViewController.swift
//  coreML_ios
//
//  Created by Farhan Rahman on 11/22/17.
//  Copyright © 2017 Farhan Rahman. All rights reserved.
//

import UIKit
import AVKit
import Vision
import ARKit

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Here is where we start the camera.
        let captureSession = AVCaptureSession()
        
        
        //Get the capture device.
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        //Get the video capture input.
        let input = try? AVCaptureDeviceInput(device: captureDevice)
        
        //Set up where the vid gets input from.
        captureSession.addInput(input!)
        
        //Start the capture session.
        captureSession.startRunning()
        
        //Create a preview layer.
        var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        //Add a layer to the view controller.
        view.layer.addSublayer(previewLayer)
        
        //Make the camera go full screen.
        previewLayer.frame = view.frame
        
        //Data output for the video.
        var dataOutput = AVCaptureVideoDataOutput()
        
        //Set a buffer delegate.
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "hahahahahah"))
        
        //Add the data output to the capture session.
        captureSession.addOutput(dataOutput)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        // Turn the video data into a pixel buffer.
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else{ return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            
            
            
            //Check the error, and print out the finished results.
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            
            guard let firstObservation = results.first else { return }
            
            print(firstObservation.identifier)
            print(firstObservation.confidence)
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    }

}

