//
//  ManufacturerCellView.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 16.07.2024.
//

import SwiftUI

struct ManufacturerCellViewModel {
    let id: Int
    let name: String
    let county: String
    let imageURL: String
}

struct ManufacturerCellView: View {
    
    var viewModel: ManufacturerCellViewModel
    
    var body: some View {
        HStack {
            HTImage(imageURL: viewModel.imageURL)
                .frame(width: 90, height: 90)
                .clipShape(.rect(cornerRadius: 16))
                .background(R.color.primaryWhite.color)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.name)
                    .font(.appFont(size: 24, weight: .semibold))
                Text(viewModel.county)
                    .font(.appFont(size: 18, weight: .medium))
                Spacer()
            }
            .foregroundStyle(R.color.primaryBlack.color)
            .minimumScaleFactor(0.6)
            
            Spacer()
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(R.color.secondaryBackground.color)
        )
    }
}

#Preview {
    let manufacturer = Manufacturer.mock()
    let viewModel = ManufacturerCellViewModel(
        id: manufacturer.uid,
        name: manufacturer.name,
        county: manufacturer.country.name,
        imageURL: manufacturer.urlImage
    )
    return ManufacturerCellView(viewModel: viewModel)
        .frame(height: 116)
        .padding(.horizontal, 8)
}
