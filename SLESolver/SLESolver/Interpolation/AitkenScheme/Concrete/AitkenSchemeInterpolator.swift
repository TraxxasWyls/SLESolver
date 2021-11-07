//
//  AitkenSchemeInterpolator.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 07.11.2021.
//

import Foundation

// MARK: - AitkenSchemeInterpolator

public final class AitkenSchemeInterpolator {

    // MARK: - Private

    private func points(fromInterval interval: (Double, Double), count: Int) -> [Double] {
        let intervalStart = interval.0
        let intervalEnd = interval.1
        let delta = intervalEnd - intervalStart
        let step = delta / Double(count)
        var resultingPointsArray = [intervalStart]
        for i in 1...count {
            resultingPointsArray.append(resultingPointsArray[i-1] + .init(step))
        }
        return resultingPointsArray
    }

    private func det(_ array: [[Double]]) -> Double {
        array[0][0] * array[1][1] - array[0][1] * array[1][0]
    }

    func interpolate(controlPoints: [CGPoint], x: Double) -> Double {
        print("CALCULATING FOR ARGUMENT: = \(x)")
        print("--------------------------------")
        let n = controlPoints.count
        var ldictionary: [[Int] : Double] = [:]
        let ldictionaryMinimumSize = 2
        for dictoinarySize in ldictionaryMinimumSize...n {
            print("L size: - \(dictoinarySize)")
            for i in 0...(n - dictoinarySize) {
                if dictoinarySize == 2 {
                    let elementsArray = [
                        [controlPoints[i].y, controlPoints[i].x - x],
                        [controlPoints[i+1].y, controlPoints[i+1].x - x]
                    ]
                    ldictionary[[i,i + 1]] = det(elementsArray) / (controlPoints[i+1].x - controlPoints[i].x)
                    print("y\(i) = \(controlPoints[i].y)")
                    print("y\(i+1) = \(controlPoints[i+1].y)")
                    print("x\(i) - x = \(controlPoints[i].x - x)")
                    print("x\(i+1) - x = \(controlPoints[i+1].x - x)")
                    print("x\(i+1) - x\(i) = \(controlPoints[i+1].x - controlPoints[i].x)")
                    print("det = \(det(elementsArray))")
                    print("L (\(i), \(i + 1)) = \(ldictionary[[i,i + 1]]!)")
                } else {
                    let elementsArray = [
                        [ldictionary[.init(i...(i + dictoinarySize - 2))]!, controlPoints[i].x - x],
                        [ldictionary[.init((i+1)...(i + dictoinarySize - 1))]!, controlPoints[i + dictoinarySize - 1].x - x]
                    ]
                    ldictionary[.init(i...(i + dictoinarySize - 1))] = det(elementsArray) / (controlPoints[i + dictoinarySize - 1].x - controlPoints[i].x)
                    print("L\([Int](i...(i + dictoinarySize - 2))) = \(ldictionary[.init(i...(i + dictoinarySize - 2))]!)")
                    print("L\([Int]((i+1)...(i + dictoinarySize - 1))) = \(ldictionary[.init((i+1)...(i + dictoinarySize - 1))]!)")
                    print("x\(i) - x = \(controlPoints[i].x - x)")
                    print("x\(i + dictoinarySize - 1) - x = \(controlPoints[i + dictoinarySize - 1].x - x)")
                    print("x\(i + dictoinarySize - 2) = \(controlPoints[i + dictoinarySize - 2].x)")
                    print("x\(i + dictoinarySize - 1) - x\(i + dictoinarySize - 2) = \(controlPoints[i + dictoinarySize - 1].x - controlPoints[i + dictoinarySize - 2].x)")
                    print("det = \(det(elementsArray))")
                    print("L (\([Int](i...(i + dictoinarySize - 1)))) = \(ldictionary[.init(i...(i + dictoinarySize - 1))]!)")
                }
            }
        }
        print("Calculation done!---------------")
        print("--------------------------------")
        return ldictionary[.init(0...(n - 1))]!
    }
}

// MARK: - AitkenScheme

extension AitkenSchemeInterpolator: AitkenScheme {

    public func interpolate(controlPoints: [CGPoint], interval: (Double, Double), plotPointsCount: Int) -> [CGPoint] {
        let argumentsForInterpolation = points(fromInterval: interval, count: plotPointsCount)
        return argumentsForInterpolation.map {
            CGPoint(x: $0, y: interpolate(controlPoints: controlPoints, x: $0))
        }
    }
}
