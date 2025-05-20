//
//  ImageViewController.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 18/05/25.
//

import UIKit
import UniformTypeIdentifiers

class ImageViewController: BaseViewController {

    var imageView: UIImageView?
    var imagePicker = UIImagePickerController()
    var addBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        setupUI()
    }

}

extension ImageViewController {
    private func setupUI() {
        setupImageView()
        addConstraintsImageView()
        
        setupSelectImageButtonView()
        addConstraintsSelectImageButtonView()
    }
    
    private func setupImageView() {
        self.imageView = UIImageView()
        
        guard let imageView = imageView else { return }
        
        view.addSubview(imageView)
        imageView.layer.masksToBounds = false
        imageView.image = UIImage(systemName: "photo.circle.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
    }
    
    private func addConstraintsImageView() {
        guard let imageView = imageView else { return }
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
        
        view.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
    }
    
    private func setupSelectImageButtonView() {
        self.addBtn = UIButton()
        
        guard let addBtn = addBtn else { return }
        
        view.addSubview(addBtn)
        
        addBtn.setTitle("Select Image", for: .normal)
        addBtn.setTitleColor(UIColor.black, for: .normal)
        addBtn.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        addBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addBtn.layer.cornerRadius = 6.0
        addBtn.addTarget(self, action: #selector(imageBtnTapped), for: .touchUpInside)
    }
    
    private func addConstraintsSelectImageButtonView() {
        guard let addBtn = addBtn, let imageView = imageView else { return }
        
        addBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).inset(-10)
        }
    }
}

extension ImageViewController {
    @objc private func imageBtnTapped() {
        alertController()
    }
    
    private func alertController() {
        let alert = UIAlertController(title: nil, message: "Choose", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(red: 240/255, green: 64/255, blue: 80/255, alpha: 1.0)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] cameraAction in
            guard let welf = self else { return }
            welf.capture()
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { [weak self] galleryAction in
            guard let welf = self else { return }
            
            welf.imagePicker.sourceType = .photoLibrary
            welf.imagePicker.allowsEditing = true
            
            welf.presentImagePicker()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancel.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topViewController = windowScene.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func capture() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [UTType.image.identifier]
        imagePicker.allowsEditing = true
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topViewController = windowScene.windows.first?.rootViewController {
            topViewController.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func presentImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView?.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
