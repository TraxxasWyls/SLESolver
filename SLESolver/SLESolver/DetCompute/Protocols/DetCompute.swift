//
//  DetCompute.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 17.09.2021.
//

import Foundation

// MARK: - DetCompute

public protocol DetCompute {

    func calculateDet(_ matrix: MutableMatrix) throws -> Double
}
