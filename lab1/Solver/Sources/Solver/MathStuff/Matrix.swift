//
//  Matrix.swift
//  
//
//  Created by Timur Guliamov on 08.02.2022.
//

import Foundation

struct Matrix<T> {
    let rowsCount: Int
    let columnsCount: Int
    private var elements: [[T]]

    private init(
        rowsCount: Int,
        columnsCount: Int,
        elements: [[T]]
    ) {
        self.rowsCount = rowsCount
        self.columnsCount = columnsCount
        self.elements = elements
    }
}

// MARK: - Size

extension Matrix {
    struct Size { let rows: Int, columns: Int }

    var size: Matrix.Size {
        Size(rows: self.rowsCount, columns: self.columnsCount)
    }
}

// MARK: - Getters

extension Matrix {
    subscript (row row: Int, column column: Int) -> T? {
        get { self.elements[safe: row]?[safe: column] }
        set { self.elements[safe: row]?[safe: column] = newValue }
    }

    subscript (row row: Int) -> [T]? {
        self.elements[safe: row]
    }

    subscript (column column: Int) -> [T]? {
        guard column < self.columnsCount else { return nil }
        return self.elements.compactMap { $0[safe: column] }
    }
}

// MARK: - Submatrix

extension Matrix {
    func submatrix(
        startRow: Int,
        startColumn: Int,
        size: Size
    ) -> Matrix<T> {
        
    }
}

// MARK: - Creation

extension Matrix {
    enum CreationError: Error {
        case zeroOrNegativeRows
        case zeroOrNegativeColumns
        case badRowsCount
        case badColumnsCount
    }

    static func create<T>(
        size: Size,
        elements: [[T]]
    ) -> Result<Matrix<T>, CreationError> {
        return Self.create(
            rows: size.rows,
            columns: size.columns,
            elements: elements)
    }

    static func create<T>(from elements: [[T]]) -> Result<Matrix<T>, CreationError> {
        guard let columnsCount = elements.first?.count
        else { return .failure(.zeroOrNegativeRows) }

        return Self.create(
            rows: elements.count,
            columns: columnsCount,
            elements: elements)
    }

    static func create<T>(
        size: Size,
        repeating value: T
    ) -> Matrix<T> {
        let row = Array(repeating: value, count: size.columns)
        let rows = Array(repeating: row, count: size.rows)
        return .init(
            rowsCount: size.rows,
            columnsCount: size.columns,
            elements: rows)
    }

    static func createZeroes<T: Numeric>(size: Size) -> Matrix<T> {
        Matrix.create(size: size, repeating: T.zero)
    }

    private static func create<T>(
        rows: Int,
        columns: Int,
        elements: [[T]]
    ) -> Result<Matrix<T>, CreationError> {
        guard rows > .zero else { return .failure(.zeroOrNegativeRows) }
        guard columns > .zero else { return .failure(.zeroOrNegativeColumns) }

        guard elements.count == rows else { return .failure(.badRowsCount) }
        guard elements.allSatisfy({ $0.count == columns }) else { return .failure(.badColumnsCount) }

        return .success(.init(
            rowsCount: rows,
            columnsCount: columns,
            elements: elements))
    }
}
