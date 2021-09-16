//
//  MatrixLinearizerImplementation.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - LineWithElement

public struct LineWithElement {
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

    private func lineIndexWithMinIndexNonZeroElement(_ matrix: Matrix) -> LineWithElement {
        var lines = [LineWithElement]()
        var lineIndex: Int = 0
        matrix.elementsArray.forEach {
            if let nonZeroElement = $0.firstIndex(where: { element in
                element != 0
            }) {
                guard !usedLineIndexes.contains(lineIndex) else { return }
                lines.append(.init(lineIndex: lineIndex, elementIndex: nonZeroElement))
            } else {
                fatalError(Contants.eternityMessage)
            }
            lineIndex += 1
         }
        let resultLine = lines.min { $0.elementIndex < $1.elementIndex }!
        usedLineIndexes.append(resultLine.lineIndex)
        return resultLine
    }

    private func makeZero(_ matrix: Matrix, using line: LineWithElement) {
        var indexesToSub: [Int] = Array(0...matrix.elementsArray.count - 1)
        indexesToSub.remove(at: line.lineIndex)
        indexesToSub.forEach {
            let subtrahend = matrix.line(
                withIndex: line.lineIndex,
                multiplyedBy: matrix.element(atLine: $0, withIndex: line.lineIndex)
            )
            matrix.substruct(fromRowIndex: $0, line: subtrahend)
        }
    }

    // MARK: - MatrixLinearizer

    public func liniarize(_ matrix: Matrix) -> Matrix {
        usedLineIndexes = []
        while usedLineIndexes.count < matrix.elementsArray.count {
            let lineWithNonZeroElement = lineIndexWithMinIndexNonZeroElement(matrix)
            makeZero(matrix, using: lineWithNonZeroElement)
            print(matrix)
            print("\n\n")
        }
        return matrix
    }
}
