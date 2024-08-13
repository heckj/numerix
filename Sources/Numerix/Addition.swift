/*
 Addition operators for Vector, Matrix, and ShapedArray structures. Single and double
 precision operations are supported.
 */

import Accelerate

// MARK: Scalar-Vector addition

/// Element-wise addition of a scalar and a vector with single precision.
/// - Parameters:
///   - lhs: Scalar value.
///   - rhs: Vector of length n.
/// - Returns: Vector of length n.
public func + (lhs: Float, rhs: Vector<Float>) -> Vector<Float> {
    var vec = Vector<Float>(length: rhs.length)
    vDSP.add(lhs, rhs.buffer, result: &vec.buffer)
    return vec
}

/// Element-wise addition of a scalar and a vector with double precision.
/// - Parameters:
///   - lhs: Scalar value.
///   - rhs: Vector of length n.
/// - Returns: Vector of length n.
public func + (lhs: Double, rhs: Vector<Double>) -> Vector<Double> {
    var vec = Vector<Double>(length: rhs.length)
    vDSP.add(lhs, rhs.buffer, result: &vec.buffer)
    return vec
}

// MARK: Vector-Scalar addition

/// Element-wise addition of a vector and a scalar with single precision.
/// - Parameters:
///   - lhs: Vector of length n.
///   - rhs: Scalar value
/// - Returns: Vector of length n.
public func + (lhs: Vector<Float>, rhs: Float) -> Vector<Float> {
    var vec = Vector<Float>(length: lhs.length)
    vDSP.add(rhs, lhs.buffer, result: &vec.buffer)
    return vec
}

/// Element-wise addition of a vector and a scalar with double precision.
/// - Parameters:
///   - lhs: Vector of length n.
///   - rhs: Scalar value
/// - Returns: Vector of length n.
public func + (lhs: Vector<Double>, rhs: Double) -> Vector<Double> {
    var vec = Vector<Double>(length: lhs.length)
    vDSP.add(rhs, lhs.buffer, result: &vec.buffer)
    return vec
}

/// In-place element-wise addition of a vector and scalar with single precision.
/// - Parameters:
///   - lhs: Mutable input vector.
///   - rhs: Input scalar.
public func += (lhs: inout Vector<Float>, rhs: Float) {
    lhs = lhs + rhs
}

/// In-place element-wise addition of a vector and scalar with double precision.
/// - Parameters:
///   - lhs: Mutable input vector.
///   - rhs: Input scalar.
public func += (lhs: inout Vector<Double>, rhs: Double) {
    lhs = lhs + rhs
}

// MARK: Vector-Vector addition

/// Element-wise addition of two integer vectors.
///
/// Add the elements in two 32-bit integer vectors. The vectors must be the same length.
/// ```swift
/// let vecA = Vector<Int32>([1, 2, 3, 4])
/// let vecB = Vector<Int32>([4, 5, 6, 7])
/// let vecC = vecA + vecB
/// // vecC is [5, 7, 9, 11]
/// ```
///
/// - Parameters:
///   - lhs: Input vector `A`.
///   - rhs: Input vector `B`.
/// - Returns: Output vector `C` that represents `A[i] + B[i]`.
public func + (lhs: Vector<Int32>, rhs: Vector<Int32>) -> Vector<Int32> {
    precondition(lhs.length == rhs.length, "Vectors must be same length")
    let vec = Vector<Int32>(length: lhs.length)
    vDSP_vaddi(
        lhs.buffer.baseAddress!, 1,
        rhs.buffer.baseAddress!, 1,
        vec.buffer.baseAddress!, 1,
        vDSP_Length(lhs.length)
    )
    return vec
}

/// Element-wise addition of two vectors with single precision. Vectors must be same length.
/// - Parameters:
///   - lhs: Vector of length n.
///   - rhs: Vector of length n.
/// - Returns: Vector of length n.
public func + (lhs: Vector<Float>, rhs: Vector<Float>) -> Vector<Float> {
    precondition(lhs.length == rhs.length, "Vectors must be same length")
    var vec = Vector<Float>(length: lhs.length)
    vDSP.add(lhs.buffer, rhs.buffer, result: &vec.buffer)
    return vec
}

/// Element-wise addition of two vectors with double precision. Vectors must be same length.
/// - Parameters:
///   - lhs: Vector of length n.
///   - rhs: Vector of length n.
/// - Returns: Vector of length n.
public func + (lhs: Vector<Double>, rhs: Vector<Double>) -> Vector<Double> {
    precondition(lhs.length == rhs.length, "Vectors must be same length")
    var vec = Vector<Double>(length: lhs.length)
    vDSP.add(lhs.buffer, rhs.buffer, result: &vec.buffer)
    return vec
}

/// In-place element-wise addition of integer vectors.
///
/// Perform in-place addition of 32-bit integer vectors. The vectors must be the same length.
/// ```swift
/// var vec = Vector<Int32>([1, 2, 3, 4])
/// vec += Vector<Int32>([5, 6, 7, 8])
/// // vec becomes [6, 8, 10, 12])
/// ```
///
/// - Parameters:
///   - lhs: Mutable input vector.
///   - rhs: Vector to add to the mutable vector.
public func += (lhs: inout Vector<Int32>, rhs: Vector<Int32>) {
    precondition(lhs.length == rhs.length, "Vectors must be same length")
    lhs = lhs + rhs
}

/// In-place element-wise addition of two vectors with single precision.
/// - Parameters:
///   - lhs: Mutable input vector.
///   - rhs: Vector to add to the mutable vector.
public func += (lhs: inout Vector<Float>, rhs: Vector<Float>) {
    precondition(lhs.length == rhs.length, "Vectors must be same length")
    lhs = lhs + rhs
}

/// In-place element-wise addition of two vectors with double precision.
/// - Parameters:
///   - lhs: Mutable input vector.
///   - rhs: Vector to add to the mutable vector.
public func += (lhs: inout Vector<Double>, rhs: Vector<Double>) {
    precondition(lhs.length == rhs.length, "Vectors must be same length")
    lhs = lhs + rhs
}

// MARK: Scalar-Matrix addition

/// Element-wise addition of a scalar and a matrix with single precision.
/// - Parameters:
///   - lhs: The input scalar value.
///   - rhs: The input matrix.
/// - Returns: The sum of scalar + B[i].
public func + (lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
    var mat = Matrix<Float>(rows: rhs.rows, columns: rhs.columns)
    vDSP.add(lhs, rhs.buffer, result: &mat.buffer)
    return mat
}

/// Element-wise addition of a scalar and a matrix with double precision.
/// - Parameters:
///   - lhs: The input scalar value.
///   - rhs: The input matrix.
/// - Returns: The sum of scalar + B[i].
public func + (lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
    var mat = Matrix<Double>(rows: rhs.rows, columns: rhs.columns)
    vDSP.add(lhs, rhs.buffer, result: &mat.buffer)
    return mat
}

// MARK: Matrix-Scalar addition

/// Element-wise addition of a matrix and a scalar with single precision.
/// - Parameters:
///   - lhs:The input matrix
///   - rhs: The input scalar value.
/// - Returns: The sum of A[i] + scalar.
public func + (lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
    var mat = Matrix<Float>(rows: lhs.rows, columns: lhs.columns)
    vDSP.add(rhs, lhs.buffer, result: &mat.buffer)
    return mat
}

/// Element-wise addition of a matrix and a scalar with double precision.
/// - Parameters:
///   - lhs: The input matrix.
///   - rhs: The input scalar value.
/// - Returns: The sum of A[i] + scalar.
public func + (lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
    var mat = Matrix<Double>(rows: lhs.rows, columns: lhs.columns)
    vDSP.add(rhs, lhs.buffer, result: &mat.buffer)
    return mat
}

/// In-place element-wise addition of a matrix and scalar value with single precision.
/// - Parameters:
///   - lhs: Mutable input matrix.
///   - rhs: The scalar value.
public func += (lhs: inout Matrix<Float>, rhs: Float) {
    lhs = lhs + rhs
}

/// In-place element-wise addition of a matrix and scalar value with double precision.
/// - Parameters:
///   - lhs: Mutable input matrix.
///   - rhs: The scalar value.
public func += (lhs: inout Matrix<Double>, rhs: Double) {
    lhs = lhs + rhs
}

// MARK: Matrix-Matrix addition

/// Element-wise addition of two matrices with single precision.
/// - Parameters:
///   - lhs: The input matrix A.
///   - rhs: The input matrix B.
/// - Returns: The result matrix of A + B.
public func + (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must be same shape")
    var mat = Matrix<Float>(rows: lhs.rows, columns: lhs.columns)
    vDSP.add(lhs.buffer, rhs.buffer, result: &mat.buffer)
    return mat
}

/// Element-wise addition of two matrices with double precision.
/// - Parameters:
///   - lhs: The input matrix A.
///   - rhs: The input matrix B.
/// - Returns: The result matrix of A + B.
public func + (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must be same shape")
    var mat = Matrix<Double>(rows: lhs.rows, columns: lhs.columns)
    vDSP.add(lhs.buffer, rhs.buffer, result: &mat.buffer)
    return mat
}

/// In-place element-wise addition of two matrices with single precision.
/// - Parameters:
///   - lhs: The mutable input matrix.
///   - rhs: The second input matrix.
public func += (lhs: inout Matrix<Float>, rhs: Matrix<Float>) {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must be same shape")
    lhs = lhs + rhs
}

/// In-place element-wise addition of two matrices with double precision.
/// - Parameters:
///   - lhs: The mutable input matrix.
///   - rhs: The second input matrix.
public func += (lhs: inout Matrix<Double>, rhs: Matrix<Double>) {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must be same shape")
    lhs = lhs + rhs
}

// MARK: Scalar-ShapedArray addition

/// Element-wise addition of a scalar value and a shaped array with single precision.
/// - Parameters:
///   - lhs: The scalar value `k`
///   - rhs: The shaped array `A`.
/// - Returns: Shaped array that is the result of `k + A`.
public func + (lhs: Float, rhs: ShapedArray<Float>) -> ShapedArray<Float> {
    var result = ShapedArray<Float>(shape: rhs.shape)
    vDSP.add(lhs, rhs.buffer, result: &result.buffer)
    return result
}

/// Element-wise addition of a scalar value and a shaped array with double precision.
/// - Parameters:
///   - lhs: The scalar value `k`
///   - rhs: The shaped array `A`.
/// - Returns: Shaped array that is the result of `k + A`.
public func + (lhs: Double, rhs: ShapedArray<Double>) -> ShapedArray<Double> {
    var result = ShapedArray<Double>(shape: rhs.shape)
    vDSP.add(lhs, rhs.buffer, result: &result.buffer)
    return result
}

// MARK: ShapedArray-Scalar addition

/// Element-wise addition of a shaped array and a scalar value with single precision.
/// - Parameters:
///   - lhs: The shaped array `A`.
///   - rhs: The scalar value `k`.
/// - Returns: Shaped array that is the result of `A + k`.
public func + (lhs: ShapedArray<Float>, rhs: Float) -> ShapedArray<Float> {
    var result = ShapedArray<Float>(shape: lhs.shape)
    vDSP.add(rhs, lhs.buffer, result: &result.buffer)
    return result
}

/// Element-wise addition of a shaped array and a scalar value with double precision.
/// - Parameters:
///   - lhs: The shaped array `A`.
///   - rhs: The scalar value `k`.
/// - Returns: Shaped array that is the result of `A + k`.
public func + (lhs: ShapedArray<Double>, rhs: Double) -> ShapedArray<Double> {
    var result = ShapedArray<Double>(shape: lhs.shape)
    vDSP.add(rhs, lhs.buffer, result: &result.buffer)
    return result
}

/// In-place element-wise addition of a shaped array and a scalar value with single precision.
/// - Parameters:
///   - lhs: The shaped array `A`.
///   - rhs: The scalar value `k`.
public func += (lhs: inout ShapedArray<Float>, rhs: Float) {
    lhs = lhs + rhs
}

/// In-place element-wise addition of a shaped array and a scalar value with single precision.
/// - Parameters:
///   - lhs: The shaped array `A`.
///   - rhs: The scalar value `k`.
public func += (lhs: inout ShapedArray<Double>, rhs: Double) {
    lhs = lhs + rhs
}

// MARK: ShapedArray-ShapedArray addition

/// Element-wise addition of two shaped arrays with single precision.
/// - Parameters:
///   - lhs: The shaped array `A`.
///   - rhs: The shaped array `B`.
/// - Returns: Shaped array that is the result of `A + B`.
public func + (lhs: ShapedArray<Float>, rhs: ShapedArray<Float>) -> ShapedArray<Float> {
    var result = ShapedArray<Float>(shape: lhs.shape)
    vDSP.add(lhs.buffer, rhs.buffer, result: &result.buffer)
    return result
}

/// Element-wise addition of two shaped arrays with double precision.
/// - Parameters:
///   - lhs: The shaped array `A`.
///   - rhs: The shaped array `B`.
/// - Returns: Shaped array that is the result of `A + B`.
public func + (lhs: ShapedArray<Double>, rhs: ShapedArray<Double>) -> ShapedArray<Double> {
    var result = ShapedArray<Double>(shape: lhs.shape)
    vDSP.add(lhs.buffer, rhs.buffer, result: &result.buffer)
    return result
}

/// In-place element-wise addition of two shaped arrays with single precision.
/// - Parameters:
///   - lhs: The shaped array `A`.
///   - rhs: The shaped array `B`.
public func += (lhs: inout ShapedArray<Float>, rhs: ShapedArray<Float>) {
    lhs = lhs + rhs
}

/// In-place element-wise addition of two shaped arrays with double precision.
/// - Parameters:
///   - lhs: The shaped array `A`.
///   - rhs: The shaped array `B`.
public func += (lhs: inout ShapedArray<Double>, rhs: ShapedArray<Double>) {
    lhs = lhs + rhs
}
