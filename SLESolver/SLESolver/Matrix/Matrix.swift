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
        var count = 0
        for var element in elementsArray[index] {
            element = element + elementsArray[rowToSumIndex][count]
            count += 1
        }
    }

    public func substruct(fromRowIndex index: Int, rowWithIndex rowToSubIndex: Int) {
        var count = 0
        for var element in elementsArray[index] {
            element = element - elementsArray[rowToSubIndex][count]
            count += 1
        }
    }

    public func multiply(rowWithIndex index: Int, to multiplayer: Double) {
        for var element in elementsArray[index] {
            element = element * multiplayer
        }
    }
}
