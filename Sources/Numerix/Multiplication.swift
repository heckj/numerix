//
//  File.swift
//  
//
//  Created by Gavin Wiggins on 5/18/24.
//

import Accelerate

infix operator .*
infix operator ⊙

// MARK: - Vector multiplication

public func * (lhs: Float, rhs: Vector<Float>) -> Vector<Float> {
    let result = Vector(length: rhs.length) { buffer in
        vDSP.multiply(lhs, rhs.values, result: &buffer)
    }
    return result
}

public func * (lhs: Vector<Float>, rhs: Float) -> Vector<Float> {
    let result = Vector(length: lhs.length) { buffer in
        vDSP.multiply(rhs, lhs.values, result: &buffer)
    }
    return result
}

public func * (lhs: Double, rhs: Vector<Double>) -> Vector<Double> {
    let result = Vector(length: rhs.length) { buffer in
        vDSP.multiply(lhs, rhs.values, result: &buffer)
    }
    return result
}

public func * (lhs: Vector<Double>, rhs: Double) -> Vector<Double> {
    let result = Vector(length: lhs.length) { buffer in
        vDSP.multiply(rhs, lhs.values, result: &buffer)
    }
    return result
}

public func * (lhs: Vector<Float>, rhs: Vector<Float>) -> Vector<Float> {
    let result = Vector(length: lhs.length) { buffer in
        vDSP.multiply(lhs.values, rhs.values, result: &buffer)
    }
    return result
}

public func * (lhs: Vector<Double>, rhs: Vector<Double>) -> Vector<Double> {
    let result = Vector(length: lhs.length) { buffer in
        vDSP.multiply(lhs.values, rhs.values, result: &buffer)
    }
    return result
}

// MARK: - Matrix multiplication

/// Matrix multiplication for integer values. Number of columns in left matrix must equal
/// number of rows in right matrix.
/// - Parameters:
///   - lhs: Left matrix with dimension m x n.
///   - rhs: Right matrix with dimension n x p.
/// - Returns: Matrix with dimension m x p.
public func * (lhs: Matrix<Int>, rhs: Matrix<Int>) -> Matrix<Int> {
    precondition(lhs.columns == rhs.rows, "Number of columns in left matrix must equal number of rows in right matrix")
    let a = lhs.values.compactMap { Double($0) }
    let b = rhs.values.compactMap { Double($0) }
    var c = [Double](repeating: 0.0, count: lhs.rows * rhs.columns)

    let m = lhs.rows     // rows in matrices A and C
    let n = rhs.columns  // columns in matrices B and C
    let k = lhs.columns  // columns in matrix A and rows in matrix B
    let alpha = 1.0
    let beta = 0.0

    // matrix multiplication where C ← αAB + βC
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, alpha, a, k, b, n, beta, &c, n)

    let mat = Matrix(rows: lhs.rows, columns: rhs.columns, values: c.compactMap { Int($0) })
    return mat
}

/// Matrix multiplication for single precision. Number of columns in the left matrix must be
/// equal to the number of rows in the right matrix.
/// - Parameters:
///   - lhs: Left matrix with dimensions of m x n.
///   - rhs: Right matrix with dimensions of n x p.
/// - Returns: Matrix with dimensions of m x p.
public func * (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    precondition(lhs.columns == rhs.rows, "Number of columns in left matrix must equal number of rows in right matrix")
    var a = lhs.values
    var b = rhs.values

    let m = lhs.rows     // number of rows in matrices A and C
    let n = rhs.columns  // number of columns in matrices B and C
    let k = lhs.columns  // number of columns in matrix A; number of rows in matrix B
    let alpha: Float = 1.0
    let beta: Float = 0.0

    // matrix multiplication where C ← αAB + βC
    let c = Matrix<Float>(rows: lhs.rows, columns: rhs.columns) { buffer in
        cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, alpha, &a, k, &b, n, beta, buffer.baseAddress, n)
    }
    return c
}

/// Matrix multiplication for double precision. Number of columns in the left matrix must be
/// equal to the number of rows in the right matrix.
/// - Parameters:
///   - lhs: Left matrix with dimensions of m x n.
///   - rhs: Right matrix with dimensions of n x p.
/// - Returns: Matrix with dimensions of m x p.
public func * (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    precondition(lhs.columns == rhs.rows, "Number of columns in left matrix must equal number of rows in right matrix")
    var a = lhs.values
    var b = rhs.values

    let m = lhs.rows     // number of rows in matrices A and C
    let n = rhs.columns  // number of columns in matrices B and C
    let k = lhs.columns  // number of columns in matrix A; number of rows in matrix B
    let alpha = 1.0
    let beta = 0.0

    // matrix multiplication where C ← αAB + βC
    let c = Matrix<Double>(rows: lhs.rows, columns: rhs.columns) { buffer in
        cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, alpha, &a, k, &b, n, beta, buffer.baseAddress, n)
    }
    return c
}

/// Matrix multiplication for double precision complex. Number of columns in left matrix must be
/// equal to number of rows in the right matrix.
/// - Parameters:
///   - lhs: Left matrix with dimensions of m x n.
///   - rhs: Right matrix with dimensions of n x p.
/// - Returns: Matrix with dimensions of m x p.
public func * (lhs: Matrix<Complex<Double>>, rhs: Matrix<Complex<Double>>) -> Matrix<Complex<Double>> {
    precondition(lhs.columns == rhs.rows, "Number of columns in left matrix must equal number of rows in right matrix")
    let a = lhs.values
    let b = rhs.values

    let m = lhs.rows     // rows in matrices A and C
    let n = rhs.columns  // columns in matrices B and C
    let k = lhs.columns  // columns in matrix A and rows in matrix B

    let alpha = [Complex(real: 1.0, imag: 0.0)]
    let beta = [Complex(real: 1.0, imag: 0.0)]

    let c = Matrix<Complex<Double>>(rows: lhs.rows, columns: rhs.columns) { buffer in
        cblas_zgemm_wrapper(m, n, k, alpha, a, k, b, n, beta, buffer.baseAddress!, n)
    }
    return c
}

/// Element-wise matrix multiplication for single precision matrices. Matrices must have same dimensions.
/// This is also known as the Hadamard product or Schur product.
/// - Parameters:
///   - lhs: Left matrix with dimension of m x n.
///   - rhs: Right matrix with dimension m x n.
/// - Returns: Matrix of the same dimensions.
public func .* (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must have same dimensions")
    let result = Matrix(rows: lhs.rows, columns: lhs.columns) { buffer in
        vDSP.multiply(lhs.values, rhs.values, result: &buffer)
    }
    return result
}

/// Element-wise matrix multiplication for double precision matrices. Matrices must have same dimensions.
/// This is also known as the Hadamard product or Schur product.
/// - Parameters:
///   - lhs: Left matrix with dimension of m x n.
///   - rhs: Right matrix with dimension m x n.
/// - Returns: Matrix of the same dimensions.
public func .* (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must have same dimensions")
    let result = Matrix(rows: lhs.rows, columns: lhs.columns) { buffer in
        vDSP.multiply(lhs.values, rhs.values, result: &buffer)
    }
    return result
}

/// Element-wise matrix multiplication for single precision matrices. Matrices must have same dimensions.
/// This is also known as the Hadamard product or Schur product.
/// - Parameters:
///   - lhs: Left matrix with dimension of m x n.
///   - rhs: Right matrix with dimension m x n.
/// - Returns: Matrix of the same dimensions.
public func ⊙ (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must have same dimensions")
    let result = Matrix(rows: lhs.rows, columns: lhs.columns) { buffer in
        vDSP.multiply(lhs.values, rhs.values, result: &buffer)
    }
    return result
}

/// Element-wise matrix multiplication for double precision matrices. Matrices must have same dimensions.
/// This is also known as the Hadamard product or Schur product.
/// - Parameters:
///   - lhs: Left matrix with dimension of m x n.
///   - rhs: Right matrix with dimension m x n.
/// - Returns: Matrix of the same dimensions.
public func ⊙ (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must have same dimensions")
    let result = Matrix(rows: lhs.rows, columns: lhs.columns) { buffer in
        vDSP.multiply(lhs.values, rhs.values, result: &buffer)
    }
    return result
}
