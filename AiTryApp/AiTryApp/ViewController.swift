//
//  ViewController.swift
//  AiTryApp
//
//  Created by SASE Koichiro on 2020/07/21.
//  Copyright © 2020 SASE Koichiro. All rights reserved.
//

import MLKit
import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    private lazy var textRecognizer = TextRecognizer.textRecognizer()
        
    var baseText = ""
    var translatedText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch(status){
            case .authorized:
                print("許可されています")
            case .denied:
                print("拒否されています")
            case .notDetermined:
                print("まだ決定されていません")
            case .restricted:
                print("制限されています")
            }
        }
    }
    
    
    @IBAction func camera(_ sender: Any) {
        
        let sourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            present(cameraPicker, animated: true, completion: nil)
        } else {
            print("エラー")
        }
    }
    
    @IBAction func photo(_ sender: Any) {
        
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            present(cameraPicker, animated: true, completion: nil)
        } else {
            print("エラー")
        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            imageView.image = pickedImage
            runTextRecognition(with: pickedImage)
            textView.text = baseText
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, nil, nil)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func runTextRecognition(with image: UIImage) {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else { return }
            //            self.textView.text = result.text
            self.baseText = result.text
        }
    }
    
    @IBAction func TranslateButton(_ sender: Any) {
        let translateVC = TranslateViewController()
        translateVC.baseText = baseText
        present(translateVC, animated: true, completion: nil)
    }
    
        
}



