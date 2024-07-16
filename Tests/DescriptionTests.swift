/*
 Tests for Vector and Matrix description.
 */

import XCTest
import Numerix

final class DescriptionTests: XCTestCase {

    func testVectorDescription() {
        let vec = Vector([3, 5.8, 402.89, 1])
        let desc = """
        4-element Vector<Double>
        3.0000 5.8000 402.8900 1.0000
        """
        XCTAssertEqual(String(describing: vec), desc)

        let vec2 = Vector<Float>([3, 5.8, 402.89, 1])
        let desc2 = """
        4-element Vector<Float>
        3.00 5.80 402.89 1.00
        """
        XCTAssertEqual(String(describing: vec2), desc2)
    }

    func testMatrixDescription() {
        let mat = Matrix(rows: 2, columns: 3, values: [3, 4, 8, 10, 11, 18.2])
        let desc = "2x3 Matrix<Double>\n" + " 3.0000   4.0000   8.0000  \n" + "10.0000  11.0000  18.2000  \n"
        XCTAssertEqual(String(describing: mat), desc)

        let mat2 = Matrix<Float>(rows: 2, columns: 3, values: [3, 4, 8, 10, 11, 18.2])
        let desc2 = "2x3 Matrix<Float>\n" + " 3.00   4.00   8.00  \n" + "10.00  11.00  18.20  \n"
        XCTAssertEqual(String(describing: mat2), desc2)
    }
}
