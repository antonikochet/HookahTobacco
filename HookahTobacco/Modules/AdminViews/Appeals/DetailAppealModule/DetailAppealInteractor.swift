//
//
//  DetailAppealInteractor.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.09.2023.
//
//

import Foundation

protocol DetailAppealInteractorInputProtocol: AnyObject {
    func startingShowData()
    func saveNewAnswer(_ anwser: String)
    func handledAppeal()
    func receiveURLContent(at index: Int)
}

protocol DetailAppealInteractorOutputProtocol: PresenterrProtocol {
    func showData(appeal: AppealResponse, contents: [DetailAppealContent])
    func receivedSuccessHandled()
    func receivedURLContent(_ url: URL)
}

class DetailAppealInteractor {
    // MARK: - Public properties
    weak var presenter: DetailAppealInteractorOutputProtocol!

    // MARK: - Dependency
    private let adminNetworkingService: AdminNetworkingServiceProtocol
    private let dataNetworingService: GetDataNetworkingServiceProtocol

    // MARK: - Private properties
    private var appeal: AppealResponse
    private var contents: [DetailAppealContent] = []

    // MARK: - Initializers
    init(appeal: AppealResponse,
         adminNetworkingService: AdminNetworkingServiceProtocol,
         dataNetworingService: GetDataNetworkingServiceProtocol) {
        self.appeal = appeal
        self.adminNetworkingService = adminNetworkingService
        self.dataNetworingService = dataNetworingService
    }
    // MARK: - Private methods
    private func sendNewAnswerRequest(_ answer: String) {
        adminNetworkingService.updateAppeal(by: appeal.id, answer) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newAppeal):
                self.appeal = newAppeal
                self.presenter.showData(appeal: newAppeal, contents: self.contents)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func sendHandledRequest() {
        adminNetworkingService.handledAppeal(appeal.id) { [weak self] error in
            if let error {
                self?.presenter.receivedError(error)
                return
            }
            self?.presenter.receivedSuccessHandled()
        }
    }

    private func receiveContents(completion: @escaping CompletionBlock) {
        let dispatchGroup = DispatchGroup()
        if !appeal.contents.isEmpty {
            for content in appeal.contents {
                dispatchGroup.enter()
                dataNetworingService.receiveImage(for: content.file) { [weak self] result in
                    guard let self else { return }
                    if case let .success(data) = result {
                        self.contents.append(DetailAppealContent(url: content.file,
                                                                 data: data))
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}
// MARK: - InputProtocol implementation 
extension DetailAppealInteractor: DetailAppealInteractorInputProtocol {
    func startingShowData() {
        receiveContents { [weak self] in
            guard let self else { return }
            self.presenter.showData(appeal: self.appeal, contents: self.contents)
        }
    }

    func saveNewAnswer(_ anwser: String) {
        sendNewAnswerRequest(anwser)
    }

    func handledAppeal() {
        sendHandledRequest()
    }

    func receiveURLContent(at index: Int) {
        guard index < appeal.contents.count else { return }
        let strURL = contents[index].url
        guard let url = URL(string: strURL) else { return }
        presenter.receivedURLContent(url)
    }
}
