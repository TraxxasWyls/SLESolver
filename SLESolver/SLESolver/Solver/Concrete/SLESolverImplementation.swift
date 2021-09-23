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
        return calculateSolve(linearizedMatrix)
    }
}
