/*
 Power functions for Vector and Matrix structures. Single and double precision
 operations are supported.
 */

import Accelerate

// MARK: Vector power

/// Raise each element in a single-precision vector to the power of the exponent.
/// - Parameters:
///   - vec: Vector of bases.
///   - exp: The exponent.
/// - Returns: Vector of bases raised to the power of the exponent.
public func pow(_ vec: Vector<Float>, _ exp: Float) -> Vector<Float> {
    let output = Vector<Float>(length: vec.length)
    withUnsafePointer(to: exp) { expPtr in
        withUnsafePointer(to: Int32(vec.length)) { lengthPtr in
            vvpowsf(output.buffer.baseAddress!, expPtr, vec.buffer.baseAddress!, lengthPtr)
        }
    }
    return output
}

/// Raise each element in a double-precision vector to the power of the exponent.
/// - Parameters:
///   - vec: Vector of bases.
///   - exp: The exponent.
/// - Returns: Vector of bases raised to the power of the exponent.
public func pow(_ vec: Vector<Double>, _ exp: Double) -> Vector<Double> {
    let output = Vector<Double>(length: vec.length)
    withUnsafePointer(to: exp) { expPtr in
        withUnsafePointer(to: Int32(vec.length)) { lengthPtr in
            vvpows(output.buffer.baseAddress!, expPtr, vec.buffer.baseAddress!, lengthPtr)
        }
    }
    return output
}

/// Raise each element in a single-precision vector to the power of each exponent.
/// - Parameters:
///   - vec: Vector of bases.
///   - exp: Array of exponents.
/// - Returns: Vector of bases raised to the power of each exponent.
public func pow(_ vec: Vector<Float>, _ exp: [Float]) -> Vector<Float> {
    precondition(vec.length == exp.count, "Vector length must correspond to number of exponents")
    var result = Vector<Float>(length: vec.length)
    vForce.pow(bases: vec.buffer, exponents: exp, result: &result.buffer)
    return result
}

/// Raise each element in a double-precision vector to the power of each exponent.
/// - Parameters:
///   - vec: Vector of bases.
///   - exp: Array of exponents.
/// - Returns: Vector of bases raised to the power of each exponent.
public func pow(_ vec: Vector<Double>, _ exp: [Double]) -> Vector<Double> {
    precondition(vec.length == exp.count, "Vector length must correspond to number of exponents")
    var result = Vector<Double>(length: vec.length)
    vForce.pow(bases: vec.buffer, exponents: exp, result: &result.buffer)
    return result
}

/// Raise each element in a single-precision vector to the power of the exponent.
/// - Parameters:
///   - lhs: The input vector.
///   - rhs: The exponent.
/// - Returns: Vector raised to the power of the exponent.
public func ^ (lhs: Vector<Float>, rhs: Float) -> Vector<Float> {
    pow(lhs, rhs)
}

/// Raise each element in a double-precision vector to the power of the exponent.
/// - Parameters:
///   - lhs: The input vector.
///   - rhs: The exponent.
/// - Returns: Vector raised to the power of the exponent.
public func ^ (lhs: Vector<Double>, rhs: Double) -> Vector<Double> {
    pow(lhs, rhs)
}

// MARK: Matrix power

/// Raise each element in a single-precision matrix to the power of the exponent.
/// - Parameters:
///   - mat: The input matrix of bases.
///   - exp: The exponent value.
/// - Returns: Matrix of bases raised to the power of the exponent.
public func pow(_ mat: Matrix<Float>, _ exp: Float) -> Matrix<Float> {
    let output = Matrix<Float>(rows: mat.rows, columns: mat.columns)
    withUnsafePointer(to: exp) { expPtr in
        withUnsafePointer(to: Int32(mat.count)) { lengthPtr in
            vvpowsf(output.buffer.baseAddress!, expPtr, mat.buffer.baseAddress!, lengthPtr)
        }
    }
    return output
}

/// Raise each element in a double-precision matrix to the power of the exponent.
/// - Parameters:
///   - mat: The input matrix of bases.
///   - exp: The exponent value.
/// - Returns: Matrix of bases raised to the power of the exponent.
public func pow(_ mat: Matrix<Double>, _ exp: Double) -> Matrix<Double> {
    let output = Matrix<Double>(rows: mat.rows, columns: mat.columns)
    withUnsafePointer(to: exp) { expPtr in
        withUnsafePointer(to: Int32(mat.count)) { lengthPtr in
            vvpows(output.buffer.baseAddress!, expPtr, mat.buffer.baseAddress!, lengthPtr)
        }
    }
    return output
}

/// Raise each element in a single-precision matrix to the power of each exponent.
/// - Parameters:
///   - mat: Matrix of bases.
///   - exp: Array of exponents.
/// - Returns: Matrix of bases raised to the power of each exponent.
public func pow(_ mat: Matrix<Float>, _ exp: [Float]) -> Matrix<Float> {
    precondition(mat.count == exp.count, "Matrix count must correspond to number of exponents")
    var result = Matrix<Float>(rows: mat.rows, columns: mat.columns)
    vForce.pow(bases: mat.buffer, exponents: exp, result: &result.buffer)
    return result
}

/// Raise each element in a double-precision matrix to the power of each exponent.
/// - Parameters:
///   - mat: Matrix of bases.
///   - exp: Array of exponents.
/// - Returns: Matrix of bases raised to the power of each exponent.
public func pow(_ mat: Matrix<Double>, _ exp: [Double]) -> Matrix<Double> {
    precondition(mat.count == exp.count, "Matrix count must correspond to number of exponents")
    var result = Matrix<Double>(rows: mat.rows, columns: mat.columns)
    vForce.pow(bases: mat.buffer, exponents: exp, result: &result.buffer)
    return result
}

/// Raise each element in a single-precision vector to the power of the exponent.
/// - Parameters:
///   - lhs: The input vector.
///   - rhs: The exponent.
/// - Returns: Vector raised to the power of the exponent.
public func ^ (lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
    pow(lhs, rhs)
}

/// Raise each element in a double-precision vector to the power of the exponent.
/// - Parameters:
///   - lhs: The input vector.
///   - rhs: The exponent.
/// - Returns: Vector raised to the power of the exponent.
public func ^ (lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
    pow(lhs, rhs)
}

// MARK: ShapedArray power

/// Raise each element in a single-precision shaped array to the power of the exponent.
/// - Parameters:
///   - array: The input shaped array of bases.
///   - exp: The exponent value.
/// - Returns: Shaped array of bases raised to the power of the exponent.
public func pow(_ array: ShapedArray<Float>, _ exp: Float) -> ShapedArray<Float> {
    let result = ShapedArray<Float>(shape: array.shape)
    withUnsafePointer(to: exp) { expPtr in
        withUnsafePointer(to: Int32(array.buffer.count)) { lengthPtr in
            vvpowsf(result.buffer.baseAddress!, expPtr, array.buffer.baseAddress!, lengthPtr)
        }
    }
    return result
}

/// Raise each element in a double-precision shaped array to the power of the exponent.
/// - Parameters:
///   - array: The input shaped array of bases.
///   - exp: The exponent value.
/// - Returns: Shaped array of bases raised to the power of the exponent.
public func pow(_ array: ShapedArray<Double>, _ exp: Double) -> ShapedArray<Double> {
    let result = ShapedArray<Double>(shape: array.shape)
    withUnsafePointer(to: exp) { expPtr in
        withUnsafePointer(to: Int32(array.buffer.count)) { lengthPtr in
            vvpows(result.buffer.baseAddress!, expPtr, array.buffer.baseAddress!, lengthPtr)
        }
    }
    return result
}

/// Raise each element in a single-precision shaped array to the power of each exponent.
/// - Parameters:
///   - array: The input shaped array of bases.
///   - exp: The array of exponents.
/// - Returns: Shaped array of bases raised to the power of each exponent.
public func pow(_ array: ShapedArray<Float>, _ exp: [Float]) -> ShapedArray<Float> {
    let count = array.shape.reduce(1, *)
    precondition(count == exp.count, "ShapedArray count must correspond to number of exponents")
    var result = ShapedArray<Float>(shape: array.shape)
    vForce.pow(bases: array.buffer, exponents: exp, result: &result.buffer)
    return result
}

/// Raise each element in a double-precision shaped array to the power of each exponent.
/// - Parameters:
///   - array: The input shaped array of bases.
///   - exp: The array of exponents.
/// - Returns: Shaped array of bases raised to the power of each exponent.
public func pow(_ array: ShapedArray<Double>, _ exp: [Double]) -> ShapedArray<Double> {
    let count = array.shape.reduce(1, *)
    precondition(count == exp.count, "ShapedArray count must correspond to number of exponents")
    var result = ShapedArray<Double>(shape: array.shape)
    vForce.pow(bases: array.buffer, exponents: exp, result: &result.buffer)
    return result
}

/// Raise each element in a single-precision shaped array to the power of the exponent.
/// - Parameters:
///   - lhs: The input shaped array on the left-hand side.
///   - rhs: The exponent on the right-hand side.
/// - Returns: Shaped array raised to the power of the exponent.
public func ^ (lhs: ShapedArray<Float>, rhs: Float) -> ShapedArray<Float> {
    pow(lhs, rhs)
}

/// Raise each element in a double-precision shaped array to the power of the exponent.
/// - Parameters:
///   - lhs: The input shaped array on the left-hand side.
///   - rhs: The exponent on the right-hand side.
/// - Returns: Shaped array raised to the power of the exponent.
public func ^ (lhs: ShapedArray<Double>, rhs: Double) -> ShapedArray<Double> {
    pow(lhs, rhs)
}
