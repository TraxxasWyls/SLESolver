//
//  ReverseMatrixComputeImplementation.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 24.09.2021.
//

import Foundation

// MARK: - ReverseMatrixError

public enum ReverseMatrixError: Error {
    case notExist
}

// MARK: - ReverseMatrixComputeImplementation

public final class ReverseMatrixComputeImplementation {

    // MARK: - Properties

    /// MatrixLinearizer instance
    private let linearizer: MatrixLinearizer = MatrixLinearizerImplementation()

    // MARK: - Initializers

    public init() { }

    private func convertToReverse(_ matrix: MutableMatrix) -> MutableMatrix {
        for i in 0..<matrix.elementsArray.count {
            matrix.multiply(rowWithIndex: i, to: 1 / matrix.elementsArray[i][i])
        }
        print(matrix)
        for i in 0..<matrix.elementsArray.count {
            matrix.elementsArray[i].removeSubrange(0...(matrix.elementsArray[i].count / 2 - 1))
        }
        print(matrix)
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
}
