//
//  ImageButtonPickerView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 09.11.2022.
//

import UIKit
import SnapKit

class ImageButtonPickerView: UIView {
    // MARK: - Public properties
    weak var delegate: ImagePickerViewDelegate?
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.backgroundColor = image != nil ? .clear : .systemGray5
        }
    }
    
    // MARK: - Private properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark")?
                                .withRenderingMode(.alwaysTemplate),
                        for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray2
        button.alpha = 0.6
        return button
    }()
    
    // MARK: - Initializers
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
        removeButton.createCornerRadius()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
    }
    
    // MARK: - Setups
    private func setup() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchOnImage))
        imageView.addGestureRecognizer(tapGesture)
        
        addSubview(removeButton)
        removeButton.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.trailing)
            make.centerY.equalTo(imageView.snp.top)
            make.size.equalTo(16)
        }
        removeButton.addTarget(self, action: #selector(touchRemoveButton), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc private func touchOnImage() {
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        delegate?.present(imagePickerView)
    }
    
    @objc private func touchRemoveButton() {
        image = nil
    }
}

// MARK: - UIImagePickerControllerDelegate implementation
extension ImageButtonPickerView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageFileURL = info[.imageURL] as? URL else {
            return
        }
        image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true) {
            self.delegate?.didSelectedImage(by: imageFileURL)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.delegate?.didCancel()
        }
    }
}
