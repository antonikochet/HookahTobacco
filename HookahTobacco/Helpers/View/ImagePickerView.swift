//
//  ImagePickerView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 27.10.2022.
//

import UIKit
import SnapKit

protocol ImagePickerViewDelegate: AnyObject {
    func present(_ viewController: UIViewController)
    func didSelectedImage(by fileURL: URL)
    func didCancel()
}

class ImagePickerView: UIView {
    weak var delegate: ImagePickerViewDelegate?
    
    var textButton: String = "Добавить изображение" {
        didSet { selectImageButton.setTitle(textButton, for: .normal) }
    }
    
    var image: UIImage? {
        didSet {
            updateImageView(image == nil)
            imageView.image = image
        }
    }
    
    var imageHeight: CGFloat = 100
    
    var viewWithoutImageHeight: CGFloat {
        heightButton + constraintBetweenButtonAndImage
    }
    
    private var currectImageHeight: CGFloat {
        get { image != nil ? imageHeight : 0 }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let selectImageButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.titleLabel?.font = UIFont.appFont(size: 17, weight: .bold)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectImageButton.createCornerRadius()
    }
    
    private func setup() {
        addSubview(selectImageButton)
        selectImageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.bottom.equalToSuperview()
            make.height.equalTo(heightButton)
        }
        selectImageButton.addTarget(self, action: #selector(touchSelectImageButton), for: .touchUpInside)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(selectImageButton.snp.top).inset(-constraintBetweenButtonAndImage)
            make.width.equalTo(imageView.snp.height)
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(heightView)
        }
    }
    
    private func updateImageView(_ isHidden: Bool) {
        snp.updateConstraints { make in
            make.height.equalTo(heightView)
        }
    }
    
    @objc
    private func touchSelectImageButton() {
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        delegate?.present(imagePickerView)
    }
}

extension ImagePickerView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let imageFileURL = info[.imageURL] as? URL else {
            return
        }
        image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true) {
            self.delegate?.didSelectedImage(by: imageFileURL)
            self.textButton = "Изменить изображение"
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.delegate?.didCancel()
        }
    }
}

extension ImagePickerView {
    fileprivate var heightButton: CGFloat { 35 }
    fileprivate var constraintBetweenButtonAndImage: CGFloat { 16 }
    fileprivate var heightView: CGFloat {
        heightButton +
        constraintBetweenButtonAndImage +
        currectImageHeight
    }
}
