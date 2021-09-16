//
//  MutableMatrix.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - MutableMatrix

public class MutableMatrix {

    // MARK: - Properties

    public var elementsArray: [[Double]]

    // MARK: - Initializers

    /// Default initalizer
    /// - Parameter array: target elements array
    public init(_ array: [[Double]]) {
        elementsArray = array
    }
}

// MARK: - MatrixOperations

extension MutableMatrix: MatrixOperations {

    public var isSquare: Bool {
        elementsArray.count == elementsArray[0].count
    }

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
        elementsArray[index] = line(withIndex: index, multiplyedBy: multiplayer)
    }

    public func line(withIndex index: Int, multiplyedBy multiplayer: Double) -> [Double] {
        elementsArray[index].map { $0 * multiplayer }
    }

    public func line(withIndex index: Int) -> [Double] {
        elementsArray[index]
    }

    public func element(atLine lineIndex: Int, withIndex elementIndex: Int) -> Double {
        elementsArray[lineIndex][elementIndex]
    }

    public func substruct(fromRowIndex index: Int, line: [Double]) {
        var count = -1
        elementsArray[index] = elementsArray[index].map {
            count += 1
            return $0 - line[count]
        }
    }

    public func element(_ element: ElementPosition) -> Double {
        elementsArray[element.lineIndex][element.elementIndex]
    }
}

// MARK: - CustomStringConvertible

extension MutableMatrix: CustomStringConvertible {

    public var description: String {
        var description = "{\n"
        elementsArray.forEach {
            description =  description + "\($0)" + "\n"
        }
        return description + "}"
    }
}
