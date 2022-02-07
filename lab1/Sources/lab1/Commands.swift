import ArgumentParser

struct MainCommand: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
        commandName: "lab1",
        abstract: "Утилита для решения СЛАУ",
        version: "0.0.1",
        subcommands: [SolveCommand.self]
    )
}

struct SolveCommand: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
        commandName: "solve",
        abstract: "Решает СЛАУ методом простых итераций"
    )

    func run() throws {
        print("Hello World!!!")
    }
}
