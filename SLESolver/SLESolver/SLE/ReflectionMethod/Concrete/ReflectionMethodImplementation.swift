//
//  ReflectionMethodImplementation.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 21.10.2021.
//

import Foundation

// MARK: - ReflectionMethodImplementation

public class ReflectionMethodImplementation: ReflectionMethod {

    private func iterateReflection(_ matrix: inout MutableMatrix, iteration i: Int) throws {
        let array = matrix.elementsArray
        let dimension = array.count
        guard i < dimension else { return }
        let lVector = Vector(onePosition: i, dimension: dimension)
        let sVector = matrix * lVector
        let alphaNorma = sVector.normalizedValue
        let sAndLMult = try sVector * lVector
        let argSL = sAndLMult[i].arg - .pi
        let alpha = alphaNorma * (argSL.sign == .plus ? 1 : -1)
        let pValue = sqrt(2 * pow(alphaNorma, 2) + 2 * alphaNorma * sAndLMult.normalizedValue)
        let sMinusAlphaL = try (sVector - alpha * lVector)
        let wVector = (1 / pValue) * sMinusAlphaL
        let doubleWW = MutableMatrix(try 2 * wVector ** wVector)
        let uMatrix = try MutableMatrix.createOneMatrix(ofSize: dimension) - doubleWW
        matrix = uMatrix * matrix
        print("S = \(sVector)")
        print("L = \(lVector)")
        print("|alpha| = \(alphaNorma)")
        print("p = \(pValue)")
        print("W = \(wVector)")
        print("U = \(uMatrix)")
    }

    // MARK: - ReflectionMethod

    public func makeReflectedMatrix(fromMatrix matrix: MutableMatrix) throws -> MutableMatrix {
        var mutableCopy = matrix
        for index in 0..<matrix.elementsArray.count - 1 {
            print("Iteration: \(index)")
            try iterateReflection(&mutableCopy, iteration: index)
            print("A\(index + 1) = \(mutableCopy)")
        }
        print("Refletions ended")
        return mutableCopy
    }
}
