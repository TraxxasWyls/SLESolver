////
////  MatrixOperations.swift
////  methods1
////
////  Created by Дмитрий Савинов on 10.09.2021.
////
//
//import Foundation
//
//public struct LinePlainObject {
//    let lineIndex: Int
//    let elementIndex: Int
//}
//
//public final class MatrixOperations {
//
//    func linearize(_ matix: Matrix) -> Matrix {
//
//        var matrixMutable = matix
//        var nonZeroElementLines = [LinePlainObject]()
//        var lineIndex = -1
//        var elemntIndex = -1
//
//        lines: for line in matrixMutable {
//            lineIndex += 1
//            if nonZeroElementLines.count < 2 {
//                elements: for element in line {
//                    elemntIndex += 1
//                    if !element.isZero {
//                        let currentNonZeroElementLine = LinePlainObject(
//                            lineIndex: lineIndex,
//                            elementIndex: elemntIndex
//                        )
//                        nonZeroElementLines.append(currentNonZeroElementLine)
//                        break elements
//                    }
//                }
//            } else {
//                break lines
//            }
//        }
//        return [[Float]]()
//    }
//
//    func determinant(_ matix: Matrix) -> Float {
//        return 0
//    }
//}
