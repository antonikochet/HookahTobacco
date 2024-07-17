//
//  DetailManufacturerTobaccoLineView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 17.07.2024.
//

import SwiftUI

struct DetailManufacturerTobaccoLineViewModel: Identifiable {
    let id: Int
    let title: String
    let description: String
    let tobaccos: [TobaccoViewModel]
}

struct DetailManufacturerTobaccoLineView<Content: View>: View {
    
    var title: String
    var description: String
    @ViewBuilder var content: () -> Content
    
    @State private var isShowRows: Bool = true
    
    var body: some View {
        Section {
            if isShowRows {
                content()
            }
        } header: {
            header
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.appFont(size: 20.0, weight: .medium))
                    .foregroundStyle(R.color.primaryTitle.color)
                Spacer()
                SwiftUI.Button {
                    isShowRows.toggle()
                } label: {
                    isShowRows ? R.image.chevronDown.image : R.image.chevronUp.image
                }
            }
            
            Text(description)
                .font(.appFont(size: 16.0, weight: .regular))
                .foregroundStyle(R.color.primarySubtitle.color)
        }
        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(R.color.thirdBackground.color)
        )
    }
}

#Preview {
    let viewModelsTobaccos = Tobacco.arrayMock(8).map { tobacco in
        TobaccoViewModel(
            tobacco,
            isShowWantBuyButton: false,
            favoriteAction: {
                print(tobacco.uid)
            }
        )
    }
    let tobaccoLine = TobaccoLine.mock()
    
    return ScrollView {
        DetailManufacturerTobaccoLineView(
            title: tobaccoLine.name,
            description: tobaccoLine.description) {
                ForEach(viewModelsTobaccos, id: \.id) { viewModel in
                    TobaccoView(viewModel: viewModel)
                }
            }
            .padding(.horizontal, 8)
    }
}
