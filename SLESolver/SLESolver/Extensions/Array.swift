//
//  Array.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 23.09.2021.
//

import Foundation

// MARK: - VectorError

public enum VectorError: Error {
    case sizesNotEqual
}

// MARK: - Array

extension Array where Element == Int {

    var countOfInversions: Int {
        var result = 0
        for i in 0..<count {
            for j in (i + 1)..<count {
                if [i] > [j] { result += 1 }
            }
        }
        return result
    }
}

extension Array where Element == Double {

    public static func * (lhs: Vector, rhs: Vector) throws -> Vector {
        var result = Vector()
        guard lhs.count == rhs.count else { throw VectorError.sizesNotEqual }
        for index in 0..<lhs.count {
            result.append(lhs[index] * rhs[index])
        }
        return result
    }

    public static func * (lhs: Vector, rhs: Double) -> Vector {
        lhs.map { $0 * rhs }
    }

    public var normalizedValue: Double {
        sqrt(reduce(0) { pow($1, 2) })
    }

    public static func - (lhs: Vector, rhs: Vector) throws -> Vector {
        var result = Vector()
        guard lhs.count == rhs.count else { throw VectorError.sizesNotEqual }
        for index in 0..<lhs.count {
            result.append(lhs[index] - rhs[index])
        }
        return result
    }
}
