//
//  ReverseMatrixCompute.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 24.09.2021.
//

import Foundation

// MARK - ReverseMatrixCompute

public protocol ReverseMatrixCompute {

    func computeReverseMartix(from matrix: MutableMatrix) throws -> MutableMatrix

    func computeReverseMartixByLU(from matrix: MutableMatrix) throws -> MutableMatrix
}
