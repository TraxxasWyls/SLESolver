//
//  LUExpansionImplementation.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 07.10.2021.
//

// MARK: - LUError

public enum LUError: Error {
    case dividedByZero
    case nonQuadraticMatrix
}

import Foundation

// MARK: - LUExpansionImplementation

public final class LUExpansionImplementation {

    // MARK: - Properties

    private var mutableMatrix = MutableMatrix([[]])

    private var count: Int {
        mutableMatrix.elementsArray.count
    }

    // MARK: - Initializers

    public init() {}

    // MARK: - Private

    private func calculateU(i: Int, j: Int, matrix: [[Double]], side: Side = .left) -> Double {
        let summator = side == .left ? i : j
        var sum: Double = 0
        if summator > 0 {
            for k in 0...(summator - 1) {
                sum += matrix[i][k] * matrix[k][j]
            }
        }
        return mutableMatrix.elementsArray[i][j] - sum
    }

    private func calculateL(i: Int, j: Int, matrix: [[Double]], side: Side = .left) throws -> Double {
        let divider = side == .left ? matrix[j][j] : matrix[i][i]
        let summator = side == .left ? j : i
        guard !divider.isZero else { throw LUError.dividedByZero }
        var sum: Double = 0
        if summator > 0 {
            for k in 0...(summator - 1) {
                sum += matrix[i][k] * matrix[k][j]
            }
        }
        return (mutableMatrix.elementsArray[i][j] - sum) / divider
    }

    private func getResult(from matrix: [[Double]], side: Side = .left) -> (MutableMatrix, MutableMatrix) {
        var l: [[Double]] = .init(repeating: .init(repeating: 0, count: count), count: count)
        var u: [[Double]] = .init(repeating: .init(repeating: 0, count: count), count: count)
        switch side {
        case .left:
            for i in 0..<count {
                for j in 0..<count {
                    if j >= i {
                        u[i][j] = matrix[i][j]
                        l[i][j] = i == j ? 1 : 0
                    } else {
                        l[i][j] = matrix[i][j]
                    }
                }
            }
        case .right:
            for i in 0..<count {
                for j in 0..<count {
                    if i >= j {
                        l[i][j] = matrix[i][j]
                        u[i][j] = i == j ? 1 : 0
                    } else {
                        u[i][j] = matrix[i][j]
                    }
                }
            }
        }
        return (MutableMatrix(l), MutableMatrix(u))
    }
}

// MARK: - LUExpansion

extension LUExpansionImplementation: LUExpansion {

    public func expandToLU(_ matrix: MutableMatrix, oneDiagonalPosition: Side) throws -> (MutableMatrix, MutableMatrix) {
        guard matrix.isSquare else { throw LUError.nonQuadraticMatrix }
        mutableMatrix = matrix
        var result = [[Double]].init(repeating: .init(repeating: 0, count: count), count: count)
        switch oneDiagonalPosition {
        case .left:
            for index in 0..<count {
                for j in index..<count {
                    result[index][j] = calculateU(i: index, j: j, matrix: result)
                }
                for i in (index + 1)..<count {
                    result[i][index] = try calculateL(i: i, j: index, matrix: result)
                }
            }
        case .right:
            for index in 0..<count {
                for i in index..<count {
                    result[i][index] = calculateU(i: i, j: index, matrix: result, side: oneDiagonalPosition)
                }
                for j in (index + 1)..<count {
                    result[index][j] = try calculateL(i: index, j: j, matrix: result, side: oneDiagonalPosition)
                }
            }
        }
        return getResult(from: result, side: oneDiagonalPosition)
    }
}
