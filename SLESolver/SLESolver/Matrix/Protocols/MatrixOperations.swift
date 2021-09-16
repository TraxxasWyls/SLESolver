//
//  MatrixOperations.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - MatrixOperations

public protocol MatrixOperations {

    func sum(toRowIndex index: Int, rowWithIndex rowToSumIndex: Int)

    func substruct(fromRowIndex index: Int, rowWithIndex rowToSubIndex: Int)

    func multiply(rowWithIndex index: Int, to multiplayer: Double)
}
