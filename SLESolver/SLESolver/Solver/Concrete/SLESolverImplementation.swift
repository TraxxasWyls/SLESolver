//
//  SLESolverImplementation.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - SolvingError

public enum SolvingError: Error {
    case eternity
    case zeroSolutions
}

// MARK: - SLESolverImplementation

public final class SLESolverImplementation {

    // MARK: - Properties

    /// MatrixLinearizer instance
    private let linearizer: MatrixLinearizer = MatrixLinearizerImplementation()

    // MARK: - Initializers

    public init() { }

    // MARK: - Private

    private func sortByDiagonal(_ matrix: MutableMatrix) -> MutableMatrix {
        var linePositions = [Int: Int]()
        var lineIndex = -1
        matrix.elementsArray.forEach { line in
            lineIndex += 1
            if let elementIndex = line.firstIndex(where: { $0 != .zero }) {
                linePositions[lineIndex] = elementIndex
            }
        }
        let sortedLinePositions = linePositions.sorted { $0.value < $1.value }
        matrix.elementsArray = sortedLinePositions.map { matrix.line(withIndex: $0.key) }
        return matrix
    }

    private func calculateSolve(_ matrix: MutableMatrix) -> Result {
        var result = Result()
        let array = matrix.elementsArray
        let lineLenght = array[0].count
        for i in 0..<matrix.elementsArray.count {
            result.append(array[i][lineLenght - 1] / array[i][i])
        }
        return result
    }
}

// MARK: - SLESolverImplementation

extension SLESolverImplementation: SLESolver {

    public func solve(_ matrix: MutableMatrix) throws -> Result {
        let linearizedMatrix = try linearizer.liniarize(matrix)
        let sortedMatrix = sortByDiagonal(linearizedMatrix)
        print(sortedMatrix)
        return calculateSolve(sortedMatrix)
    }
}
