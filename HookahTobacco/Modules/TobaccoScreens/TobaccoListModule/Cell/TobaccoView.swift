//
//  TobaccoView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 05.07.2024.
//

import SwiftUI

struct TobaccoViewModel {
    let id: String
    let imageURL: String
    let name: String
    let tasty: String
    let manufacturerName: String
    var isFavorite: Bool
    var isWantBuy: Bool
    var isShowWantBuyButton: Bool
    
    var favoriteAction: VoidBlock?
    var wantBuyAction: VoidBlock?
    
    init(
        _ tobacco: Tobacco,
        isShowWantBuyButton: Bool,
        favoriteAction: VoidBlock? = nil,
        wantBuyAction: VoidBlock? = nil
    ) {
        self.id = tobacco.id
        self.imageURL = tobacco.imageURL
        self.name = tobacco.name
        self.tasty = tobacco.tastes.map { $0.taste }.joined(separator: ", ")
        self.manufacturerName = tobacco.nameManufacturer
        self.isFavorite = tobacco.isFavorite
        self.isWantBuy = tobacco.isWantBuy
        self.isShowWantBuyButton = isShowWantBuyButton
        self.favoriteAction = favoriteAction
        self.wantBuyAction = wantBuyAction
    }
}

struct TobaccoView: View {
    
    let viewModel: TobaccoViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            HTImage(imageURL: viewModel.imageURL)
                .frame(width: 90, height: 90)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 16).fill(.white))
            
            VStack(alignment: .trailing) {
                topInfoView
                Spacer()
                    .frame(minHeight: 0, maxHeight: 32)
                Text(viewModel.manufacturerName)
                    .font(.appFont(size: 20, weight: .semibold))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 16)
            .fill(R.color.secondaryBackground.color))
    }
    
    var topInfoView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.appFont(size: 20, weight: .semibold))
                    .lineLimit(2)
                
                Text(viewModel.tasty)
                    .font(.appFont(size: 14, weight: .regular))
                    .lineLimit(3)
            }
            .padding(.trailing, 8)
            
            Spacer()
            
            VStack {
                SwiftUI.Button {
                    viewModel.favoriteAction?()
                } label: {
                    (viewModel.isFavorite ? R.image.heartFill : R.image.heart).image
                }
                
                if viewModel.isShowWantBuyButton {
                    SwiftUI.Button {
                        viewModel.wantBuyAction?()
                    } label: {
                        (viewModel.isWantBuy ? R.image.basketFill : R.image.basket).image
                    }
                }
            }
        }
    }
}

#Preview {
    let tobacco = Tobacco.mock()
    return TobaccoView(viewModel: TobaccoViewModel(
        tobacco,
        isShowWantBuyButton: true
    ))
    .previewLayout(.fixed(width: 375, height: 100))
    .padding(8)
}
