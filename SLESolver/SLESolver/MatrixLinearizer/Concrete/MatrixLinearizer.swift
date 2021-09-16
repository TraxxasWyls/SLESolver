//
//  MatrixLinearizer.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - MatrixLinearizer

public protocol MatrixLinearizer {

    func liniarize(_ matrix: Matrix) -> Matrix
}
