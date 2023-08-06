//
//
//  AddTobaccoLineInteractor.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 04.08.2023.
//
//

import Foundation

protocol AddTobaccoLineInteractorInputProtocol: AnyObject {
    func receiveStartingDataView()
    func didEnterData(_ data: AddTobaccoLineEntity.TobaccoLine)
}

protocol AddTobaccoLineInteractorOutputProtocol: AnyObject {
    func initialDataForPresentation(_ tobaccoLine: TobaccoLine?)
    func receivedSuccess(with tobaccoLine: TobaccoLine)
    func receivedError(with message: String)
}

class AddTobaccoLineInteractor {
    // MARK: - Public properties
    weak var presenter: AddTobaccoLineInteractorOutputProtocol!

    // MARK: - Dependency
    private let setDataManager: AdminDataManagerProtocol

    // MARK: - Private properties
    private let tobaccoLine: TobaccoLine?
    private let manufacturerId: Int

    // MARK: - Initializers
    init(manufacturerId: Int,
         tobaccoLine: TobaccoLine?,
         setDataManager: AdminDataManagerProtocol) {
        self.manufacturerId = manufacturerId
        self.tobaccoLine = tobaccoLine
        self.setDataManager = setDataManager
    }

    // MARK: - Private methods
    private func sendTobaccoLineToServer(_ tobaccoLine: TobaccoLine, isSet: Bool) {
        if isSet {
            setDataManager.setData(tobaccoLine) { [weak self] result in
                switch result {
                case .success(let newTobaccoLine):
                    self?.presenter.receivedSuccess(with: newTobaccoLine)
                case .failure(let error):
                    self?.presenter.receivedError(with: error.localizedDescription)
                }
            }
        } else {
            setDataManager.addData(tobaccoLine) { [weak self] result in
                switch result {
                case .success(let newTobaccoLine):
                    self?.presenter.receivedSuccess(with: newTobaccoLine)
                case .failure(let error):
                    self?.presenter.receivedError(with: error.localizedDescription)
                }
            }
        }
    }
}
// MARK: - InputProtocol implementation 
extension AddTobaccoLineInteractor: AddTobaccoLineInteractorInputProtocol {
    func receiveStartingDataView() {
        presenter?.initialDataForPresentation(tobaccoLine)
    }

    func didEnterData(_ data: AddTobaccoLineEntity.TobaccoLine) {
        let tobaccoLeafTypes = (data.selectedTobaccoLeafTypeIndexs.isEmpty ? nil :
                                data.selectedTobaccoLeafTypeIndexs
                                    .compactMap { VarietyTobaccoLeaf(rawValue: $0) })
        if let tobaccoLine {
            let newTobaccoLine = TobaccoLine(id: tobaccoLine.id,
                                             uid: tobaccoLine.uid,
                                             name: data.name,
                                             packetingFormat: data.packetingFormats,
                                             tobaccoType: TobaccoType(rawValue: data.selectedTobaccoTypeIndex)!,
                                             tobaccoLeafType: tobaccoLeafTypes,
                                             description: data.description,
                                             isBase: data.isBase,
                                             manufacturerId: manufacturerId)
            sendTobaccoLineToServer(newTobaccoLine, isSet: true)
        } else {
            let tobaccoLine = TobaccoLine(name: data.name,
                                          packetingFormat: data.packetingFormats,
                                          tobaccoType: TobaccoType(rawValue: data.selectedTobaccoTypeIndex)!,
                                          tobaccoLeafType: tobaccoLeafTypes,
                                          description: data.description,
                                          isBase: data.isBase,
                                          manufacturerId: manufacturerId)
            sendTobaccoLineToServer(tobaccoLine, isSet: false)
        }
    }
}
