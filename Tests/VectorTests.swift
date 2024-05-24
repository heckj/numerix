// Tests for vector initialization, properties, subscript, addition,
// subtraction, and multiplication.

import XCTest
import Numerix

final class VectorTests: XCTestCase {

    func testInit() {
        let vec1 = Vector(length: 5)
        let vec2 = Vector(length: 4, fill: 2.2)

        XCTAssertEqual(vec1[0], 0.0)
        XCTAssertEqual(vec2[0], 2.2)
    }

    func testProperties() {
        let vec = Vector([3, 4, 5, 6])
        XCTAssertEqual(vec.length, 4)
    }

    func testSubscript() {
        let vec = Vector([3, 5.8, 402.89, 1])
        XCTAssertEqual(vec[0], 3)
    }

    func testArrayLiteral() {
        let vec: Vector = [3, 4, 5, 6, 7, 8]
        XCTAssertEqual(vec.values, [3, 4, 5, 6, 7, 8])

        let vecFloat: Vector<Float> = [1, 2, 3, 4]
        XCTAssertEqual(vecFloat.values, [1, 2, 3, 4])

        let vecDouble: Vector = [1.0, 2, 3, 4.9]
        XCTAssertEqual(vecDouble.values, [1.0, 2, 3, 4.9])
    }

    func testAddition() {
        let vec1 = Vector<Double>([1, 2, 3, 4])
        let vec2 = Vector<Double>([5, 2, 3, 1])
        let vec3 = Vector<Float>([5, 4, 3, 2])
        let vec4 = Vector<Float>([6, 5, 4, 3])

        XCTAssert(isApprox(vec1 + vec2, Vector([6, 4, 6, 5])))
        XCTAssert(isApprox(vec3 + vec4, Vector<Float>([11, 9, 7, 5])))
        XCTAssert(isApprox(vec1 + 2.0, Vector([3, 4, 5, 6])))
        XCTAssert(isApprox(2.0 + vec1, Vector([3, 4, 5, 6])))
        XCTAssert(isApprox(vec3 + 2.0, Vector<Float>([7, 6, 5, 4])))
        XCTAssert(isApprox(2.0 + vec3, Vector<Float>([7, 6, 5, 4])))
    }

    func testSubtraction() {
        let vec1 = Vector([3.8, 4, 5, 6])
        let vec2 = Vector([1, 2, 3, 4.8])
        XCTAssert(isApprox(vec1 - vec2, Vector([2.8, 2, 2, 1.2])))
        XCTAssert(isApprox(vec1 - 2.0, Vector([1.8, 2, 3, 4])))
        XCTAssert(isApprox(2.0 - vec1, Vector([-1.8, -2, -3, -4])))
    }

    func testMultiplication() {
        let vec1 = Vector<Double>([1, 2, 3, 4])
        let vec2 = Vector<Double>([2, 3, 4, 5])

        XCTAssert(isApprox(vec1 * vec2, Vector([2, 6, 12, 20])))
        XCTAssert(isApprox(2.0 * vec1, Vector([2, 4, 6, 8])))
        XCTAssert(isApprox(vec1 * 2.0, Vector([2, 4, 6, 8])))

        let vec3 = Vector<Float>([1, 2, 3, 4])
        let vec4 = Vector<Float>([2, 3, 4, 5])

        XCTAssert(isApprox(vec3 * vec4, Vector<Float>([2, 6, 12, 20])))
        XCTAssert(isApprox(2.0 * vec3, Vector<Float>([2, 4, 6, 8])))
        XCTAssert(isApprox(vec3 * 2.0, Vector<Float>([2, 4, 6, 8])))
    }

    func testMaxAbsIndex() {
        let vec1 = Vector<Float>([1, 2, 5, 3, 19, 0.2])
        let idx1 = vec1.maxAbsIndex()
        XCTAssertEqual(idx1, 4)

        let vec2 = Vector([1, 2, 5, 3, 0.4, -10, 8])
        let idx2 = vec2.maxAbsIndex()
        XCTAssertEqual(idx2, 5)
    }
}
