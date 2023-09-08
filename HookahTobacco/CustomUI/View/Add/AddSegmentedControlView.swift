//
//  AddSegmentedControlView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 01.12.2022.
//

import UIKit
import SnapKit

class AddSegmentedControlView: UIView {
    // MARK: - Public properties
    var didTouchSegmentedControl: CompletionBlockWithParam<Int>?

    var selectedIndex: Int {
        get {
            segmentedControl.selectedSegmentIndex
        }
        set {
            segmentedControl.selectedSegmentIndex = newValue
        }
    }

    // MARK: - Provate properties
    private let topMargin: CGFloat = 8.0

    // MARK: - Private UI
    private let label = UILabel()
    private let segmentedControl = UISegmentedControl()

    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupSubviews() {
        addSubview(label)
        addSubview(segmentedControl)

        label.setForTitleName()
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        segmentedControl.addTarget(self, action: #selector(didTouchSegment), for: .valueChanged)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    @objc private func didTouchSegment() {
        didTouchSegmentedControl?(segmentedControl.selectedSegmentIndex)
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
