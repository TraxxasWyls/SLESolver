//
//  MatrixOperations.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - MatrixOperations

public protocol MatrixOperations {

    // MARK: - Properties

    var isSquare: Bool { get }

    // MARK: - Methods

    func sum(toRowIndex index: Int, rowWithIndex rowToSumIndex: Int)

    func substruct(fromRowIndex index: Int, rowWithIndex rowToSubIndex: Int)

    func substruct(fromRowIndex index: Int, line: [Double])

    func multiply(rowWithIndex index: Int, to multiplayer: Double)

    func line(withIndex index: Int, multiplyedBy multiplayer: Double) -> [Double]

    func line(withIndex index: Int) -> [Double]

    func element(atLine lineIndex: Int, withIndex elementIndex: Int) -> Double

    func element(_ element: ElementPosition) -> Double
}
