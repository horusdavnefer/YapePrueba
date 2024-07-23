//
//  SkeletonForEachWithIndex.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Foundation

import SkeletonUI
import SwiftUI

struct SkeletonForEachWithIndex<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {
    private let data: Data
    private let quantity: Int
    private let content: (Int, Bool, Data.Element?, CellType) -> Content
    private let cellType: CellType

    init(with data: Data,
         quantity: Int = 1,
         cellType: CellType = .vertically,
         @ViewBuilder content: @escaping (Int, Bool, Data.Element?, CellType) -> Content)
    {
        self.data = data
        self.quantity = quantity
        self.cellType = cellType
        self.content = content
    }

    var body: some View {
        
        if #available(iOS 14.0, *) {
            let fistColumn: [GridItem] = [
                GridItem()
            ]
            
            let twoColumns: [GridItem] = [
                GridItem(),
                GridItem()
            ]
            LazyVGrid(columns: cellType == .horizontal ? twoColumns : fistColumn, alignment: .center, spacing: 24) {
                ForEach(0 ..< (data.isEmpty ? quantity : data.count), id: \.self) { index in
                    self.content(index, self.data.isEmpty, self.data.isEmpty ? nil : self.data.map { $0 }[index] , self.cellType)
                }
            }
            
        } else {
            /*UIGrid(columns: cellType == .horizontal ? 2 : 1, list: data.li) { data in
                self.content(index, self.data.isEmpty, self.data.isEmpty ? nil : self.data.map { $0 }[index], self.cellType)
            }*/
        }
        
        
    }
}
