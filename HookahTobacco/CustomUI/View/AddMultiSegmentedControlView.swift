//
//  AddMultiSegmentedControlView.swift
//  HookahTobacco
//
//  Created by антон кочетков on 03.12.2022.
//

import UIKit
import MultiSelectSegmentedControl
import SnapKit

class AddMultiSegmentedControlView: UIView {
    // MARK: - Public properties
    var selectedIndex: [Int] {
        get {
            Array(segmentedControl.selectedSegmentIndexes)
        }
        set {
            segmentedControl.selectedSegmentIndexes = IndexSet(newValue)
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
    private let label = UILabel()
    private let segmentedControl = MultiSelectSegmentedControl()

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

        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(heightSegmentedControl)
        }

        snp.makeConstraints { make in
            make.height.equalTo(heightView)
        }
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

    func showView() {
        isHidden = false
        snp.updateConstraints { make in
            make.height.equalTo(heightView)
        }
    }

    func hideView() {
        segmentedControl.selectedSegmentIndexes = []
        isHidden = true
        snp.updateConstraints { make in
            make.height.equalTo(0)
        }
    }
}
