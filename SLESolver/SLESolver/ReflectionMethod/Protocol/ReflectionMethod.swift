//
//  ReflectionMethod.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 21.10.2021.
//

import Foundation

// MARK: - ReflectionMethod

public protocol ReflectionMethod {

    func makeReflectedMatrix(fromMatrix matrix: MutableMatrix) throws -> MutableMatrix
}
