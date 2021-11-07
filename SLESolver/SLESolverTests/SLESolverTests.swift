//
//  SLESolverTests.swift
//  SLESolverTests
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import XCTest
@testable import SLESolver

// MARK: - Private

private func solve(_ array: [[Double]]) throws -> Result {
    let matrix = MutableMatrix(array)
    let solver = SLESolverImplementation()
    let result = try solver.solve(matrix)
    print("\nResulting vector \(result)\n")
    return result
}

private func solveByLU(_ array: [[Double]]) throws -> Result {
    let matrix = MutableMatrix(array)
    let solver = SLESolverImplementation()
    let result = try solver.solveByLU(matrix)
    print("\nResulting vector \(result)\n")
    return result
}

private func solveByReflections(_ array: [[Double]]) throws -> Result {
    let matrix = MutableMatrix(array)
    let solver = SLESolverImplementation()
    let result = try solver.solveByReflections(matrix)
    print("\nResulting vector \(result)\n")
    return result
}

private func calculateDet(_ array: [[Double]]) throws -> Double {
    let matrix = MutableMatrix(array)
    let detCompute = DetComputeImplementation()
    let result = try detCompute.calculateDet(matrix)
    print("Resulting det \(result)\n")
    return result
}

private func calculateReverse(_ array: [[Double]], byLU: Bool = false) throws -> MutableMatrix {
    let matrix = MutableMatrix(array)
    let reverseCompute = ReverseMatrixComputeImplementation()
    let result = byLU ? try reverseCompute.computeReverseMartixByLU(from: matrix) : try reverseCompute.computeReverseMartix(from: matrix)
    print("Resulting matrix \(result)\n")
    return result
}

private func calculateLU(_ array: [[Double]], side: Side) throws -> (MutableMatrix, MutableMatrix) {
    let matrix = MutableMatrix(array)
    let luCompute = LUExpansionImplementation()
    let result = try luCompute.expandToLU(matrix, oneDiagonalPosition: side)
    print("Resulting L: \n \(result.0)\n Resulting U: \n \(result.1) \n")
    print("MULT OF L*U: \n \(result.0 * result.1) \n")
    return result
}

// MARK: - SLESolverTests

class SLESolverTests: XCTestCase {

    // MARK: - Solve

    func testExample1() throws {
        let example1: [[Double]] = [
            [1, 3, 0, 1],
            [1, 4, 0, 1],
            [1, 0, 1, 1],
        ]
        XCTAssert(try solve(example1) == [1.0, 0.0, 0.0])
    }

    func testExample2() throws {
        let example2: [[Double]] = [
            [23, 1, 6, 0],
            [0, 0, 2, 2],
            [11, 13, 131, 5],
        ]
        XCTAssert(try solve(example2) == [1.0/6, -59.0/6, 1])
    }

    func testExample3() throws {
        let example3: [[Double]] = [
            [23, 1, 6, 0],
            [0, 0, 0, 2],
            [11, 13, 131, 5],
        ]
        XCTAssertThrowsError(try solve(example3)) { error in
            XCTAssertEqual(error as? SolvingError, SolvingError.zeroSolutions)
        }
    }

    func testExample4() throws {
        let example4: [[Double]] = [
            [2, 6, 0, 0],
            [1, 3, 0, 0],
            [1, 0, 1, 1],
        ]
        XCTAssertThrowsError(try solve(example4)) { error in
            XCTAssertEqual(error as? SolvingError, SolvingError.eternity)
        }
    }

    func testExample5() throws {
        let example2: [[Double]] = [
            [23, 1, 6, 0],
            [0, 0, 2, 2],
            [11, 13, 131, 5],
        ]
        XCTAssert(try solve(example2) == [1.0/6, -59.0/6, 1])
    }

    func testExample6() throws {
        let example2: [[Double]] = [
            [1, 0, 4, 5, 6],
            [9, 10, 11, 12, 13],
            [14, 15, 16, 17, 18],
            [19, 20, 21, 23, 9],
        ]
        XCTAssert(try solve(example2) == [-9.6, 3.2, 21.4, -14])
    }

    func testExample7() throws {
        let example2: [[Double]] = [
            [1, 0, 0, 0, 1],
            [0, 1, 0, 0, 1],
            [0, 0, 1, 0, 1],
            [0, 0, 0, 1, 1],
        ]
        XCTAssert(try solve(example2) == [1, 1, 1, 1])
    }

    // MARK: - Det

    func testExample8() throws {
        let example2: [[Double]] = [
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ]
        XCTAssert(try calculateDet(example2) == 1)
    }

    func testExample9() throws {
        let example2: [[Double]] = [
            [2, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 2, 0],
            [0, 0, 0, 1]
        ]
        XCTAssert(try calculateDet(example2) == 4)
    }

    func testExample10() throws {
        let example2: [[Double]] = [
            [2, 0, 0, 0, 1],
            [0, 1, 0, 0, 1],
            [0, 0, 2, 0, 1],
            [0, 0, 0, 1, 1]
        ]
        XCTAssertThrowsError(try  calculateDet(example2)) { error in
            XCTAssertEqual(error as? DetError, DetError.notSquareMatrix)
        }
    }

    func testExample11() throws {
        let example2: [[Double]] = [
            [2, 4, 5],
            [1, 5, 9],
            [-8, -3, -1]
        ]
        XCTAssert(try calculateDet(example2) == -55)
    }

    func testExample12() throws {
        let example2: [[Double]] = [
            [15, 55, -1, 0, 0],
            [3, 3, 3, 2, 16],
            [1, 0, 0, 0, 0],
            [-7, 6, 0, 0, 0],
            [-4, 1, 1, 0, 23]
        ]
        XCTAssert(try calculateDet(example2) == -276)
    }

    func testExample13() throws {
        let example2: [[Double]] = [
            [1, 0, 0],
            [0, 0, 1],
            [0, 1, 0]
        ]
        XCTAssert(try calculateDet(example2) == -1)
    }

    func testExample14() throws {
        let example2: [[Double]] = [
            [0, 0, 1],
            [1, 0, 0],
            [0, 1, 0]
        ]
        XCTAssert(try calculateDet(example2) == 1)
    }

    func testExample15() throws {
        let example2: [[Double]] = [
            [1550, 0, 0, 0],
            [0, 255, 22, 0],
            [11, 0, 2, 0],
            [0, 0, 0, 1]
        ]
        XCTAssert(try calculateDet(example2).distance(to: 790500) <= 0.0000000001)
    }

    func testExample16() throws {
        let example2: [[Double]] = [
            [15, 55, -1, 0, 0, 1],
            [3, 3, 3, 2, 16, 2],
            [1, 0, 0, 0, 0, 6],
            [-7, 6, 0, 0, 0, 8],
            [-4, 1, 1, 0, 23, 24],
            [-4, 1, 1, 0, 23, 24]
        ]
        XCTAssert(try calculateDet(example2) == 0)
    }

    func testExample17() throws {
        let example2: [[Double]] = [
            [0, 0, 1],
            [0, 1, 0],
            [1, 0, 0]
        ]
        XCTAssert(try calculateDet(example2) == -1)
    }

    func testExample18() throws {
        let example2: [[Double]] = [
            [0, 0, 1],
            [1, 0, 0],
            [0, 1, 0]
        ]
        XCTAssert(try calculateDet(example2) == 1)
    }

    func testExample19() throws {
        let example2: [[Double]] = [
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 0, 1],
            [0, 0, 1, 0]
        ]
        XCTAssert(try calculateDet(example2) == -1)
    }

    func testExample20() throws {
        let example2: [[Double]] = [
            [0, 0, 0, 1],
            [0, 0, 1, 0],
            [0, 1, 0, 0],
            [1, 0, 0, 0]
        ]
        XCTAssert(try calculateDet(example2) == 1)
    }

    func testExample21() throws {
        let example2: [[Double]] = [
            [1, 2, -1, 0, 2],
            [2, 1, 0, 3, 0],
            [-1, 0, 1, 0, 2],
            [0, 3, 0, 1, 0],
            [2, 0, 2, 0, 1]
        ]
        XCTAssert(try calculateDet(example2) == 140)
    }

    func testExample22() throws {
        let example2: [[Double]] = [
            [1, 2, -1, 1, 1],
            [-1, 2, 1, 1, -1],
            [0, 0, 2, 4, 1],
            [0, 0, -1, 0, 1],
            [0, 0, 2, 1, 0]
        ]
        XCTAssert(try calculateDet(example2) == 20)
    }

    func testExample23() throws {
        let example2: [[Double]] = [
            [0, 1, 0, 0],
            [-2, 0, 0, 0],
            [0, 0, 0, 5],
            [0, 0, 3, 0]
        ]
        XCTAssert(try calculateDet(example2) == -30)
    }

    func testExample24() throws {
        let example2: [[Double]] = [
            [0, 1, 3, -1],
            [0, 2, 1, 3],
            [1, 4, 1, 1],
            [5, 2, -1, 0]
        ]
        XCTAssert(try calculateDet(example2) == -125)
    }

    // MARK: - Reverse

    func testExample25() throws {
        let example2: [[Double]] = [
            [0, 0, 1, 0],
            [0, 0, 0, 1],
            [1, 2, 1, 2],
            [-1, -1, -1, 3]
        ]
        let resultArray: [[Double]] = [
            [-1, 8, -1, -2],
            [0, -5, 1, 1],
            [1, 0, 0, 0],
            [0, 1, 0, 0]
        ]
        XCTAssert(try calculateReverse(example2).elementsArray == resultArray)
    }

    func testExample26() throws {
        let example2: [[Double]] = [
            [7, 4],
            [5, 3]
        ]
        let resultArray: [[Double]] = [
            [3, -4],
            [-5, 7]
        ]
        XCTAssert(try calculateReverse(example2).elementsArray == resultArray)
    }

    func testExample27() throws {
        let example2: [[Double]] = [
            [1, 3, -5],
            [0, 1, 2],
            [0, 0, 1]
        ]
        let resultArray: [[Double]] = [
            [1, -3, 11],
            [0, 1, -2],
            [0, 0, 1]
        ]
        XCTAssert(try calculateReverse(example2).elementsArray == resultArray)
    }

    func testExample28() throws {
        let example2: [[Double]] = [
            [1, 3, -5, 0],
            [0, 1, 2, -1],
            [0, 0, 1, 0]
        ]
        XCTAssertThrowsError(try calculateReverse(example2)) { error in
            XCTAssertEqual(error as? DetError, DetError.notSquareMatrix)
        }
    }

    func testExample29() throws {
        let example2: [[Double]] = [
            [1, 0, 0, 0, 0, 0],
            [0, 1, 0, 0, 0, 0],
            [0, 0, 1, 0, 0, 0],
            [0, 0, 0, 1, 0, 0],
            [0, 0, 0, 0, 1, 0],
            [0, 0, 0, 0, 0, 1]
        ]
        let resultArray: [[Double]] = [
            [1, 0, 0, 0, 0, 0],
            [0, 1, 0, 0, 0, 0],
            [0, 0, 1, 0, 0, 0],
            [0, 0, 0, 1, 0, 0],
            [0, 0, 0, 0, 1, 0],
            [0, 0, 0, 0, 0, 1]
        ]
        XCTAssert(try calculateReverse(example2).elementsArray == resultArray)
    }

    func testExample30() throws {
        let example2: [[Double]] = [
            [214, 1, 2],
            [1, 1, 0],
            [428, 2, 4]
        ]
        XCTAssertThrowsError(try calculateReverse(example2)) { error in
            XCTAssertEqual(error as? ReverseMatrixError, ReverseMatrixError.notExist)
        }
    }

    func testExample31() throws {
        let example2: [[Double]] = [
            [0, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 1, 0],
            [0, 0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0, 0],
            [0, 1, 0, 0, 0, 0],
            [1, 0, 0, 0, 0, 0]
        ]
        let resultArray: [[Double]] = [
            [0, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 1, 0],
            [0, 0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0, 0],
            [0, 1, 0, 0, 0, 0],
            [1, 0, 0, 0, 0, 0]
        ]
        XCTAssert(try calculateReverse(example2).elementsArray == resultArray)
    }

    func testExample32() throws {
        let example2: [[Double]] = [
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 1, 0],
            [0, 0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0, 0],
            [0, 1, 0, 0, 0, 0],
            [1, 0, 0, 0, 0, 0]
        ]
        XCTAssertThrowsError(try calculateReverse(example2)) { error in
            XCTAssertEqual(error as? ReverseMatrixError, ReverseMatrixError.notExist)
        }
    }

    func testExample33() throws {
        let example2: [[Double]] = [
            [0, 0, 1, 0, 0],
            [0, 0, 0, 1, 0],
            [0, 0, 0, 0, 1],
            [1, 2, 1, 2, 3],
            [-1, -1, -1, 3, 1]
        ]
        let resultArray: [[Double]] = [
            [-1, 8, 5, -1, -2],
            [0, -5, -4, 1, 1],
            [1, 0, 0, 0, 0],
            [0, 1, 0, 0, 0],
            [0, 0, 1, 0, 0]
        ]
        XCTAssert(try calculateReverse(example2).elementsArray == resultArray)
    }

    // MARK: - LU

    func testExample34() throws {
        let example2: [[Double]] = [
            [5, 2, 3],
            [1, 6, 2],
            [1, 2, 7]
        ]
        let res1 = try calculateLU(example2, side: .left)
        let res2 = try calculateLU(example2, side: .right)
        XCTAssert((res1.0 * res1.1).elementsArray == example2)
        XCTAssert((res2.0 * res2.1).elementsArray == example2)
    }

    func testExample35() throws {
        let example2: [[Double]] = [
            [3, 4, -9, 5],
            [-15, -12, 50, -16],
            [-27, -36, 73, 8],
            [9, 12, -10, -16]
        ]
        let res1 = try calculateLU(example2, side: .left)
        let res2 = try calculateLU(example2, side: .right)
        XCTAssert((res1.0 * res1.1).elementsArray == example2)
        XCTAssert((res2.0 * res2.1).elementsArray == example2)
    }

    func testExample36() throws {
        let example2: [[Double]] = [
            [1, 2, 3],
            [1, 2, 2],
            [1, 9, 7]
        ]
        XCTAssertThrowsError(try calculateLU(example2, side: .left)) { error in
            XCTAssertEqual(error as? LUError, LUError.dividedByZero)
        }
    }

    func testExample37() throws {
        let example2: [[Double]] = [
            [1, 2, 3, 5],
            [1, 2, 2, 5],
            [1, 9, 7, 5]
        ]
        XCTAssertThrowsError(try calculateLU(example2, side: .left)) { error in
            XCTAssertEqual(error as? LUError, LUError.nonQuadraticMatrix)
        }
    }

    // MARK: - LUSolver

    func testExample38() throws {
        let example1: [[Double]] = [
            [1, 3, 0, 1],
            [1, 4, 0, 1],
            [1, 0, 1, 1]
        ]
        XCTAssert(try solveByLU(example1) == [1.0, 0.0, 0.0])
    }

    func testExample41() throws {
        let example2: [[Double]] = [
            [1, 0, 0, 0, 1],
            [0, 1, 0, 0, 1],
            [0, 0, 1, 0, 1],
            [0, 0, 0, 1, 1],
        ]
        XCTAssert(try solveByLU(example2) == [1, 1, 1, 1])
    }

    // MARK: - Reverse by LU

//    func testExample42() throws {
//        let example2: [[Double]] = [
//            [6, 5, 0, 0],
//            [5, 4, 0, 0],
//            [0, 0, 6, 5],
//            [0, 0, 5, 4]
//        ]
//        let resultArray: [[Double]] = [
//            [-4, 5, 0, 0],
//            [5, -6, 0, 0],
//            [0, 0, -4, 5],
//            [0, 0, 5, -6]
//        ]
//        XCTAssert(try calculateReverse(example2, byLU: true).elementsArray == resultArray)
//    }
//
//    func testExample43() throws {
//        let example2: [[Double]] = [
//            [7, 4],
//            [5, 3]
//        ]
//        let resultArray: [[Double]] = [
//            [3, -4],
//            [-5, 7]
//        ]
//        XCTAssert(try calculateReverse(example2, byLU: true).elementsArray == resultArray)
//    }

    func testExample44() throws {
        let example2: [[Double]] = [
            [1, 3, -5],
            [0, 1, 2],
            [0, 0, 1]
        ]
        let resultArray: [[Double]] = [
            [1, -3, 11],
            [0, 1, -2],
            [0, 0, 1]
        ]
        XCTAssert(try calculateReverse(example2, byLU: true).elementsArray == resultArray)
    }

    func testExample45() throws {
        let example2: [[Double]] = [
            [1, 0, 0, 0, 0, 0],
            [0, 1, 0, 0, 0, 0],
            [0, 0, 1, 0, 0, 0],
            [0, 0, 0, 1, 0, 0],
            [0, 0, 0, 0, 1, 0],
            [0, 0, 0, 0, 0, 1]
        ]
        let resultArray: [[Double]] = [
            [1, 0, 0, 0, 0, 0],
            [0, 1, 0, 0, 0, 0],
            [0, 0, 1, 0, 0, 0],
            [0, 0, 0, 1, 0, 0],
            [0, 0, 0, 0, 1, 0],
            [0, 0, 0, 0, 0, 1]
        ]
        XCTAssert(try calculateReverse(example2, byLU: true).elementsArray == resultArray)
    }

//    func testExample46() throws {
//        let example2: [[Double]] = [
//            [6, 5],
//            [5, 4]
//        ]
//        let resultArray: [[Double]] = [
//            [-4, 5],
//            [5, -6]
//        ]
//        XCTAssert(try calculateReverse(example2, byLU: true).elementsArray == resultArray)
//    }

    // MARK: - Test

    ///LU
    func testExample47() throws {
        let example2: [[Double]] = [
            [2, -1, 3, -2, 0],
            [4, -4, 7, -5, 2],
            [0, 4, 0, 6, -8],
            [2, 1, 8, 9, -11],
            [0, -4, 4, 4, -1]
        ]
        let res1 = try calculateLU(example2, side: .left)
        let res2 = try calculateLU(example2, side: .right)
        XCTAssert((res1.0 * res1.1).elementsArray == example2)
        XCTAssert((res2.0 * res2.1).elementsArray == example2)
    }

    ///SOLVE
    func testExample48() throws {
        let example1: [[Double]] = [
            [2, -1, 3, -2, 0, 1],
            [4, -4, 7, -5, 2, 0],
            [0, 4, 0, 6, -8, 4],
            [2, 1, 8, 9, -11, 3],
            [0, -4, 4, 4, -1, -4]
        ]
        XCTAssert(try solveByLU(example1) == [1.0, 1.0, 0.0, 0.0, 0.0])
    }

    ///REVERSE
    func testExample49() throws {
        let example2: [[Double]] = [
            [2, -1, 3, -2, 0],
            [4, -4, 7, -5, 2],
            [0, 4, 0, 6, -8],
            [2, 1, 8, 9, -11],
            [0, -4, 4, 4, -1]
        ]
        let resultArray: [[Double]] = [
            [213/16, -101/16, -3/2, -3/16, 23/16],
            [37/8, -21/8, -3/2, 5/8, -1/8],
            [-3/2, 1/2, -1/2, 1/2, -1/2],
            [33/4, -17/4, -3/2, 1/4, 3/4],
            [17/2, -9/2, -2, 1/2, 1/2]
        ]
        XCTAssert(try calculateReverse(example2, byLU: true).elementsArray == resultArray)
    }

    ///LU
    func testExample50() throws {
        let example2: [[Double]] = [
            [-1, 1, 3, -2],
            [0, 1, 1, 0],
            [0, 0, -2, -1],
            [0, 0, 0, 2]
        ]
        let res1 = try calculateLU(example2, side: .left)
        let res2 = try calculateLU(example2, side: .right)
        XCTAssert((res1.0 * res1.1).elementsArray == example2)
        XCTAssert((res2.0 * res2.1).elementsArray == example2)
    }

    ///SOLVE
    func testExample51() throws {
        let example1: [[Double]] = [
            [-1, 1, 3, -2, 1],
            [0, 1, 1, 0, 2],
            [0, 0, -2, -1, -3],
            [0, 0, 0, 2, 2]
        ]
        XCTAssert(try solveByLU(example1) == [1.0, 1.0, 1.0, 1.0])
    }

    ///REVERSE
    func testExample52() throws {
        let example2: [[Double]] = [
            [-1, 1, 3, -2],
            [0, 1, 1, 0],
            [0, 0, -2, -1],
            [0, 0, 0, 2]
        ]
        let resultArray: [[Double]] = [
            [-1, 1, -1, -1.5],
            [0, 1, 0.5, 0.25],
            [0, 0, -0.5, -0.25],
            [0, 0, 0, 0.5]
        ]
        XCTAssert(try calculateReverse(example2, byLU: true).elementsArray == resultArray)
    }

    ///LU
    func testExample53() throws {
        let example2: [[Double]] = [
            [2, 0, 0, 0],
            [1, 3, 0, 0],
            [-1, 2, 4, 0],
            [3, -3, 2, 5]
        ]
        let res1 = try calculateLU(example2, side: .left)
        let res2 = try calculateLU(example2, side: .right)
        XCTAssert((res1.0 * res1.1).elementsArray == example2)
        XCTAssert((res2.0 * res2.1).elementsArray == example2)
    }

    ///SOLVE
    func testExample54() throws {
        let example1: [[Double]] = [
            [2, 0, 0, 0, 4],
            [1, 3, 0, 0, 5],
            [-1, 2, 4, 0, 0],
            [3, -3, 2, 5, 3]
        ]
        XCTAssert(try solveByLU(example1) == [2.0, 1.0, 0.0, 0.0])
    }

    ///REVERSE
    func testExample55() throws {
        let example2: [[Double]] = [
            [2, 0, 0, 0],
            [1, 3, 0, 0],
            [-1, 2, 4, 0],
            [3, -3, 2, 5]
        ]
        let resultArray: [[Double]] = [
            [0.5, 0, 0, 0],
            [-1/6, 1/3, 0, 0],
            [0, -1/6, 1/4, 0],
            [0, 0, -0.1, 0.2]
        ]
        XCTAssert(try calculateReverse(example2, byLU: true).elementsArray == resultArray)
    }

    // MARK: - Reflections

    func testExample56() throws {
        let example1: [[Double]] = [
            [1, 3, 0, 1],
            [1, 4, 0, 1],
            [1, 0, 1, 1],
        ]
        XCTAssert(try solveByReflections(example1) == [1.0, 0.0, 0.0])
    }

    func testExample57() throws {
        let example2: [[Double]] = [
            [23, 1, 6, 0],
            [0, 0, 2, 2],
            [11, 13, 131, 5],
        ]
        XCTAssert(try solveByReflections(example2) == [1.0/6, -59.0/6, 1])
    }

//    func testExample58() throws {
//        let example3: [[Double]] = [
//            [23, 1, 6, 0],
//            [0, 0, 0, 2],
//            [11, 13, 131, 5],
//        ]
//        XCTAssertThrowsError(try solve(example3)) { error in
//            XCTAssertEqual(error as? SolvingError, SolvingError.zeroSolutions)
//        }
//    }

//    func testExample59() throws {
//        let example4: [[Double]] = [
//            [2, 6, 0, 0],
//            [1, 3, 0, 0],
//            [1, 0, 1, 1],
//        ]
//        XCTAssertThrowsError(try solve(example4)) { error in
//            XCTAssertEqual(error as? SolvingError, SolvingError.eternity)
//        }
//    }

    func testExample60() throws {
        let example2: [[Double]] = [
            [23, 1, 6, 0],
            [0, 0, 2, 2],
            [11, 13, 131, 5]
        ]
        XCTAssert(try solveByReflections(example2) == [1.0/6, -59.0/6, 1])
    }

    func testExample61() throws {
        let example2: [[Double]] = [
            [1, 0, 4, 5, 6],
            [9, 10, 11, 12, 13],
            [14, 15, 16, 17, 18],
            [19, 20, 21, 23, 9]
        ]
        XCTAssert(try solveByReflections(example2) == [-9.6, 3.2, 21.4, -14])
    }

    func testExample62() throws {
        let example2: [[Double]] = [
            [1, 0, 0, 0, 1],
            [0, 1, 0, 0, 1],
            [0, 0, 1, 0, 1],
            [0, 0, 0, 1, 1]
        ]
        XCTAssert(try solveByReflections(example2) == [1, 1, 1, 1])
    }

    func testExample63() throws {
        let example2: [[Double]] = [
            [1, -2, 1, 6],
            [2, -1, 3, 11],
            [2, 3, -4, -7]
        ]
        XCTAssert(try solveByReflections(example2) == [2, -1, 2])
    }

    func testExample64() throws {
        let example2: [[Double]] = [
           [0, 0, -1, 2, 4, 1],
           [0, 0, 3, 0, -2, 3],
           [0, 0, 4, 1, 0, 5],
           [2, 0, 0, 0, 0, 2],
           [0, 2, 1, 0, 0, 3]
        ]
        XCTAssert(try solveByReflections(example2) == [2, -1, 2])
    }

    func testExample65() throws {
        let example2: [[Double]] = [
           [0, 0, -1, 2, 4, 5],
           [0, 0, -1, 0, 2, 1],
           [0, -1, 0, -2, 0, -3],
           [2, 0, -2, 0, 0, 0],
           [4, 2, -1, 0, 0, 5]
        ]
        XCTAssert(try solveByReflections(example2) == [2, -1, 2])
    }

    func testExample66() throws {
        let aitken = AitkenSchemeInterpolator()
        let interval = (1.0, 1.6)
        let count = 6
        let controlPoints: [CGPoint] = [
            .init(x: 1.0, y: 1.0),
            .init(x: 1.1, y: 1.032),
            .init(x: 1.3, y: 1.091),
            .init(x: 1.5, y: 1.145),
            .init(x: 1.6, y: 1.170)
        ]
        let points = aitken.interpolate(controlPoints: controlPoints, interval: interval, plotPointsCount: count)
        print("Interval = \(interval)")
        print("Result = \(points)")
        XCTAssert(1 == 1)
    }
}
