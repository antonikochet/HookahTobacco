//
//  ImageButtonPickerView.swift
//  
//
//  Created by антон кочетков on 09.11.2022.
//

import UIKit
import SnapKit
import HookahTobaccoResources

public protocol ImagePickerViewDelegate: AnyObject {
    func present(_ viewController: UIViewController)
    func didSelectedImage(by fileURL: URL)
    func didCancel()
}

public class ImageButtonPickerView: UIView {
    // MARK: - Public properties
    public weak var delegate: ImagePickerViewDelegate?

    public var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.backgroundColor = image != nil ? .clear : ResourceManager.provider.color(forKey: .secondarySubtitle).colorUIKit
            removeButton.isHidden = image == nil
        }
    }

    // MARK: - Private properties
    private let imageView = UIImageView()
    private let removeButton = IconButton()

    // MARK: - Initializers
    public init() {
        super.init(frame: .zero)
        setupUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setups
    private func setupUI() {
        setupImageView()
        setupRemoveButton()
    }
    private func setupImageView() {
        imageView.backgroundColor = ResourceManager.provider.color(forKey: .inputBackground).colorUIKit
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchOnImage))
        imageView.addGestureRecognizer(tapGesture)

        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8.0)
        }
    }
    private func setupRemoveButton() {
        removeButton.action = { [weak self] in
            self?.image = nil
        }
        removeButton.size = 16.0
        removeButton.imageSize = 16.0
        removeButton.image = ResourceManager.provider.image(forKey: .close).imageUIKit
        removeButton.isHidden = true
        removeButton.createCornerRadius()
        addSubview(removeButton)
        removeButton.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.trailing)
            make.centerY.equalTo(imageView.snp.top)
        }
    }
    // MARK: - Selectors
    @objc private func touchOnImage() {
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        delegate?.present(imagePickerView)
    }
}

// MARK: - UIImagePickerControllerDelegate implementation
extension ImageButtonPickerView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let imageFileURL = info[.imageURL] as? URL else {
            return
        }
        image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true) {
            self.delegate?.didSelectedImage(by: imageFileURL)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.delegate?.didCancel()
        }
    }
}
