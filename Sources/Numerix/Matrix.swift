//
//  File.swift
//  
//
//  Created by Gavin Wiggins on 3/16/24.
//

import Accelerate

public struct Matrix<T> {

    /// Number of matrix rows.
    public let rows: Int

    /// Number of matrix columns.
    public let columns: Int

    /// Underlying matrix values as an Array.
    public var values: [T]

    /// Create a Matrix with size m x n where m is number of rows and n is
    /// number of columns.
    /// - Parameters:
    ///   - rows: Number of rows.
    ///   - columns: Number of columns.
    ///   - values: Array of values.
    public init(rows: Int, columns: Int, values: [T]) {
        self.rows = rows
        self.columns = columns
        self.values = values
    }

    public init(rows: Int, columns: Int, fill: T = 0.0) {
        self.rows = rows
        self.columns = columns
        self.values = Array(repeating: fill, count: rows * columns)
    }

    /// Create a Matrix from a 2D Array such as [[1, 2], [3, 4]].
    /// - Parameter content: A two-dimensional Array.
    public init(_ content: [[T]]) {
        self.rows = content.count
        self.columns = content[0].count
        self.values = content.flatMap { $0 }
    }

    public subscript(row: Int, column: Int) -> T {
        get { return values[(row * columns) + column] }
        set { values[(row * columns) + column] = newValue }
    }
}

// MARK: - Addition

extension Matrix {

    /// Element-wise sum of two matrices with double precision.
    /// - Parameters:
    ///   - lhs: Matrix A.
    ///   - rhs: Matrix B.
    /// - Returns: The sum of A[i] + B[i].
    public static func + (lhs: Matrix, rhs: Matrix) -> Matrix where T == Double {
        precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must be same shape")
        let vec = vDSP.add(lhs.values, rhs.values)
        return Matrix(rows: lhs.rows, columns: lhs.columns, values: vec)
    }

    /// Element-wise sum of two matrices with single precision.
    /// - Parameters:
    ///   - lhs: Matrix A.
    ///   - rhs: Matrix B.
    /// - Returns: The sum of A[i] + B[i].
    public static func + (lhs: Matrix, rhs: Matrix) -> Matrix where T == Float {
        precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must be same shape")
        let vec = vDSP.add(lhs.values, rhs.values)
        return Matrix(rows: lhs.rows, columns: lhs.columns, values: vec)
    }

    /// Element-wise sum of a matrix and a scalar with double precision.
    /// - Parameters:
    ///   - lhs: Matrix A.
    ///   - rhs: Scalar value.
    /// - Returns: The sum of A[i] + scalar.
    public static func + (lhs: Matrix, rhs: T) -> Matrix where T == Double {
        let vec = vDSP.add(rhs, lhs.values)
        return Matrix(rows: lhs.rows, columns: lhs.columns, values: vec)
    }

    /// Element-wise sum of a matrix and a scalar with double precision.
    /// - Parameters:
    ///   - lhs: Scalar value
    ///   - rhs: Matrix B.
    /// - Returns: The sum of scalar + B[i].
    public static func + (lhs: T, rhs: Matrix) -> Matrix where T == Double {
        let vec = vDSP.add(lhs, rhs.values)
        return Matrix(rows: rhs.rows, columns: rhs.columns, values: vec)
    }

    /// Element-wise sum of a matrix and a scalar with double precision.
    /// - Parameters:
    ///   - lhs: Matrix A.
    ///   - rhs: Scalar value.
    /// - Returns: The sum of A[i] + scalar.
    public static func + (lhs: Matrix, rhs: T) -> Matrix where T == Float {
        let vec = vDSP.add(rhs, lhs.values)
        return Matrix(rows: lhs.rows, columns: lhs.columns, values: vec)
    }

    /// Element-wise sum of a matrix and a scalar with double precision.
    /// - Parameters:
    ///   - lhs: Scalar value
    ///   - rhs: Matrix B.
    /// - Returns: The sum of scalar + B[i].
    public static func + (lhs: T, rhs: Matrix) -> Matrix where T == Float {
        let vec = vDSP.add(lhs, rhs.values)
        return Matrix(rows: rhs.rows, columns: rhs.columns, values: vec)
    }
}

// MARK: - Subtraction

extension Matrix {

    public static func - (lhs: T, rhs: Matrix) -> Matrix where T == Double {
        let arr = Array(repeating: lhs, count: rhs.values.count)
        let vec = vDSP.subtract(arr, rhs.values)
        return Matrix(rows: rhs.rows, columns: rhs.columns, values: vec)
    }

    public static func - (lhs: Matrix, rhs: T) -> Matrix where T == Double {
        let arr = Array(repeating: rhs, count: lhs.values.count)
        let vec = vDSP.subtract(lhs.values, arr)
        return Matrix(rows: lhs.rows, columns: lhs.columns, values: vec)
    }

    public static func - (lhs: T, rhs: Matrix) -> Matrix where T == Float {
        let arr = Array(repeating: lhs, count: rhs.values.count)
        let vec = vDSP.subtract(arr, rhs.values)
        return Matrix(rows: rhs.rows, columns: rhs.columns, values: vec)
    }

    public static func - (lhs: Matrix, rhs: T) -> Matrix where T == Float {
        let arr = Array(repeating: rhs, count: lhs.values.count)
        let vec = vDSP.subtract(lhs.values, arr)
        return Matrix(rows: lhs.rows, columns: lhs.columns, values: vec)
    }

    public static func - (lhs: Matrix, rhs: Matrix) -> Matrix where T == Double {
        let vec = vDSP.subtract(lhs.values, rhs.values)
        return Matrix(rows: rhs.rows, columns: rhs.columns, values: vec)
    }

    public static func - (lhs: Matrix, rhs: Matrix) -> Matrix where T == Float {
        let vec = vDSP.subtract(lhs.values, rhs.values)
        return Matrix(rows: rhs.rows, columns: rhs.columns, values: vec)
    }
}

// MARK: - Multiplication

infix operator .*
infix operator ⊙

extension Matrix {

    /// Matrix multiplication for double precision. Number of columns in the left matrix must be
    /// equal to the number of rows in the right matrix.
    /// - Parameters:
    ///   - lhs: Left matrix with dimensions of m x n.
    ///   - rhs: Right matrix with dimensions of n x p.
    /// - Returns: Matrix with dimensions of m x p.
    public static func * (lhs: Matrix, rhs: Matrix) -> Matrix where T == Double {
        precondition(lhs.columns == rhs.rows, "Number of columns in left matrix must equal number of rows in right matrix")
        var a = lhs.values
        var b = rhs.values
        var c = [Double](repeating: 0.0, count: lhs.rows * rhs.columns)

        let m = lhs.rows     // number of rows in matrices A and C
        let n = rhs.columns  // number of columns in matrices B and C
        let k = lhs.columns  // number of columns in matrix A; number of rows in matrix B
        let alpha = 1.0
        let beta = 0.0

        // matrix multiplication where C ← αAB + βC
        cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, alpha, &a, k, &b, n, beta, &c, n)

        let mat = Matrix(rows: lhs.rows, columns: rhs.columns, values: c)
        return mat
    }

    /// Matrix multiplication for single precision. Number of columns in the left matrix must be
    /// equal to the number of rows in the right matrix.
    /// - Parameters:
    ///   - lhs: Left matrix with dimensions of m x n.
    ///   - rhs: Right matrix with dimensions of n x p.
    /// - Returns: Matrix with dimensions of m x p.
    public static func * (lhs: Matrix, rhs: Matrix) -> Matrix where T == Float {
        precondition(lhs.columns == rhs.rows, "Number of columns in left matrix must equal number of rows in right matrix")
        var a = lhs.values
        var b = rhs.values
        var c = [Float](repeating: 0.0, count: lhs.rows * rhs.columns)

        let m = lhs.rows     // number of rows in matrices A and C
        let n = rhs.columns  // number of columns in matrices B and C
        let k = lhs.columns  // number of columns in matrix A; number of rows in matrix B
        let alpha: Float = 1.0
        let beta: Float = 0.0

        // matrix multiplication where C ← αAB + βC
        cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, alpha, &a, k, &b, n, beta, &c, n)

        let mat = Matrix(rows: lhs.rows, columns: rhs.columns, values: c)
        return mat
    }
    
    /// Matrix multiplication for integer values. Number of columns in left matrix must equal
    /// number of rows in right matrix.
    /// - Parameters:
    ///   - lhs: Left matrix with dimension m x n.
    ///   - rhs: Right matrix with dimension n x p.
    /// - Returns: Matrix with dimension m x p.
    public static func * (lhs: Matrix, rhs: Matrix) -> Matrix where T == Int {
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

        let mat = Matrix(rows: lhs.rows, columns: rhs.columns, values: c.compactMap { Int($0) } )
        return mat
    }

    /// Matrix multiplication for double precision complex. Number of columns in left matrix must be
    /// equal to number of rows in the right matrix.
    /// - Parameters:
    ///   - lhs: Left matrix with dimensions of m x n.
    ///   - rhs: Right matrix with dimensions of n x p.
    /// - Returns: Matrix with dimensions of m x p.
    public static func * (lhs: Matrix, rhs: Matrix) -> Matrix where T == Complex<Double> {
        precondition(lhs.columns == rhs.rows, "Number of columns in left matrix must equal number of rows in right matrix")
        let a = lhs.values
        let b = rhs.values
        var c = [Complex](repeating: Complex(real: 0.0, imag: 0.0), count: lhs.rows * rhs.columns)

        let m = lhs.rows     // rows in matrices A and C
        let n = rhs.columns  // columns in matrices B and C
        let k = lhs.columns  // columns in matrix A and rows in matrix B

        let alpha = [Complex(real: 1.0, imag: 0.0)]
        let beta = [Complex(real: 1.0, imag: 0.0)]

        cblas_zgemm_wrapper(m, n, k, alpha, a, k, b, n, beta, &c, n)

        let mat = Matrix(rows: lhs.rows, columns: rhs.columns, values: c)
        return mat
    }

    /// Element-wise matrix multiplication for double precision matrices. Matrices must have same dimensions.
    /// This is also known as the Hadamard product or Schur product.
    /// - Parameters:
    ///   - lhs: Left matrix with dimension of m x n.
    ///   - rhs: Right matrix with dimension m x n.
    /// - Returns: Matrix of the same dimensions.
    public static func .* (lhs: Matrix, rhs: Matrix) -> Matrix where T == Double {
        precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must have same dimensions")
        let vec = vDSP.multiply(lhs.values, rhs.values)
        let mat = Matrix(rows: lhs.rows, columns: lhs.columns, values: vec)
        return mat
    }

    /// Element-wise matrix multiplication for single precision matrices. Matrices must have same dimensions.
    /// This is also known as the Hadamard product or Schur product.
    /// - Parameters:
    ///   - lhs: Left matrix with dimension of m x n.
    ///   - rhs: Right matrix with dimension m x n.
    /// - Returns: Matrix of the same dimensions.
    public static func .* (lhs: Matrix, rhs: Matrix) -> Matrix where T == Float {
        precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must have same dimensions")
        let vec = vDSP.multiply(lhs.values, rhs.values)
        let mat = Matrix(rows: lhs.rows, columns: lhs.columns, values: vec)
        return mat
    }

    /// Element-wise matrix multiplication for double precision matrices. Matrices must have same dimensions.
    /// This is also known as the Hadamard product or Schur product.
    /// - Parameters:
    ///   - lhs: Left matrix with dimension of m x n.
    ///   - rhs: Right matrix with dimension m x n.
    /// - Returns: Matrix of the same dimensions.
    public static func ⊙ (lhs: Matrix, rhs: Matrix) -> Matrix where T == Double {
        precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must have same dimensions")
        let vec = vDSP.multiply(lhs.values, rhs.values)
        let mat = Matrix(rows: lhs.rows, columns: lhs.columns, values: vec)
        return mat
    }

    /// Element-wise matrix multiplication for single precision matrices. Matrices must have same dimensions.
    /// This is also known as the Hadamard product or Schur product.
    /// - Parameters:
    ///   - lhs: Left matrix with dimension of m x n.
    ///   - rhs: Right matrix with dimension m x n.
    /// - Returns: Matrix of the same dimensions.
    public static func ⊙ (lhs: Matrix, rhs: Matrix) -> Matrix where T == Float {
        precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must have same dimensions")
        let vec = vDSP.multiply(lhs.values, rhs.values)
        let mat = Matrix(rows: lhs.rows, columns: lhs.columns, values: vec)
        return mat
    }
}

// MARK: - Division

/// Element-wise division of a scalar by a matrix using double precision.
///
/// This divides a scalar value A by each value in matrix B and returns the result as matrix C such that A / B[i] = C[i] where i is the index of the matrix. The operation is performed using double precision values.
///
/// - Parameters:
///   - scalar: The input scalar A in A / B[i] = C[i].
///   - matrix: The input matrix B in A / B[i] = C[i].
/// - Returns: The output matrix C in A / B[i] = C[i].
public func divide(_ scalar: Double, _ matrix: Matrix<Double>) -> Matrix<Double> {
    let result = vDSP.divide(scalar, matrix.values)
    return Matrix(rows: matrix.rows, columns: matrix.columns, values: result)
}

/// Element-wise division of a scalar by a matrix using double precision.
///
/// This divides a scalar value A by each value in matrix B and returns the result as matrix C such that A / B[i] = C[i] where i is the index of the matrix. The operation is performed using double precision values.
///
/// - Parameters:
///   - lhs: The input scalar A in A / B[i] = C[i].
///   - rhs: The input matrix B in A / B[i] = C[i].
/// - Returns: The output matrix C in A / B[i] = C[i].
public func / (lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
    return divide(lhs, rhs)
}

/// Element-wise division of a matrix by a scalar using double precision.
///
/// This divides each value in matrix A by a scalar value B and returns the result as matrix C such that A[i] / B = C[i] where i is the index of the matrix. The operation is performed using double precision values.
///
/// - Parameters:
///   - matrix: The input matrix A in A[i] / B = C[i].
///   - scalar: The input scalar B in A[i] / B = C[i].
/// - Returns: The output matrix C in A[i] / B = C[i].
public func divide(_ matrix: Matrix<Double>, _ scalar: Double) -> Matrix<Double> {
    let result = vDSP.divide(matrix.values, scalar)
    return Matrix(rows: matrix.rows, columns: matrix.columns, values: result)
}

/// Element-wise division of a matrix by a scalar using double precision.
///
/// This divides each value in matrix A by a scalar value B and returns the result as matrix C such that A[i] / B = C[i] where i is the index of the matrix. The operation is performed using double precision values.
///
/// - Parameters:
///   - lhs: The input matrix A in A[i] / B = C[i].
///   - rhs: The input scalar B in A[i] / B = C[i].
/// - Returns: The output matrix C in A[i] / B = C[i].
public func / (lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
    return divide(lhs, rhs)
}
