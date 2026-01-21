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

/// Namespace for affine space primitives.
///
/// This module provides type-safe discrete affine geometry primitives
/// for representing positions and displacements in 1-dimensional space.
///
/// ## Category Theory Perspective
///
/// This module represents the category **Aff** of discrete affine spaces:
/// - Objects: Non-negative integer positions
/// - Morphisms: Integer displacements (translations)
///
/// Key distinction from linear spaces:
/// - Positions have no canonical origin for arithmetic
/// - The difference of two positions is a displacement
/// - A position plus a displacement yields a position
///
/// ## Types
///
/// - `Discrete.Position`: An unbounded non-negative position
/// - `Discrete.Displacement`: A signed offset between positions
/// - `Discrete.Bounded<N>`: A position bounded to `0..<N`
///
/// ## Usage
///
/// ```swift
/// let p = Affine.Discrete.Position(5)!
/// let d = Affine.Discrete.Displacement(3)
/// let q = (p + d)!  // Position(8)
/// let distance = q - p  // Displacement(3)
/// ```
///
/// For continuous affine geometry (points, transforms, translations),
/// see `Affine_Geometry_Primitives`.
public enum Affine {}
