/*
 Norm functions for Vector and Matrix structures. Single and double precision
 values are supported.
 */

import Accelerate

// MARK: Vector norm

/// Calculate the L² norm, also known as Euclidean norm, of a vector with single precision.
/// - Parameter vec: The input vector.
/// - Returns: The norm of the input vector.
public func norm(_ vec: Vector<Float>) -> Float {
    let nrm = cblas_snrm2(vec.length, vec.buffer.baseAddress, 1)
    return nrm
}

/// Calculate the L² norm, also known as Euclidean norm, of a vector with double precision.
/// - Parameter vec: The input vector.
/// - Returns: The norm of the input vector.
public func norm(_ vec: Vector<Double>) -> Double {
    let nrm = cblas_dnrm2(vec.length, vec.buffer.baseAddress, 1)
    return nrm
}

// MARK: Matrix norm

/// Calculate the L² norm, also known as Euclidean norm, of a matrix with single precision.
/// - Parameter mat: The input matrix.
/// - Returns: The norm of the input matrix.
public func norm(_ mat: Matrix<Float>) -> Float {
    let nrm = cblas_snrm2(mat.buffer.count, mat.buffer.baseAddress, 1)
    return nrm
}

/// Calculate the L² norm, also known as Euclidean norm, of a matrix with double precision.
/// - Parameter mat: The input matrix.
/// - Returns: The norm of the input matrix.
public func norm(_ mat: Matrix<Double>) -> Double {
    let nrm = cblas_dnrm2(mat.buffer.count, mat.buffer.baseAddress, 1)
    return nrm
}

// MARK: ShapedArray norm

/// Calculate the L² norm, also known as Euclidean norm, of a shaped array with single precision.
/// - Parameter arr: The shaped array input.
/// - Returns: The norm of the shaped array.
public func norm(_ arr: ShapedArray<Float>) -> Float {
    let nrm = cblas_snrm2(arr.buffer.count, arr.buffer.baseAddress, 1)
    return nrm
}

/// Calculate the L² norm, also known as Euclidean norm, of a shaped array with double precision.
/// - Parameter arr: The shaped array input.
/// - Returns: The norm of the shaped array.
public func norm(_ arr: ShapedArray<Double>) -> Double {
    let nrm = cblas_dnrm2(arr.buffer.count, arr.buffer.baseAddress, 1)
    return nrm
}
