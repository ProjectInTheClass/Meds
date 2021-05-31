//
//  ViewController.swift
//  MedsApp
//
//  Created by Yong Seong Kim on 2021/04/18.
//

import UIKit
import AVFoundation

class Barcode: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var topbar: UIView!
    
    @IBOutlet weak var bottombar: UIView!
    let pickerController = UIImagePickerController()// 직접 카메라로 상품을 찍을 때 사용하는 변수.
    var imageView : UIImage? //카메라로 찍은 상품 사진.
    
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                          AVMetadataObject.ObjectType.code39,
                                          AVMetadataObject.ObjectType.code39Mod43,
                                          AVMetadataObject.ObjectType.code93,
                                          AVMetadataObject.ObjectType.code128,
                                          AVMetadataObject.ObjectType.ean8,
                                          AVMetadataObject.ObjectType.ean13,
                                          AVMetadataObject.ObjectType.aztec,
                                          AVMetadataObject.ObjectType.pdf417,
                                          AVMetadataObject.ObjectType.itf14,
                                          AVMetadataObject.ObjectType.dataMatrix,
                                          AVMetadataObject.ObjectType.interleaved2of5,
                                          AVMetadataObject.ObjectType.qr]

override func viewDidLoad() {
    super.viewDidLoad()
    var captureSession = AVCaptureSession()
    
    
    pickerController.sourceType = UIImagePickerController.SourceType.camera
    pickerController.delegate = self
    
    
guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
           print("Failed to get the camera device")
           return
       }
       
       do {
           // Get an instance of the AVCaptureDeviceInput class using the previous device object.
           let input = try AVCaptureDeviceInput(device: captureDevice)
           
           // Set the input device on the capture session.
           captureSession.addInput(input)
           
           // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
           let captureMetadataOutput = AVCaptureMetadataOutput()
           captureSession.addOutput(captureMetadataOutput)
           
           // Set delegate and use the default dispatch queue to execute the call back
           captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

           captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
        
        
           
       } catch {
           // If any error occurs, simply print it out and don't continue any more.
           print(error)
           return
       }
       
       // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
       videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
       videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
       videoPreviewLayer?.frame = view.layer.bounds
       view.layer.addSublayer(videoPreviewLayer!)
       
       // Start video capture.
       captureSession.startRunning()

        // Move the message label and top bar to the front
//        view.bringSubview(toFront: messageLabel)
        topbar.layer.borderColor = UIColor.black.cgColor
        topbar.layer.borderWidth = 2
        view.bringSubviewToFront( topbar)
    view.bringSubviewToFront( bottombar)
//        topbar.backgroundColor = UIColor(
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    
}



override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}
    
func launchApp(decodedURL: String) {
   
   if presentedViewController != nil {
       return
   }
   
   let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .actionSheet)//창을 띄어줌.

   let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
       
       if let url = URL(string: decodedURL) {
           if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url)
           }
       }
   })
   
   let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
   
   alertPrompt.addAction(confirmAction)
   alertPrompt.addAction(cancelAction)
   
   present(alertPrompt, animated: true, completion: nil)
}
    
    
 private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
       layer.videoOrientation = orientation
       videoPreviewLayer?.frame = self.view.bounds
 }
     
 override func viewDidLayoutSubviews() {
   super.viewDidLayoutSubviews()
   
   if let connection =  self.videoPreviewLayer?.connection
   {
     let currentDevice: UIDevice = UIDevice.current
     let orientation: UIDeviceOrientation = currentDevice.orientation
     let previewLayerConnection : AVCaptureConnection = connection
     
     if previewLayerConnection.isVideoOrientationSupported
     {
           switch (orientation) {
           case .portrait:
             updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
             break
           case .landscapeRight:
             updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
             break
           case .landscapeLeft:
             updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
             break
           case .portraitUpsideDown:
             updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
             break
           default:
             updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
             break
       }
     }
   }
 }


    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
       // Check if the metadataObjects array is not nil and it contains at least one object.
       if metadataObjects.count == 0 {
           qrCodeFrameView?.frame = CGRect.zero
        print("No Barcode is detected")

           return
       }
       
       // Get the metadata object.
       let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
       
    //            print(metadata)
       if supportedCodeTypes.contains(metadataObj.type) {
           // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
           let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
           qrCodeFrameView?.frame = barCodeObject!.bounds
           
           if metadataObj.stringValue != nil {
               launchApp(decodedURL: metadataObj.stringValue!)
//               messageLabel.text = metadataObj.stringValue
           }
       }
    }
    
    
    @IBAction func takePicture(_ sender: Any) {
    //직접 입력 버튼을 눌렀을 떄 실행하는 함수.
        present(pickerController, animated: true, completion: nil)
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let saveProduct = segue.destination as? saveProduct else { return }
        
        if let imageView = imageView
        {
            saveProduct.tempImage = imageView
        }
        
        
    }
    
    
}


extension Barcode : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        
        
        imageView = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        performSegue(withIdentifier: "storeProduct", sender: self)
        
//        productImage.image = info[UIImagePickerController.InfoKey.originalImage]
//    as? UIImage
        
    }

    
}
