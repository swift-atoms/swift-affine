// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Affine_Discrete_Primitives
public import Cardinal_Primitives
public import Tagged_Primitives

extension Affine.Discrete.Ratio where From: ~Copyable, To: ~Copyable {
    /// Creates a ratio from a typed count in the target domain.
    ///
    /// For example, `Ratio<Slot, Memory>(alignedSize)` where
    /// `alignedSize: Memory.Address.Count` creates a ratio meaning
    /// "each Slot maps to `alignedSize` bytes."
    @inlinable
    public init(_ count: Tagged<To, Cardinal>) {
        self.init(Int(bitPattern: count))
    }
}
