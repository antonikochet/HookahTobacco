//
//  TobaccoListAssembly.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 16.07.2024.
//

import Swinject
import UIKit
import SwiftUI
import HookahTobaccoCore

final class TobaccoListAssembly: AssemblyProtocol {
    
    private let filter: TobaccoListInput
    private let showDetailTobacco: BlockWithParam<Tobacco>
    private let showFilterTobacco: BlockWithParam<(filters: TobaccoFilter?, delegate: TobaccoFiltersOutputModule)>
    
    init(
        filter: TobaccoListInput,
        showDetailTobacco: @escaping BlockWithParam<Tobacco>,
        showFilterTobacco: @escaping BlockWithParam<(filters: TobaccoFilter?, delegate: TobaccoFiltersOutputModule)>
    ) {
        self.filter = filter
        self.showDetailTobacco = showDetailTobacco
        self.showFilterTobacco = showFilterTobacco
    }
    
    func assemble(resolver: Resolver) -> UIViewController {
        let viewModel = TobaccoListViewModelImpl(
            input: filter,
            tobaccoRepo: resolver.resolve(TobaccoRepoProtocol.self)!,
            favoriteTobaccoRepo: resolver.resolve(FavoriteTobaccoRepoProtocol.self)!,
            wantBuyTobaccoRepo: resolver.resolve(WantBuyTobaccoRepoProtocol.self)!,
            imageManager: resolver.resolve(ImageManagerProtocol.self)!,
            showDetailTobacco: showDetailTobacco,
            showFilterTobacco: showFilterTobacco
            
        )
        let view = TobaccoListView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}
