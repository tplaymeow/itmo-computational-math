//
//  Collection+safe.swift
//  
//
//  Created by Timur Guliamov on 08.02.2022.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension MutableCollection {
    subscript (safe index: Index) -> Element? {
        get { indices.contains(index) ? self[index] : nil }
        set {
            guard let newValue = newValue,
                  indices.contains(index) else { return }
            self[index] = newValue
        }
    }
}
