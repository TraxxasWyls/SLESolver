//
//  SLESolver.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - Aliases

public typealias Result = [Double]

// MARK: - SLESolver

public protocol SLESolver {

    func solve(_ matrix: MutableMatrix) throws -> Result

    func solveByLU(_ matrix: MutableMatrix) throws -> Result

    func solveByReflections(_ matrix: MutableMatrix) throws -> Result
}
