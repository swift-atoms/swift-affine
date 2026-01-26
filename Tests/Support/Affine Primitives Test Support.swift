//
//  File.swift
//  swift-affine-primitives
//
//  Created by Coen ten Thije Boonkkamp on 26/01/2026.
//

import Affine_Primitives

// MARK: - ExpressibleByIntegerLiteral

extension Affine.Discrete.Count: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Int) {
        precondition(value >= 0, "Count literal cannot be negative")
        self = try! .init(value)
    }
}

extension Affine.Discrete.Displacement: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Int) {
        self = .init(value)
    }
}
