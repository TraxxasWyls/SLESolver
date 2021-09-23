//
//  DetComputeImplementation.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 17.09.2021.
//

import Foundation

// MARK: - DetError

public enum DetError: Error {
    case notSquareMatrix
}

// MARK: - DetComputeImplementation

public final class DetComputeImplementation {

    // MARK: - Properties

    /// MatrixLinearizer instance
    private let linearizer: MatrixLinearizer = MatrixLinearizerImplementation()

    // MARK: - Initializers

    public init() { }

    // MARK: - Private

    private func multiplyDiagonal(_ matrix: MutableMatrix) -> Double {
        var i = -1
        return matrix.elementsArray.reduce(1) {
            i += 1
            return $0 * $1[i]
        }
    }
}

// MARK: - DetCompute

extension DetComputeImplementation: DetCompute {

    public func calculateDet(_ matrix: MutableMatrix) throws -> Double {
        guard matrix.isSquare else { throw DetError.notSquareMatrix }
        do {
            let linearizedMatrix = try linearizer.liniarize(matrix)
            let sign = linearizer.linesSwapCount.isMultiple(of: 2) ? 1.0 : -1.0
            return multiplyDiagonal(linearizedMatrix) / linearizer.detMultiplyer * sign
        } catch {
            return 0
        }
    }
}
