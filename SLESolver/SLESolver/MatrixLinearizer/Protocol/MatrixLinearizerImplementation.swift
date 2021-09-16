//
//  MatrixLinearizerImplementation.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - ElementPosition

public struct ElementPosition {
    let lineIndex: Int
    let elementIndex: Int
}

// MARK: - MatrixLinearizerImplementation

public final class MatrixLinearizerImplementation: MatrixLinearizer {

    // MARK: - Properties

    private var usedLineIndexes: [Int] = []

    // MARK: - Initializers

    public init() { }

    // MARK: - Private

    private func firstNonZeroElementPosition(_ matrix: Matrix) -> ElementPosition {
        var lines = [ElementPosition]()
        var lineIndex: Int = 0
        matrix.elementsArray.forEach {
            if let nonZeroElement = $0.firstIndex(where: { element in element != .zero }) {
                guard nonZeroElement != matrix.elementsArray.count - 1 || matrix.isSquare
                else { fatalError(Contants.zeroSolutionsMessage) }
                if !usedLineIndexes.contains(lineIndex) {
                    lines.append(.init(lineIndex: lineIndex, elementIndex: nonZeroElement))
                }
            } else { fatalError(Contants.eternityMessage) }
            lineIndex += 1
        }
        if lines.count == .zero { fatalError(Contants.eternityMessage) }
        let resultLine = lines.min { $0.elementIndex < $1.elementIndex }!
        usedLineIndexes.append(resultLine.lineIndex)
        return resultLine
    }

    private func makeZero(_ matrix: Matrix, using lineWithElement: ElementPosition) {
        var indexesToSub: [Int] = Array(0...matrix.elementsArray.count - 1)
        indexesToSub.remove(at: lineWithElement.lineIndex)
        indexesToSub.forEach {
            let subtrahend = matrix.line(
                withIndex: lineWithElement.lineIndex,
                multiplyedBy: matrix.element(atLine: $0, withIndex: lineWithElement.elementIndex)
            )
            matrix.multiply(rowWithIndex: $0, to: matrix.element(lineWithElement))
            matrix.substruct(fromRowIndex: $0, line: subtrahend)
        }
    }

    // MARK: - MatrixLinearizer

    public func liniarize(_ matrix: Matrix) -> Matrix {
        usedLineIndexes = []
        while usedLineIndexes.count < matrix.elementsArray.count {
            let lineWithNonZeroElement = firstNonZeroElementPosition(matrix)
            makeZero(matrix, using: lineWithNonZeroElement)
            print(matrix)
            print("\n")
        }
        return matrix
    }
}
