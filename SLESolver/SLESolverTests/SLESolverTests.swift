//
//  SLESolverTests.swift
//  SLESolverTests
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import XCTest
@testable import SLESolver

//
//  main.swift
//  SLESolverExample
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation
import SLESolver

private func solve(_ array: [[Double]]) throws -> Result {
    let matrix = MutableMatrix(array)
    let solver = SLESolverImplementation()
    let result = try solver.solve(matrix)
    print("\nResulting vector \(result)\n")
    return result
}

class SLESolverTests: XCTestCase {

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
        XCTAssert(try solve(example2) == [ -9.6, 3.2, 21.4, -14])
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
}
