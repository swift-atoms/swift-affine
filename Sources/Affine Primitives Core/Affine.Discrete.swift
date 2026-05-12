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

extension Affine {
    /// Namespace for discrete affine space primitives.
    ///
    /// Discrete affine spaces model integer-based positions and displacements,
    /// where positions represent "where" (non-negative indices) and displacements
    /// represent "how far" (signed offsets).
    ///
    /// ## Category Theory Perspective
    ///
    /// This is a 1-dimensional discrete affine space over the integers:
    /// - Points (`Position`): Non-negative integers representing locations
    /// - Vectors (`Displacement`): Signed integers representing directed distances
    ///
    /// ## Types
    ///
    /// - `Position`: An unbounded non-negative position
    /// - `Displacement`: A signed offset between positions
    /// - `Bounded<N>`: A position bounded to the range `0..<N`
    public enum Discrete {}
}
