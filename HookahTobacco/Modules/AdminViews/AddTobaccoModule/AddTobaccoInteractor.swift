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
    func didSelectMainImage(with fileURL: URL)
    func receiveStartingDataView()
    func receiveTastesForEditing()
    func receivedNewSelectedTastes(_ tastes: [Taste])
}

protocol AddTobaccoInteractorOutputProtocol: AnyObject {
    func receivedSuccessAddition()
    func receivedSuccessEditing(with changedData: Tobacco)
    func receivedError(with code: Int, and message: String)
    func showNameManufacturersForSelect(_ names: [String])
    func initialDataForPresentation(_ tobacco: AddTobaccoEntity.Tobacco, isEditing: Bool)
    func initialSelectedManufacturer(_ name: String?)
    func initialMainImage(_ image: Data?)
    func initialTastes(_ tastes: [Taste])
    func receivedTastesForEditing(_ tastes: SelectedTastes)
}

class AddTobaccoInteractor {
    weak var presenter: AddTobaccoInteractorOutputProtocol!
    
    private var getDataManager: GetDataBaseNetworkingProtocol
    private var setDataManager: SetDataBaseNetworkingProtocol
    private var setImageManager: SetImageDataBaseProtocol
    
    private var manufacturers: [Manufacturer]? {
        didSet {
            guard let manufacturers = manufacturers else { return }
            let names = manufacturers.map { $0.name }
            presenter.showNameManufacturersForSelect(names)
        }
    }
    private var selectedManufacturer: Manufacturer?
    private var tobacco: Tobacco?
    private var tastes: SelectedTastes = [:]
    private var allTastes: SelectedTastes = [:]
    private var isEditing: Bool
    private var mainImageFileURL: URL?
    private var editingMainImage: Data?
    private var dispatchGroup = DispatchGroup()
    private var receivedErrorAtEditing: [Error] = []
    
    init(_ tobacco: Tobacco? = nil,
         getDataManager: GetDataBaseNetworkingProtocol,
         setDataManager: SetDataBaseNetworkingProtocol,
         setImageManager: SetImageDataBaseProtocol) {
        isEditing = tobacco != nil
        self.tobacco = tobacco
        self.getDataManager = getDataManager
        self.setDataManager = setDataManager
        self.setImageManager = setImageManager
        getManufacturers()
        getAllTastes()
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
    
    private func getAllTastes() {
        getDataManager.getAllTastes { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    self.allTastes = Dictionary(uniqueKeysWithValues: data.map( { ($0.id, $0) }))
                    self.initialTastes()
                case .failure(let error):
                    self.presenter.receivedError(with: 0, and: error.localizedDescription)
            }
        }
    }
    
    private func addTobacco(_ tobacco: Tobacco, by imageFileURL: URL) {
        setDataManager.addTobacco(tobacco) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let uid):
                    var mutableTobacco = tobacco
                    mutableTobacco.uid = uid
                    self.addImage(tobacco: mutableTobacco, by: imageFileURL)
                case .failure(let error):
                    let err = error as NSError
                    self.presenter.receivedError(with: err.code, and: err.localizedDescription)
            }
        }
    }
    
    private func addImage(tobacco: Tobacco, by fileURL: URL) {
        guard let uid = tobacco.uid else { return }
        let named = NamedFireStorage.tobaccoImage(manufacturer: tobacco.nameManufacturer,
                                                  uid: uid,
                                                  type: .main)
        setImageManager.addImage(by: fileURL, for: named, completion: { error in
            if let error = error {
                let err = error as NSError
                self.presenter.receivedError(with: err.code, and: err.localizedDescription)
            } else {
                self.presenter.receivedSuccessAddition()
                self.successAdded()
            }
        })
    }
    
    private func setTobacco(_ tobacco: Tobacco) {
        dispatchGroup.enter()
        setDataManager.setTobacco(tobacco) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.receivedErrorAtEditing.append(error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func setImage(by newURL: URL?, for tobacco: Tobacco) {
        guard let uid = tobacco.uid,
              let oldNameManufacturer = self.tobacco?.nameManufacturer else { return }
        dispatchGroup.enter()
        let oldNamed = NamedFireStorage.tobaccoImage(manufacturer: oldNameManufacturer,
                                                     uid: uid,
                                                     type: .main)
        let newNamed = NamedFireStorage.tobaccoImage(manufacturer: tobacco.nameManufacturer,
                                                     uid: uid,
                                                     type: .main)
        if let newURL = newURL {
            editingMainImage = try? Data(contentsOf: newURL)
            setImageManager.setImage(from: oldNamed, to: newURL, for: newNamed) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.receivedErrorAtEditing.append(error)
                }
                self.dispatchGroup.leave()
            }
        } else {
            setImageManager.setImageName(from: oldNamed, to: newNamed) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.receivedErrorAtEditing.append(error)
                }
                self.dispatchGroup.leave()
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
    
    private func initialTastes() {
        guard let tobacco = tobacco else { return }
        tastes = Dictionary(uniqueKeysWithValues: tobacco.taste.compactMap {
            if let taste = allTastes[$0] {
                return ($0, taste)
            } else {
                return nil
            }
        })
        presenter.initialTastes(Array(tastes.values))
    }
    
    private func successAdded() {
        selectedManufacturer = nil
        tobacco = nil
        mainImageFileURL = nil
        editingMainImage = nil
    }
}

extension AddTobaccoInteractor: AddTobaccoInteractorInputProtocol {
    func sendNewTobaccoToServer(_ data: AddTobaccoEntity.Tobacco) {
        guard let selectManufacturer = selectedManufacturer,
              let uid = selectManufacturer.uid else {
            presenter.receivedError(with: -1, and: "Не выбран производитель для табака!")
            return
        }
        var tobacco = Tobacco(uid: tobacco?.uid,
                              name: data.name,
                              taste: Array(tastes.keys),
                              idManufacturer: uid,
                              nameManufacturer: selectManufacturer.name,
                              description: data.description,
                              image: tobacco?.image)
        if isEditing {
            dispatchGroup = DispatchGroup()
            setTobacco(tobacco)
            if mainImageFileURL != nil || tobacco.nameManufacturer != self.tobacco?.nameManufacturer {
                setImage(by: mainImageFileURL, for: tobacco)
                tobacco.image = editingMainImage
                mainImageFileURL = nil
            }
            dispatchGroup.notify(queue: .main) {
                if self.receivedErrorAtEditing.isEmpty {
                    self.presenter.receivedSuccessEditing(with: tobacco)
                } else {
                    let error = self.receivedErrorAtEditing.first! as NSError
                    self.presenter.receivedError(with: error.code, and: error.localizedDescription)
                }
            }
        } else {
            guard let imageFileURL = mainImageFileURL else {
                presenter.receivedError(with: -1, and: "Изображение не было выбрано для табака!")
                return
            }
            addTobacco(tobacco, by: imageFileURL)
        }
    }
    
    func didSelectedManufacturer(_ name: String) {
        selectedManufacturer = manufacturers?.first(where: { name == $0.name })
    }
    
    func didSelectMainImage(with fileURL: URL) {
        mainImageFileURL = fileURL
    }
    
    func receiveStartingDataView() {
        var pTobacco = AddTobaccoEntity.Tobacco(
                        name: "",
                        description: "")
        var manufacturer: Manufacturer? = nil
        if isEditing,
           let tobacco = tobacco {
            pTobacco = AddTobaccoEntity.Tobacco(
                        name: tobacco.name,
                        description: tobacco.description)
            manufacturer = receiveSelectedManufacturer(by: tobacco.idManufacturer)
            if manufacturer != nil {
                selectedManufacturer = manufacturer
            }
            editingMainImage = tobacco.image
        }
        presenter.initialDataForPresentation(pTobacco,
                                             isEditing: isEditing)
        presenter.initialSelectedManufacturer(manufacturer?.name)
        presenter.initialMainImage(editingMainImage)
    }
    
    func receiveTastesForEditing() {
        presenter.receivedTastesForEditing(tastes)
    }
    
    func receivedNewSelectedTastes(_ tastes: [Taste]) {
        self.tastes = Dictionary(uniqueKeysWithValues: tastes.map { ($0.id, $0) })
        presenter.initialTastes(tastes)
    }
}
