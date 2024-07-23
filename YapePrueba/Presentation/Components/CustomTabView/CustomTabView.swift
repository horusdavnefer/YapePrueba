//
//  CustomTabView.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Foundation
import SwiftUI
struct CustomTabView<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {
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
        return ScrollView(.vertical, showsIndicators: false) {
            
            ScrollView {
                VStack() {
                    ForEach(0 ..< (data.isEmpty ? quantity : data.count), id: \.self) { index in
                        self.content(index, self.data.isEmpty, self.data.isEmpty ? nil : self.data.map { $0 }[index])
                    }
               
                }
            }
        }
    }
}
extension View {
    /// A backwards compatible wrapper for iOS 14 `onChange`
   /* @ViewBuilder func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { (value) in
                onChange(value)
            }
        }
    }*/
}

