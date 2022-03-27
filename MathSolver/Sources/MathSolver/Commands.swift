//
//  main.swift
//  MathSolver
//
//  Created by Timur Guliamov on 27.03.2022.
//

import ArgumentParser

@main
struct MainCommand: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
        commandName: "MathSolver",
        version: "0.0.1",
        subcommands: [GaussSLAE.self]
    )
}

struct GaussSLAE: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
        commandName: "gauss",
        abstract: "Solves SLAE by gauss method"
    )
    
    @Option(name: .shortAndLong, help: "")
    var file: String?

    func run() throws {
        let slae = try readLinearSystem()
        
        print("\n\n-- Solve --\n\n")
        print("Linear system:\n\(slae)\n")
        
        let determinant = slae.determinant
        print("Determinant: \(determinant)\n")
        
        let triangalizedSLAE = slae.triangalized()
        print("Triangalized:\n\(triangalizedSLAE)\n")
        
        let solution = triangalizedSLAE.calculate()
        print("Solution: \(solution)\n")
        
        let residualVector = slae.residualVector(for: solution)!
        print("Residual vector: \(residualVector)\n")
    }
}

// MARK: - Input

extension GaussSLAE {
    private func readLinearSystem() throws -> LinearSystem {
        if let filePath = file {
            let fileContent = try String(contentsOfFile: filePath)
            let matrix = fileContent
                .components(separatedBy: .newlines)
                .map { $0.components(separatedBy: .whitespaces) }
                .map { $0.compactMap(Double.init) }
                .compactMap { (numbers: [Double]) -> LinearEquation? in
                    guard let result = numbers.last else { return nil }
                    return LinearEquation(numbers.dropLast(), result)
                }
            return LinearSystem(linearEquations: matrix)
        }
        
        print("Type number of lines: ")
        let numberOflines = readLine().flatMap(Int.init)!
        
        print("\nType \(numberOflines) lines:")
        let matrix = (0..<numberOflines)
            .compactMap { _ in readLine() }
            .map { $0.components(separatedBy: .whitespaces) }
            .map { $0.compactMap(Double.init) }
            .compactMap { (numbers: [Double]) -> LinearEquation? in
                guard let result = numbers.last else { return nil }
                return LinearEquation(numbers.dropLast(), result)
            }

        return LinearSystem(linearEquations: matrix)
    }
}
