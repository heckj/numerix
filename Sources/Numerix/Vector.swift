//
//  File.swift
//  
//
//  Created by Gavin Wiggins on 3/26/24.
//

import Accelerate

public struct Vector<T: FloatingPoint> {

    public var values: [T]

    public init(_ values: [T]) {
        self.values = values
    }

    public init(size: Int, fill: T = 0.0) {
        self.values = [T](repeating: fill, count: size)
    }

    public subscript(item: Int) -> T {
        get { return values[item] }
        set { values[item] = newValue }
    }
}

extension Vector: CustomStringConvertible {

    public var description: String {
        var des = [String]()
        for value in self.values {
            if let val = value as? Double {
                des.append(val.formatted(.number.precision(.fractionLength(2))))
            } else if let val = value as? Float {
                des.append(val.formatted(.number.precision(.fractionLength(1))))
            } else {
                des.append("\(value)")
            }
        }
        return "<\(des.joined(separator: " "))>"
    }
}

extension Vector where T == Double {

    public static func + (left: Vector, right: Vector) -> Vector {
        precondition(left.values.count == right.values.count, "Vectors must be same length")
        let vec = vDSP.add(left.values, right.values)
        return Vector(vec)
    }
}
