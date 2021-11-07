//
//  AitkenScheme.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 28.10.2021.
//

import Foundation

// MARK: - Aliases

public typealias ControlPoints = [CGPoint]

// MARK: - AitkenScheme

public protocol AitkenScheme {

    func interpolate(controlPoints: [CGPoint], interval: (Double, Double), plotPointsCount: Int) -> [CGPoint]
}
