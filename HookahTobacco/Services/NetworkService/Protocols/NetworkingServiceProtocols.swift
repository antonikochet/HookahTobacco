//
//  NetworkingServiceProtocols.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation
import HookahTobaccoCore

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
    func receiveFavoriteTobaccos(page: Int, completion: ResultBlock<PageResponse<Tobacco>>?)
    func receiveWantToBuyTobaccos(page: Int, completion: ResultBlock<PageResponse<Tobacco>>?)
    func updateFavoriteTobacco(_ tobaccos: [Tobacco], completion: ResultBlock<[Tobacco]>?)
    func updateWantToBuyTobacco(_ tobaccos: [Tobacco], completion: ResultBlock<[Tobacco]>?)
}

protocol AdminNetworkingServiceProtocol {
    func addData<T: DataNetworkingServiceProtocol>(_ data: T, completion: ResultBlock<T>?)
    func setData<T: DataNetworkingServiceProtocol>(_ data: T, completion: ResultBlock<T>?)
    func setDBVersion(_ newVersion: Int, completion: BlockWithParam<HTError?>?)
}
