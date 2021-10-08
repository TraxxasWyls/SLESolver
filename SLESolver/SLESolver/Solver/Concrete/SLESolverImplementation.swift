//
//  SLESolverImplementation.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation
import CoreImage

// MARK: - Aliases

public typealias Vector = [Double]

// MARK: - SolvingError

public enum SolvingError: Error {
    case eternity
    case zeroSolutions
    case notSolvable
    case dividedByZero
}

// MARK: - SLESolverImplementation

public final class SLESolverImplementation {

    // MARK: - Properties

    /// MatrixLinearizer instance
    private let linearizer: MatrixLinearizer = MatrixLinearizerImplementation()

    /// LUExpansion instance
    private let luExpander: LUExpansion = LUExpansionImplementation()

    // MARK: - Initializers

    public init() { }

    // MARK: - Private

    private func diagonalNonZero(_ matrix: MutableMatrix) -> Bool {
        for i in 0..<matrix.elementsArray.count {
            if matrix.elementsArray[i][i] == 0 { return false }
        }
        return true
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

    private func calculateY(l: MutableMatrix, bVector: Vector) throws -> Vector {

        let count = bVector.count
        var yVector = Vector()

        func calculateY(i: Int) -> Double {
            var sum = 0.0
            guard i > 0 else { return bVector[i] }
            for k in 0..<i {
                sum += l.elementsArray[i][k] * yVector[k]
            }
            return bVector[i] - sum
        }

        for i in 0..<count {
            yVector.append(calculateY(i: i))
        }

        return yVector
    }

    private func calculateX(u: MutableMatrix, yVector: Vector) throws -> Vector {

        let count = yVector.count
        var xVector = Vector(repeating: 0, count: count)
        
        guard diagonalNonZero(u) else { throw SolvingError.dividedByZero }

        func calculateX(i: Int) -> Double {
            var sum = 0.0
            guard i != count - 1 else { return yVector[i] / u.elementsArray[i][i] }
            for k in (i + 1)..<count {
                sum += u.elementsArray[i][k] * xVector[k]
            }
            return (yVector[i] - sum) / u.elementsArray[i][i]
        }

        for i in (0..<count).reversed() {
            xVector[i] = calculateX(i: i)
        }
        return xVector
    }

    private func getAMatrix(from matrix: MutableMatrix) -> MutableMatrix {
        var array = matrix.elementsArray
        for i in 0..<array.count { array[i].removeLast() }
        return MutableMatrix(array)
    }

    func calculateBVector(from matrix: MutableMatrix) throws -> Vector {
        var result = Vector()
        let count = matrix.elementsArray.count
        guard count + 1 == matrix.elementsArray[0].count else { throw SolvingError.notSolvable }
        for i in 0..<count {
            result.append(matrix.elementsArray[i][count])
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

    public func solveByLU(_ matrix: MutableMatrix) throws -> Result {
        let matrixA = getAMatrix(from: matrix)
        let bVector = try calculateBVector(from: matrix)
        let luTuple = try luExpander.expandToLU(matrixA)
        let lMatrix = luTuple.0
        let uMatrix = luTuple.1
        let yVector = try calculateY(l: lMatrix, bVector: bVector)
        print("A MATRIX: \n \(matrixA) \n ")
        print("B VECTOR: \n \(bVector) \n ")
        print("L: \n \(lMatrix) \n")
        print("U: \n \(uMatrix) \n")
        print("Y VECTOR: \n \(yVector) \n ")
        return try calculateX(u: uMatrix, yVector: yVector)
     }
}
