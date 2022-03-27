//
//  Collection+safe.swift
//  MathSolver
//
//  Created by Timur Guliamov on 27.03.2022.
//

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
