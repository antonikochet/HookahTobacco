//
//  NetworkingServiceProtocols.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation

protocol GetDataNetworkingServiceProtocol {
    func receiveData<T: DataNetworkingServiceProtocol>(type: T.Type,
                                                       completion: ResultBlock<[T]>?)
    func receiveTobacco(page: Int,
                        search: String?,
                        filters: TobaccoFilters?,
                        completion: ResultBlock<PageResponse<Tobacco>>?)
    func receiveTobaccoFilters(completion: ResultBlock<TobaccoFilters>?)
    func updateTobaccoFilters(filters: TobaccoFilters, completion: ResultBlock<TobaccoFilters>?)
    func receiveImage(for url: String, completion: ResultBlock<Data>?)
    func receiveTobaccos(for manufacturer: Manufacturer, completion: ResultBlock<[Tobacco]>?)
}

protocol UserNetworkingServiceProtocol {
    func receiveUser(completion: ResultBlock<UserProtocol>?)
    func updateUser(_ user: RegistrationUserProtocol, completion: ResultBlock<UserProtocol>?)
    func receiveFavoriteTobaccos(page: Int, completion: ResultBlock<PageResponse<Tobacco>>?)
    func receiveWantToBuyTobaccos(page: Int, completion: ResultBlock<PageResponse<Tobacco>>?)
    func updateFavoriteTobacco(_ tobaccos: [Tobacco], completion: ResultBlock<[Tobacco]>?)
    func updateWantToBuyTobacco(_ tobaccos: [Tobacco], completion: ResultBlock<[Tobacco]>?)
    func receiveAgreementURLs(_ types: [TypeAgreementURLs], completion: ResultBlock<[AgreementURLsResponse]>?)
}

protocol AppealsNetworkingServiceProtocol {
    func receiveThemes(completion: ResultBlock<ThemesAppealsResponse>?)
    func createAppeal(_ appeal: CreateAppealEntity, completion: ResultBlock<CreateAppealResponse>?)
}

protocol AdminNetworkingServiceProtocol {
    func addData<T: DataNetworkingServiceProtocol>(_ data: T, completion: ResultBlock<T>?)
    func setData<T: DataNetworkingServiceProtocol>(_ data: T, completion: ResultBlock<T>?)
    func setDBVersion(_ newVersion: Int, completion: BlockWithParam<HTError?>?)
    func receiveAppeals(page: Int,
                        status: AppealStatus?,
                        themes: [ThemeAppeal],
                        completion: ResultBlock<PageResponse<AppealResponse>>?)
    func updateAppeal(by id: Int, _ answer: String, completion: ResultBlock<AppealResponse>?)
    func handledAppeal(_ id: Int, completion: BlockWithParam<HTError?>?)
}
