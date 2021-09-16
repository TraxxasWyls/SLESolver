//
//  Matrix.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - Matrix

public class Matrix {

    // MARK: - Properties

    private var elementsArray: [[Double]]

    // MARK: - Initializers

    /// Default initalizer
    /// - Parameter array: target elements array
    public init(_ array: [[Double]]) {
        elementsArray = array
    }
}

extension Matrix: MatrixOperations {

    public func sum(toRowIndex index: Int, rowWithIndex rowToSumIndex: Int) {
        var count = -1
        elementsArray[index] = elementsArray[index].map {
            count += 1
            return $0 + elementsArray[rowToSumIndex][count]
        }
    }

    public func substruct(fromRowIndex index: Int, rowWithIndex rowToSubIndex: Int) {
        var count = -1
        elementsArray[index] = elementsArray[index].map {
            count += 1
            return $0 - elementsArray[rowToSubIndex][count]
        }
    }

    public func multiply(rowWithIndex index: Int, to multiplayer: Double) {
        elementsArray[index] = elementsArray[index].map { $0 * multiplayer }
    }
}

// MARK: - CustomStringConvertible

extension Matrix: CustomStringConvertible {

    public var description: String {
        var description = "{\n"
        elementsArray.forEach {
            description = "  " + description + "\($0)" + "\n"
        }
        return description + "}"
    }
}
