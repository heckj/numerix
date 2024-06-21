//
//  File.swift
//  
//
//  Created by Gavin Wiggins on 5/12/24.
//

// swiftlint:disable function_parameter_count line_length

import Accelerate

func cblas_zgemm_wrapper(
    _ m: Int,
    _ n: Int,
    _ k: Int,
    _ alpha: UnsafeRawPointer,
    _ a: UnsafeRawPointer,
    _ lda: Int,
    _ b: UnsafeRawPointer,
    _ ldb: Int,
    _ beta: UnsafeRawPointer,
    _ c: UnsafeMutableRawPointer,
    _ ldc: Int
) {
    cblas_zgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, m, k, .init(alpha), .init(a), lda, .init(b), ldb, .init(beta), .init(c), ldc)
}

// swiftlint:enable function_parameter_count line_length
