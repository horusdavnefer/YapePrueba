//
//  CarouselView.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import SwiftUI

struct CarouselView<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {
    @State var index = 0
    private let data: Data
    private let quantity: Int
    private let content: (Int, Bool, Data.Element?) -> Content
    
    init(with data: Data,
         quantity: Int = 1,
         @ViewBuilder content: @escaping (Int, Bool, Data.Element?) -> Content) {
        self.data = data
        self.quantity = quantity
        self.content = content
    }
    
    var body: some View {
        if #available(iOS 14.0, *) {
            TabView(selection: $index) {
                ForEach(0 ..< (data.isEmpty ? quantity : data.count), id: \.self) { index in
                    self.content(index, self.data.isEmpty, self.data.isEmpty ? nil : self.data.map { $0 }[index])
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        } else {
            TabView(selection: $index) {
                ForEach(0 ..< (data.isEmpty ? quantity : data.count), id: \.self) { index in
                    self.content(index, self.data.isEmpty, self.data.isEmpty ? nil : self.data.map { $0 }[index])
                }
            }
        }
        
            
    }
}
