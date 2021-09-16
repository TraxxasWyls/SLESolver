//
//  SLESolverImplementation.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - SLESolverImplementation

public final class SLESolverImplementation {

    // MARK: - Properties

    /// MatrixLinearizer instance
    private let linearizer: MatrixLinearizer = MatrixLinearizerImplementation()

    // MARK: - Initializers

    public init() { }

    // MARK: - Private

    private func sortByDiagonal(_ matrix: Matrix) -> Matrix {
        var linePositions = [Int: Int]()
        var lineIndex = -1
        matrix.elementsArray.forEach { line in
            lineIndex += 1
            if let elementIndex = line.firstIndex(where: { $0 != .zero }) {
                linePositions[lineIndex] = elementIndex
            }
        }
        var resultArray = [[Double]]()
        linePositions.keys.forEach {
            if let inserationIndex = linePositions[$0] {
                resultArray.insert(matrix.line(withIndex: $0), at: inserationIndex)
            }
        }
        matrix.elementsArray = resultArray
        return matrix
    }

    private func calculateSolve(_ matrix: Matrix) -> Result {
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

    public func solve(_ matrix: Matrix) -> Result {
        let linearizedMatrix = linearizer.liniarize(matrix)
        let sortedMatrix = sortByDiagonal(linearizedMatrix)
        print(sortedMatrix)
        return calculateSolve(sortedMatrix)
    }
}
