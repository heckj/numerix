/*
 Subtraction operators for Vector and Matrix structures. Single and double
 precision operations are supported.
 */

import Accelerate

// MARK: Scalar-Vector subtraction

public func - (lhs: Float, rhs: Vector<Float>) -> Vector<Float> {
    let arr = Array(repeating: lhs, count: rhs.length)
    var result = Vector<Float>(length: rhs.length)
    vDSP.subtract(arr, rhs.buffer, result: &result.buffer)
    return result
}

public func - (lhs: Double, rhs: Vector<Double>) -> Vector<Double> {
    let arr = Array(repeating: lhs, count: rhs.length)
    var result = Vector<Double>(length: rhs.length)
    vDSP.subtract(arr, rhs.buffer, result: &result.buffer)
    return result
}

// MARK: Vector-Scalar subtraction

public func - (lhs: Vector<Float>, rhs: Float) -> Vector<Float> {
    let arr = Array(repeating: rhs, count: lhs.length)
    var result = Vector<Float>(length: lhs.length)
    vDSP.subtract(lhs.buffer, arr, result: &result.buffer)
    return result
}

public func - (lhs: Vector<Double>, rhs: Double) -> Vector<Double> {
    let arr = Array(repeating: rhs, count: lhs.length)
    var result = Vector<Double>(length: lhs.length)
    vDSP.subtract(lhs.buffer, arr, result: &result.buffer)
    return result
}

// MARK: Vector-Vector subtraction

public func - (lhs: Vector<Float>, rhs: Vector<Float>) -> Vector<Float> {
    precondition(lhs.length == rhs.length, "Vectors must be same length")
    var result = Vector<Float>(length: lhs.length)
    vDSP.subtract(lhs.buffer, rhs.buffer, result: &result.buffer)
    return result
}

public func - (lhs: Vector<Double>, rhs: Vector<Double>) -> Vector<Double> {
    precondition(lhs.length == rhs.length, "Vectors must be same length")
    var result = Vector<Double>(length: lhs.length)
    vDSP.subtract(lhs.buffer, rhs.buffer, result: &result.buffer)
    return result
}

// MARK: Scalar-Matrix subtraction

public func - (lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
    var mat = Matrix<Float>(rows: rhs.rows, columns: rhs.columns)
    vDSP.subtract(mat.buffer, rhs.buffer, result: &mat.buffer)
    return mat
}

public func - (lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
    var mat = Matrix<Double>(rows: rhs.rows, columns: rhs.columns)
    vDSP.subtract(mat.buffer, rhs.buffer, result: &mat.buffer)
    return mat
}

// MARK: Matrix-Scalar subtraction

public func - (lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
    var mat = Matrix<Float>(rows: lhs.rows, columns: lhs.columns)
    vDSP.subtract(lhs.buffer, mat.buffer, result: &mat.buffer)
    return mat
}

public func - (lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
    var mat = Matrix<Double>(rows: lhs.rows, columns: lhs.columns)
    vDSP.subtract(lhs.buffer, mat.buffer, result: &mat.buffer)
    return mat
}

// MARK: Matrix-Matrix subtraction

public func - (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    var mat = Matrix<Float>(rows: lhs.rows, columns: lhs.columns)
    vDSP.subtract(lhs.buffer, rhs.buffer, result: &mat.buffer)
    return mat
}

public func - (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    var mat = Matrix<Double>(rows: lhs.rows, columns: lhs.columns)
    vDSP.subtract(lhs.buffer, rhs.buffer, result: &mat.buffer)
    return mat
}
