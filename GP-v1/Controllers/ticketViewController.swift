//
//  ticketViewController.swift
//  GP-v1
//
//  Created by Thekra Faisal on 13/06/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import UIKit

class ticketViewController:  UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pic_1: UIImageView!
    @IBOutlet weak var pic_2: UIImageView!
    @IBOutlet weak var pic_3: UIImageView!
    @IBOutlet weak var pic_4: UIImageView!
    var imgView: UIImageView!
    var longitude = 0.0
    var latitude = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Text View UI
        setupTextViewUI()
        
        pic(sender: pic_1)
        pic(sender: pic_2)
        pic(sender: pic_3)
        pic(sender: pic_4)
    }
    
    
    func setupTextViewUI() {
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 20
    }
    
    func pic(sender: UIImageView!) {
        switch sender.tag {
        //case 0:  pic_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
            
        case 1:
    pic_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap_2)))
            
        case 2:
    pic_3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap_3)))
        case 3:
            
    pic_4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap_4)))
        
        default:
           // print("must choose one or more")
            pic_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
        }
        
        pic_1.isUserInteractionEnabled = true
        pic_2.isUserInteractionEnabled = true
        pic_3.isUserInteractionEnabled = true
        pic_4.isUserInteractionEnabled = true

    }
    
    @objc func imageTap() {
        print("image clicked")
        self.imgView = pic_1
        showImage()
    }
    
    @objc func imageTap_2() {
        print("image 2 clicked")
        self.imgView = pic_2
        showImage()
    }
    
    @objc func imageTap_3() {
           print("image 3 clicked")
        self.imgView = self.pic_3
           showImage()
       }
    
    @objc func imageTap_4() {
           print("image 4 clicked")
        self.imgView = pic_4
           showImage()
       }
}



extension ticketViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImage() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
       // imgPicker.sourceType = .camera
        imgPicker.sourceType = .photoLibrary
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        self.imgView.image = image
        
        dismiss(animated: true, completion: nil)
    }
}



