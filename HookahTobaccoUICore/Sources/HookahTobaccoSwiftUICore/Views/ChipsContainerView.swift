//
//  ChipsContainerView.swift
//  
//
//  Created by Антон Кочетков on 10.07.2024.
//

import SwiftUI

public struct ChipModel: Hashable {
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
}

public struct ChipsContainerView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    
    // MARK: - States
    @State private var availableWidth: CGFloat = 0
    @State private var elementsSize: [Data.Element: CGSize] = [:]
    
    var data: Data
    
    // MARK: - Public properties
    var horizontalSpacing: CGFloat
    var verticalSpacing: CGFloat
    var alignment: HorizontalAlignment
    @ViewBuilder var content: (Data.Element) -> Content
    
    // MARK: - Initializer
    public init(
        data: Data,
        horizontalSpacing: CGFloat = 4,
        verticalSpacing: CGFloat = 4,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.alignment = alignment
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            // проверка на получение ширины экрана
            Color.clear
                .readSize { size in
                    availableWidth = size.width
                }
            
            VStack(alignment: alignment, spacing: verticalSpacing) {
                ForEach(getRows(), id: \.self) { row in
                    HStack(spacing: horizontalSpacing) {
                        ForEach(row, id: \.self) { clip in
                            content(clip)
                                .fixedSize()
                                .readSize { size in
                                    elementsSize[clip] = size
                                }
                        }
                    }
                }
            }
        }
    }
    
    private func getRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currectRow: [Data.Element] = []
        
        var totalWidth: CGFloat = 0
        
        data.forEach { clip in
            let clipSize = elementsSize[clip, default: CGSize(width: availableWidth, height: 1)]
            
            totalWidth += clipSize.width + horizontalSpacing
            if totalWidth > availableWidth {
                totalWidth = !currectRow.isEmpty || rows.isEmpty ? clipSize.width + horizontalSpacing : 0
                
                rows.append(currectRow)
                currectRow.removeAll()
                currectRow.append(clip)
            } else {
                currectRow.append(clip)
            }
        }
        
        if !currectRow.isEmpty {
            rows.append(currectRow)
            currectRow.removeAll()
        }
        
        return rows
    }
}

#if DEBUG
#Preview {
    ChipsContainerView(data: [
        ChipModel(title: "Test 1"),
        ChipModel(title: "Test 2"),
        ChipModel(title: "Test 3"),
        ChipModel(title: "Test 4"),
        ChipModel(title: "Test 5 Test 5 Test 5"),
        ChipModel(title: "Test 6"),
        ChipModel(title: "Test 7"),
        ChipModel(title: "Test 8 Test 8"),
        ChipModel(title: "Test 9"),
        ChipModel(title: "Test 10"),
        ChipModel(title: "Test 11 Test 11 Test 11 Test 11")
    ]) { clip in
        Text(clip.title)
            .lineLimit(1)
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .background(
                RoundedRectangle(cornerRadius: 12)
            )
    }
}
#endif
