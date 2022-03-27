//
//  2DArray+remove.swift
//  MathSolver
//
//  Created by Timur Guliamov on 27.03.2022.
//

extension Array where Element == [Double] {
    mutating func removeRow(_ index: Int) {
        remove(at: index)
    }
    
    mutating func removeColumn(_ index: Int) {
        self = map { column in
            var transformedColumn = column
            transformedColumn.remove(at: index)
            return transformedColumn
        }
    }
}
