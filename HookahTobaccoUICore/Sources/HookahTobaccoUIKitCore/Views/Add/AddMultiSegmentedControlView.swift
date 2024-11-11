//
//  AddMultiSegmentedControlView.swift
//
//
//  Created by антон кочетков on 03.12.2022.
//

import UIKit
import MultiSelectSegmentedControl
import SnapKit
import HookahTobaccoResources

public class AddMultiSegmentedControlView: UIView {
    // MARK: - Public properties
    public var selectedIndex: [Int] {
        get {
            Array(segmentedControl.selectedSegmentIndexes)
        }
        set {
            segmentedControl.selectedSegmentIndexes = IndexSet(newValue)
        }
    }

    // MARK: - Provate properties

    // MARK: - Private UI
    private let label = UILabel()
    private let segmentedControl = MultiSelectSegmentedControl()

    // MARK: - Initializers
    public init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    public required init?(coder: NSCoder) {
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
        
        segmentedControl.selectedBackgroundColor = ResourceManager.provider.color(forKey: .primaryPurple).colorUIKit
        segmentedControl.tintColor = ResourceManager.provider.color(forKey: .primaryTitle).colorUIKit
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Public methods
    public func setupView(textLabel: String, segmentTitles: [String]) {
        label.text = textLabel
        segmentedControl.removeAllSegments()
        segmentTitles.enumerated().forEach { index, title in
            segmentedControl.insertSegment(withTitle: title, at: index, animated: true)
        }
        segmentedControl.selectedSegmentIndex = -1
    }

    public func showView() {
        isHidden = false
    }

    public func hideView() {
        segmentedControl.selectedSegmentIndexes = []
        isHidden = true
    }
}
