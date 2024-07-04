//
//  DetailTobaccoViewModel.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 04.07.2024.
//

import Foundation

// TODO: - переименовать протокол
protocol DetailTobaccoViewModelOb: ObservableObject {
    var name: String { get }
    var imageURL: URL? { get }
    var tastes: [String] { get }
    var info: [DescriptionStackViewItem] { get }
    var description: String { get }
    var nameManufacturer: String { get }
}

final class DetailTobaccoViewModelImpl: DetailTobaccoViewModelOb {
    @Published private(set) var name: String = ""
    @Published private(set) var imageURL: URL?
    @Published private(set) var tastes: [String] = []
    @Published private(set) var info: [DescriptionStackViewItem] = []
    @Published private(set) var description: String = ""
    @Published private(set) var nameManufacturer: String = ""
    
    private var tobacco: Tobacco
    
    init(tobacco: Tobacco) {
        self.tobacco = tobacco
        
        self.name = tobacco.name
        self.imageURL = URL(string: tobacco.imageURL)
        self.tastes = tobacco.tastes.map { $0.taste }
        self.info = createInfo(tobacco: tobacco)
        self.description = (
            !tobacco.description.isEmpty ?
            R.string.localizable.detailTobaccoDescriptionTitle(tobacco.description) :
            ""
        )
        self.nameManufacturer = tobacco.nameManufacturer
    }
    
    private func createInfo(tobacco: Tobacco) -> [DescriptionStackViewItem] {
        let packetingFormat = tobacco.line.packetingFormat
            .compactMap {
                String($0) + R.string.localizable.generalGram()
            }
            .joined(separator: ", ")
        
        let tobaccoLeafType = (
            tobacco.line.tobaccoType.rawValue == TobaccoType.tobacco.rawValue ?
            tobacco.line.tobaccoLeafType?.map { $0.name }.joined(separator: ", ") :
            nil
        )
        
        var info: [DescriptionStackViewItem] = []
        if !tobacco.line.isBase {
            info.append(DescriptionStackViewItem(
                name: R.string.localizable.detailTobaccoNameLineTitle(),
                description: tobacco.line.name
            ))
        }
        info.append(DescriptionStackViewItem(
            name: R.string.localizable.detailTobaccoPackagingFormatTitle(),
            description: packetingFormat
        ))
        info.append(DescriptionStackViewItem(
            name: R.string.localizable.detailTobaccoTobaccoTypeTitle(),
            description: tobacco.line.tobaccoType.name
        ))
        if let tobaccoLeafType {
            info.append(DescriptionStackViewItem(
                name: R.string.localizable.detailTobaccoTobaccoLeafTypeTitle(),
                description: tobaccoLeafType
            ))
        }
        
        return info
    }
}
