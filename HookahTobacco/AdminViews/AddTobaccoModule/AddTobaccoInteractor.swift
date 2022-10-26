//
//
//  AddTobaccoInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import Foundation

protocol AddTobaccoInteractorInputProtocol: AnyObject {
    func sendNewTobaccoToServer(_ data: AddTobaccoEntity.Tobacco)
    func didSelectedManufacturer(_ name: String)
    func receiveStartingDataView()
}

protocol AddTobaccoInteractorOutputProtocol: AnyObject {
    func receivedSuccessAddition()
    func receivedSuccessEditing(with changedData: Tobacco)
    func receivedError(with code: Int, and message: String)
    func showNameManufacturersForSelect(_ names: [String])
    func initialDataForPresentation(_ tobacco: AddTobaccoEntity.Tobacco, isEditing: Bool)
    func initialSelectedManufacturer(_ name: String?)
}

class AddTobaccoInteractor {
    weak var presenter: AddTobaccoInteractorOutputProtocol!
    
    private var getDataManager: GetDataBaseNetworkingProtocol
    private var setDataManager: SetDataBaseNetworkingProtocol
    
    private var manufacturers: [Manufacturer]? {
        didSet {
            guard let manufacturers = manufacturers else { return }
            let names = manufacturers.map { $0.name }
            presenter.showNameManufacturersForSelect(names)
        }
    }
    private var selectedManufacturer: Manufacturer?
    private var tobacco: Tobacco?
    private var isEditing: Bool
    
    init(_ tobacco: Tobacco? = nil,
         getDataManager: GetDataBaseNetworkingProtocol,
         setDataManager: SetDataBaseNetworkingProtocol) {
        isEditing = tobacco != nil
        self.tobacco = tobacco
        self.getDataManager = getDataManager
        self.setDataManager = setDataManager
        getManufacturers()
    }
    
    private func getManufacturers() {
        getDataManager.getManufacturers(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    self.manufacturers = data
                    self.initialSelectedManufacturer()
                case .failure(let error):
                   let err = error as NSError
                    self.presenter.receivedError(with: err.code, and: err.localizedDescription)
            }
        })
    }
    
    private func addTobacco(_ tobacco: Tobacco) {
        setDataManager.addTobacco(tobacco, completion: { [weak self] error in
            guard let self = self else { return }
            if error == nil {
                self.presenter.receivedSuccessAddition()
            } else {
                let err = error! as NSError
                self.presenter.receivedError(with: err.code, and: err.localizedDescription)
            }
        })
    }
    
    private func setTobacco(_ tobacco: Tobacco) {
        setDataManager.setTobacco(tobacco) { [weak self] error in
            guard let self = self else { return }
            if error == nil {
                self.presenter.receivedSuccessEditing(with: tobacco)
            } else {
                let err = error! as NSError
                self.presenter.receivedError(with: err.code, and: err.localizedDescription)
            }
        }
    }
    
    private func receiveSelectedManufacturer(by uid: String) -> Manufacturer? {
        guard let manufacturers = manufacturers else { return nil }
        let manufacturer = manufacturers.first(where: { $0.uid == uid })
        return manufacturer
    }
    
    private func initialSelectedManufacturer() {
        guard let tobacco = tobacco,
              let manufacturer = receiveSelectedManufacturer(by: tobacco.idManufacturer) else { return }
        selectedManufacturer = manufacturer
        presenter.initialSelectedManufacturer(manufacturer.name)
    }
}

extension AddTobaccoInteractor: AddTobaccoInteractorInputProtocol {
    func sendNewTobaccoToServer(_ data: AddTobaccoEntity.Tobacco) {
        guard let selectManufacturer = selectedManufacturer,
              let uid = selectManufacturer.uid else {
            presenter.receivedError(with: -1, and: "Не выбран производитель для табака!")
            return
        }
        let tobacco = Tobacco(uid: tobacco?.uid,
                              name: data.name,
                              taste: data.tastes,
                              idManufacturer: uid,
                              description: data.description)
        if isEditing {
            setTobacco(tobacco)
        } else {
            addTobacco(tobacco)
        }
    }
    
    func didSelectedManufacturer(_ name: String) {
        selectedManufacturer = manufacturers?.first(where: { name == $0.name })
    }
    
    func receiveStartingDataView() {
        var pTobacco = AddTobaccoEntity.Tobacco(
                        name: "",
                        tastes: [],
                        description: "")
        var manufacturer: Manufacturer? = nil
        if isEditing,
           let tobacco = tobacco {
            pTobacco = AddTobaccoEntity.Tobacco(
                        name: tobacco.name,
                        tastes: tobacco.taste,
                        description: tobacco.description)
            manufacturer = receiveSelectedManufacturer(by: tobacco.idManufacturer)
            if manufacturer != nil {
                selectedManufacturer = manufacturer
            }
        }
        presenter.initialDataForPresentation(pTobacco,
                                             isEditing: isEditing)
        presenter.initialSelectedManufacturer(manufacturer?.name)
    }
}
