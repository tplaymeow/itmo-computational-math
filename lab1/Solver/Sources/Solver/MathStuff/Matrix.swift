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
    enum SubmatrixError: Error {
        case commonError
    }

    func submatrix(
        startRow: Int,
        startColumn: Int,
        size: Size
    ) -> Result<Matrix<T>, SubmatrixError> {
        Matrix.create(
            size: size,
            elements: elements.dropFirst(startRow).prefix(size.rows)
                .map { $0.dropFirst(startColumn).prefix(size.columns) }
                .map(Array.init)
        ).mapError(Self.transform)
    }

    func submatrix(
        startRow: Int,
        startColumn: Int,
        endRow: Int,
        endColumn: Int
    ) -> Result<Matrix<T>, SubmatrixError> {
        submatrix(
            startRow: startRow,
            startColumn: startColumn,
            size: .init(
                rows: endRow - startRow + 1,
                columns: endColumn - startColumn + 1
            )
        )
    }

    private static func transform(_ error: CreationError) -> SubmatrixError {
        return .commonError
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
