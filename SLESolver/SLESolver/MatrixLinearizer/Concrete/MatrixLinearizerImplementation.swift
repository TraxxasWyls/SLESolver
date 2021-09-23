//
//  MatrixLinearizerImplementation.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - ElementPosition

public struct ElementPosition {

    // MARK: - Properties

    let lineIndex: Int
    let elementIndex: Int

    // MARK: - Initializes

    public init(lineIndex: Int, elementIndex: Int) {
        self.lineIndex = lineIndex
        self.elementIndex = elementIndex
    }
}

// MARK: - MatrixLinearizerImplementation

public final class MatrixLinearizerImplementation {

    // MARK: - Properties

    private var usedLineIndexes: [Int] = []
    private(set) public var detMultiplyer: Double = 1
    private(set) public var linesSwapCount: Int = .zero

    // MARK: - Initializers

    public init() { }

    // MARK: - Private

    private func firstNonZeroElementPosition(_ matrix: MutableMatrix) throws -> ElementPosition {
        var lines = [ElementPosition]()
        var lineIndex: Int = 0
        try matrix.elementsArray.forEach {
            if let nonZeroElement = $0.firstIndex(where: { element in element != .zero }) {
                guard nonZeroElement != matrix.elementsArray[0].count - 1 || matrix.isSquare
                else { throw SolvingError.zeroSolutions }
                if !usedLineIndexes.contains(lineIndex) {
                    lines.append(.init(lineIndex: lineIndex, elementIndex: nonZeroElement))
                }
            } else { throw SolvingError.eternity }
            lineIndex += 1
        }
        if lines.count == .zero { throw SolvingError.eternity }
        let resultLine = lines.min { $0.elementIndex < $1.elementIndex }!
        usedLineIndexes.append(resultLine.lineIndex)
        return resultLine
    }

    private func makeZero(_ matrix: MutableMatrix, using lineWithElement: ElementPosition) {
        var indexesToSub: [Int] = Array(0...matrix.elementsArray.count - 1)
        indexesToSub.remove(at: lineWithElement.lineIndex)
        indexesToSub.forEach {
            let subtrahend = matrix.line(
                withIndex: lineWithElement.lineIndex,
                multiplyedBy: matrix.element(atLine: $0, withIndex: lineWithElement.elementIndex)
            )
            let multiplyer = matrix.element(lineWithElement)
            detMultiplyer *= multiplyer != .zero ? multiplyer : 1
            matrix.multiply(rowWithIndex: $0, to: multiplyer)
            matrix.substruct(fromRowIndex: $0, line: subtrahend)
        }
    }

    private func sortByDiagonal(_ matrix: MutableMatrix) -> MutableMatrix {
        var linePositions = [Int: Int]()
        var lineIndex = -1
        matrix.elementsArray.forEach { line in
            lineIndex += 1
            if let elementIndex = line.firstIndex(where: { $0 != .zero }) {
                linePositions[lineIndex] = elementIndex
            }
        }
        let sortedLinePositions = linePositions.sorted { $0.value < $1.value }
        matrix.elementsArray = sortedLinePositions.map { matrix.line(withIndex: $0.key) }
        linesSwapCount = countOfInversions(linePositions.sorted { $0.key < $1.key }.map { $0.value })
        return matrix
    }

    private func countOfInversions(_ array: [Int]) -> Int {
        var result = 0
        for i in 0..<array.count {
            for j in (i + 1)..<array.count {
                if array[i] > array[j] { result += 1 }
            }
        }
        return result
    }
}

// MARK: - MatrixLinearizer

extension MatrixLinearizerImplementation: MatrixLinearizer {

    public func liniarize(_ matrix: MutableMatrix) throws -> MutableMatrix {
        usedLineIndexes = []
        detMultiplyer = 1
        linesSwapCount = .zero
        while usedLineIndexes.count < matrix.elementsArray.count {
            let lineWithNonZeroElement = try firstNonZeroElementPosition(matrix)
            makeZero(matrix, using: lineWithNonZeroElement)
            print(matrix)
            print("\n")
        }
        return sortByDiagonal(matrix)
    }
}
