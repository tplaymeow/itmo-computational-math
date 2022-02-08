//
//  Commands.swift
//  
//
//  Created by Timur Guliamov on 08.02.2022.
//

import ArgumentParser

@main
struct MainCommand: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
        commandName: "Solver",
        abstract: "Systems of linear equations solver",
        version: "0.0.1",
        subcommands: [SimpleIterationCommand.self]
    )
}

struct SimpleIterationCommand: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
        commandName: "simple-iter",
        abstract: "Solves SLAE by simple iterations method"
    )

    func run() throws {
        print("Hello World!!!")
    }
}
