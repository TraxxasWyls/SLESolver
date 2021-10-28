//
//  Double.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 22.10.2021.
//

import Foundation

// MARK: - Double

extension Double {
    
    public var arg: Double  {
        switch sign {
        case .minus:
            return .pi
        case .plus:
            return .zero
        }
    }
}
