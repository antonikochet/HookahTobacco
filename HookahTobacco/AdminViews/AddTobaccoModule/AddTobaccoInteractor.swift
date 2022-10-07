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
}

protocol AddTobaccoInteractorOutputProtocol: AnyObject {
    func receivedSuccessWhileAdding()
    func receivedErrorWhileAdding(with code: Int, and message: String)
    func receivedError(with title: String, and message: String)
    func showNameManufacturersForSelect(_ names: [String])
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
    
    init(getDataManager: GetDataBaseNetworkingProtocol,
         setDataManager: SetDataBaseNetworkingProtocol) {
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
                case .failure(let error):
                    self.presenter.receivedError(with: "Ошибка", and: error.localizedDescription)
            }
        })

    }
}

extension AddTobaccoInteractor: AddTobaccoInteractorInputProtocol {
    func sendNewTobaccoToServer(_ data: AddTobaccoEntity.Tobacco) {
        guard let selectManufacturer = selectedManufacturer,
              let uid = selectManufacturer.uid else {
            presenter.receivedError(with: "Ошибка", and: "Не выбран производитель для табака!")
            return
        }
        let tobacco = Tobacco(uid: nil,
                              name: data.name,
                              taste: data.tastes,
                              idManufacturer: uid,
                              description: data.description)
        setDataManager.addTobacco(tobacco, completion: { [weak self] error in
            guard let self = self else { return }
            if error == nil {
                self.presenter.receivedSuccessWhileAdding()
            } else {
                self.presenter.receivedErrorWhileAdding(with: 0, and: "")
            }
        })
    }
    
    func didSelectedManufacturer(_ name: String) {
        selectedManufacturer = manufacturers?.first(where: { name == $0.name })
    }
}
