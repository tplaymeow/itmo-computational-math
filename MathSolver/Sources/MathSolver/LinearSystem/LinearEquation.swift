//
//  LinearEquation.swift
//  MathSolver
//
//  Created by Timur Guliamov on 27.03.2022.
//

struct LinearEquation {
    /// Количество переменных.
    var size: Int { coefficients.count }
    
    /// Коефицент `b`.
    var b: Double { result }
    
    /// Коефицент `a` при  n-ой переменной.
    subscript (index: Int) -> Double {
        coefficients[safe: index] ?? .zero
    }
    
    /// Расчет невязки.
    func residual(for solution: [Double]) -> Double {
        zip(solution, coefficients, default: 0).map(*).reduce(0, +) - result
    }
    
    init(_ coefficients: [Double], _ result: Double) {
        self.coefficients = coefficients
        self.result = result
    }
    
    private let coefficients: [Double]
    private let result: Double
}

// MARK: - Operators

extension LinearEquation {
    public static func *(lhs: Double, rhs: LinearEquation) -> LinearEquation {
        LinearEquation(
            rhs.coefficients.map { $0 * lhs },
            lhs * rhs.result)
    }
    
    public static func +(lhs: LinearEquation, rhs: LinearEquation) -> LinearEquation {
        LinearEquation(
            zip(lhs.coefficients, rhs.coefficients, default: 0).map(+),
            lhs.result + rhs.result)
    }
    
    public static func -(lhs: LinearEquation, rhs: LinearEquation) -> LinearEquation {
        lhs + (-1 * rhs)
    }
}
