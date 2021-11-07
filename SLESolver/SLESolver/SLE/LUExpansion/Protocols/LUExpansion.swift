//
//  LUExpansion.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 07.10.2021.
//

import Foundation

public enum Side {
    case left, right
}

// MARK: - LUExpansion

public protocol LUExpansion {

    func expandToLU(_ matrix: MutableMatrix, oneDiagonalPosition: Side) throws -> (MutableMatrix, MutableMatrix)
}

// MARK: - Default

public extension LUExpansion {

    func expandToLU(_ matrix: MutableMatrix) throws -> (MutableMatrix, MutableMatrix) {
        try expandToLU(matrix, oneDiagonalPosition: .left)
    }
}
