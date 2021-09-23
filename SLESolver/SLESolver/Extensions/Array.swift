//
//  Array.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 23.09.2021.
//

import Foundation

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
