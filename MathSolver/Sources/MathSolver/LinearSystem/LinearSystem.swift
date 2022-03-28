//
//  LinearSystem.swift
//  MathSolver
//
//  Created by Timur Guliamov on 27.03.2022.
//

import Foundation

struct LinearSystem {
    /// Количество переменных в системе.
    var size: Int { linearEquations.count }
    
    /// Определитель матрицы коефицентов `a`.
    func determinant(triangalized: Bool = false, k: Int = 0) -> Double {
        triangalized
        ? (0..<size).map{ linearEquations[$0][$0] }.reduce(1, *) * (k.isMultiple(of: 2) ? 1 : -1)
        : Self.calculateDeterminant(matrix: matrix)
    }
    
    /// Приведение к трекгольному преобладанию.
    /// Прямой ход
    func triangalized() -> (LinearSystem, Int) {
        var transformedLinearEquations = linearEquations
        /// Количество перестановок
        var k = 0
        
        for currentRowIndex in transformedLinearEquations.indices {
            /// Перестановка (если требуется)
            /// Находим первый ненулевой элемент.
            let notZeroRowEnumerated = transformedLinearEquations
                .enumerated()
                .dropFirst(currentRowIndex)
                .first { !$0.element[currentRowIndex].isZero }
            let notZeroRowIndex = notZeroRowEnumerated?.offset ?? currentRowIndex
            let currentRow = notZeroRowEnumerated?.element ?? transformedLinearEquations[currentRowIndex]
            /// Меняем местами текущую строку и строку с ненулевым элементом.
            if notZeroRowIndex != currentRowIndex { k += 1 }
            transformedLinearEquations.swapAt(notZeroRowIndex, currentRowIndex)
            
            guard !currentRow[currentRowIndex].isZero else { continue }
            
            /// Вычитаем текущий столбец из следующих.
            transformedLinearEquations = transformedLinearEquations.enumerated().map { index, row in
                guard index > currentRowIndex else { return row }
                let multiplier = -(row[currentRowIndex] / currentRow[currentRowIndex])
                return  row + (multiplier * currentRow)
            }
        }
        return (LinearSystem(linearEquations: transformedLinearEquations), k)
    }
    
    /// Найти корни линейного уравнения.
    /// Обратный ход.
    func calculate(triangalized: Bool = true) -> [Double] {
        var transformedLinearEquations = triangalized
            ? linearEquations
            : self.triangalized().0.linearEquations
        
        for currentRowIndex in transformedLinearEquations.indices.reversed() {
            let currentRow = transformedLinearEquations[currentRowIndex]
            
            guard !currentRow[currentRowIndex].isZero else { continue }
            
            transformedLinearEquations = transformedLinearEquations.enumerated().map { index, row in
                guard index < currentRowIndex else { return row }
                let multiplier = -(row[currentRowIndex] / currentRow[currentRowIndex])
                return  row + (multiplier * currentRow)
            }
        }
        return transformedLinearEquations.enumerated().map { $1.b / $1[$0] }
    }
    
    /// Расчет вектора невязок.
    func residualVector(for solution: [Double]) -> [Double]? {
        guard size == solution.count else { return nil }
        return linearEquations.map { $0.residual(for: solution) }
    }
    
    init(linearEquations: [LinearEquation]) {
        self.linearEquations = linearEquations
    }
    
    private let linearEquations: [LinearEquation]
    
    private var matrix: [[Double]] {
        linearEquations.map { linearEquation in
            (0..<size).map { linearEquation[$0] }
        }
    }
}

// MARK: - Determinant

extension LinearSystem {
    /// Рекурсивный рачет определителя.
    private static func calculateDeterminant(matrix: [[Double]]) -> Double {
        guard matrix.count > 1 else { return matrix[0][0] }
        
        var sum: Double = 0
        var polarity: Double = 1
        
        let topRow = matrix[0]
        for (column, value) in topRow.enumerated() {
            var subMatrix = matrix
            subMatrix.removeRow(0)
            subMatrix.removeColumn(column)
            sum += polarity * value * calculateDeterminant(matrix: subMatrix)
            
            polarity *= -1
        }
        
        return sum
    }
}

// MARK: - CustomStringConvertible

extension LinearSystem: CustomStringConvertible {
    var description: String {
        zip(matrix, linearEquations).map {
            let coeficentsString = $0.0
                .map { String($0) }
                .joined(separator: " ")
            return "\(coeficentsString) | \($0.1.b)"
        }.joined(separator: "\n")
    }
}
