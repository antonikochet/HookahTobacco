//
//  AddSegmentedControlView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 01.12.2022.
//

import UIKit
import SnapKit

protocol AddSegmentedControlViewDelegate: AnyObject {
    func didTouchSegmentedControl(_ view: AddSegmentedControlView, touchIndex: Int)
}

class AddSegmentedControlView: UIView {
    // MARK: - Public properties
    weak var delegate: AddSegmentedControlViewDelegate?

    var selectedIndex: Int {
        get {
            segmentedControl.selectedSegmentIndex
        }
        set {
            segmentedControl.selectedSegmentIndex = newValue
        }
    }

    var heightView: CGFloat {
        label.font.lineHeight +
        topMargin + heightSegmentedControl
    }

    // MARK: - Provate properties
    private let heightSegmentedControl: CGFloat = 30.0
    private let topMargin: CGFloat = 8.0

    // MARK: - Private UI
    private let label: UILabel = {
        let label = UILabel()
        return label
    }()

    private let segmentedControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        return segmentControl
    }()

    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    // MARK: - Setups
    private func setupSubviews() {
        addSubview(label)
        addSubview(segmentedControl)

        segmentedControl.addTarget(self, action: #selector(didTouchSegment), for: .valueChanged)
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(heightSegmentedControl)
        }
    }

    @objc private func didTouchSegment() {
        delegate?.didTouchSegmentedControl(self, touchIndex: segmentedControl.selectedSegmentIndex)
    }

    // MARK: - Public methods
    func setupView(textLabel: String, segmentTitles: [String]) {
        label.text = textLabel
        segmentedControl.removeAllSegments()
        segmentTitles.enumerated().forEach { index, title in
            segmentedControl.insertSegment(withTitle: title, at: index, animated: true)
        }
        segmentedControl.selectedSegmentIndex = -1
    }
}
