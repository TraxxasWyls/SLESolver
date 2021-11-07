//
//  ReverseMatrixComputeImplementation.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 24.09.2021.
//

import Foundation

// MARK: - Aliases

public typealias Matrix = [[Double]]

// MARK: - ReverseMatrixError

public enum ReverseMatrixError: Error {
    case notExist
}

// MARK: - ReverseMatrixComputeImplementation

public final class ReverseMatrixComputeImplementation {

    // MARK: - Properties

    /// MatrixLinearizer instance
    private let linearizer: MatrixLinearizer = MatrixLinearizerImplementation()

    /// LUExpansion instance
    private let luExpander: LUExpansion = LUExpansionImplementation()

    // MARK: - Initializers

    public init() { }

    // MARK: - Liniarized Conversion

    private func convertToReverse(_ matrix: MutableMatrix) -> MutableMatrix {
        for i in 0..<matrix.elementsArray.count {
            matrix.multiply(rowWithIndex: i, to: 1 / matrix.elementsArray[i][i])
            matrix.elementsArray[i].removeSubrange(0...(matrix.elementsArray[i].count / 2 - 1))
        }
        return matrix
    }

    private func extendMatrix(_ matrix: MutableMatrix) throws -> MutableMatrix {
        guard matrix.isSquare else { throw DetError.notSquareMatrix }
        let extended = MutableMatrix.createOneMatrix(ofSize: matrix.elementsArray.count)
        for i in 0..<matrix.elementsArray.count {
            matrix.elementsArray[i].append(contentsOf: extended.elementsArray[i])
        }
        return matrix
    }

    // MARK: - LU Convertion

    private func calculateDiagonalElements(matrix: inout Matrix, uMatrix: Matrix, j: Int) throws {
        guard SLESolverImplementation.diagonalNonZero(MutableMatrix(uMatrix)) else { throw SolvingError.dividedByZero }
        var sum = 0.0
        guard j+1 < matrix.count else {
            matrix[j][j] = 1 / uMatrix[j][j]
            return
        }
        for k in (j+1)..<matrix.count {
            sum += uMatrix[j][k] * matrix[k][j]
        }
        matrix[j][j] = (1-sum) / uMatrix[j][j]
    }

    private func calculateAboveDiagonalElements(matrix: inout Matrix, uMatrix: Matrix, i: Int, j: Int) throws {
        guard SLESolverImplementation.diagonalNonZero(MutableMatrix(uMatrix)) else { throw SolvingError.dividedByZero }
        guard i < j else { return }
        var sum = 0.0
        for k in (i+1)..<matrix.count {
            sum += uMatrix[i][k] * matrix[k][j]
        }
        matrix[i][j] = -sum / uMatrix[i][i]
    }

    private func calculateUnderDiagonalElements(matrix: inout Matrix, lMatrix: Matrix, i: Int, j: Int) {
        guard i > j else { return }
        var sum = 0.0
        for k in (j+1)..<matrix.count {
            sum += matrix[i][k] * lMatrix[k][j]
        }
        matrix[i][j] = -sum
    }
}

// MARK: - ReverseMatrixCompute

extension ReverseMatrixComputeImplementation: ReverseMatrixCompute {

    public func computeReverseMartix(from matrix: MutableMatrix) throws -> MutableMatrix {
        let extendedMatrix = try extendMatrix(matrix)
        let liniarizedMatrix: MutableMatrix
        do {
            liniarizedMatrix = try linearizer.liniarize(extendedMatrix)
            return convertToReverse(liniarizedMatrix)
        } catch {
            switch error as? SolvingError {
            case .zeroSolutions:
                throw ReverseMatrixError.notExist
            default:
                return .init(.init())
            }
        }
    }

    public func computeReverseMartixByLU(from matrix: MutableMatrix) throws -> MutableMatrix {
        let count = matrix.elementsArray.count
        let luTuple = try luExpander.expandToLU(matrix)
        let lMatrix = luTuple.0.elementsArray
        let uMatrix = luTuple.1.elementsArray
        print("L: \n \(luTuple.0) \n")
        print("U: \n \(luTuple.1) \n")
        var resultingArray = [[Double]].init(
            repeating: .init(repeating: 0, count: matrix.elementsArray.count),
            count: matrix.elementsArray.count
        )
        for index in (0..<count).reversed() {
            try calculateDiagonalElements(matrix: &resultingArray, uMatrix: uMatrix, j: index)
            for i in (0..<index).reversed() {
                try calculateAboveDiagonalElements(matrix: &resultingArray, uMatrix: uMatrix, i: i, j: index)
            }
            for j in (0..<index).reversed() {
                calculateUnderDiagonalElements(matrix: &resultingArray, lMatrix: lMatrix, i: index, j: j)
            }
        }
        return MutableMatrix(resultingArray)
    }
}
