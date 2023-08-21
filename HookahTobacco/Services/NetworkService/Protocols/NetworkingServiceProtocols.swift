//
//  NetworkingServiceProtocols.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.08.2023.
//

import Foundation

protocol GetDataNetworkingServiceProtocol {
    func receiveData<T: DataNetworkingServiceProtocol>(type: T.Type,
                                                       completion: CompletionResultBlock<[T]>?)
    func getImage(for url: String, completion: CompletionResultBlock<Data>?)
    func getTobaccos(for manufacturer: Manufacturer, completion: CompletionResultBlock<[Tobacco]>?)
    func getDataBaseVersion(completion: CompletionResultBlock<Int>?)
}

protocol UserNetworkingServiceProtocol {
    func receiveUser(completion: CompletionResultBlock<UserProtocol>?)
//    func updateUser(_ user: UserProtocol, completion: CompletionResultBlock<UserProtocol>?)
    func receiveFavoriteTobaccos(completion: CompletionResultBlock<[Tobacco]>?)
    func receiveWantToBuyTobaccos(completion: CompletionResultBlock<[Tobacco]>?)
//    func updateFavoriteTobacco(_ tobaccos: [Tobacco], completion: CompletionResultBlock<[Tobacco]>?)
//    func updateWantToBuyTobacco(_ tobaccos: [Tobacco], completion: CompletionResultBlock<[Tobacco]>?)
}

protocol AdminNetworkingServiceProtocol {
    func addData<T: DataNetworkingServiceProtocol>(_ data: T, completion: CompletionResultBlock<T>?)
    func setData<T: DataNetworkingServiceProtocol>(_ data: T, completion: CompletionResultBlock<T>?)
    func setDBVersion(_ newVersion: Int, completion: CompletionBlockWithParam<HTError?>?)
}
