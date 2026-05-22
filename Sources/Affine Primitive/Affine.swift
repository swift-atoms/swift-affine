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
/// for representing displacements between positions, and cross-domain
/// scaling between phantom-tagged quantities.
///
/// ## Affine Semantics
///
/// In affine geometry, *positions* (points) have no canonical origin for
/// arithmetic, while *vectors* (displacements) form a group. Three
/// operations connect them:
///
/// - `position − position → vector` (the displacement between positions)
/// - `position + vector  → position` (translate a position by a displacement)
/// - `position − vector  → position` (translate the other direction)
///
/// In this package, *positions* are carried by `Ordinal` (from
/// `swift-ordinal-primitives`) and *vectors* by ``Discrete/Vector``.
///
/// ## Cohort Framing
///
/// `Affine` is the third package in **Story 1 of the data-structures cohort**:
/// cardinal (count), ordinal (position), affine (offset) — three things stdlib
/// calls `Int`. Where `Cardinal` answers *"how many?"* and `Ordinal` answers
/// *"which position?"*, `Affine.Discrete.Vector` answers *"how far between?"*.
///
/// ## Types
///
/// - ``Discrete/Vector``: A signed `Int`-backed displacement.
/// - ``Discrete/Ratio``: A typed multiplicative morphism between domains
///   (e.g., `Ratio<UInt8, Bit>(8)` scales byte counts to bit counts).
/// - `Tagged<Tag, Ordinal>.Offset` (typealias to `Tagged<Tag, Affine.Discrete.Vector>`):
///   the typed offset paired with a typed ordinal domain.
///
/// ## Usage
///
/// ```swift
/// import Affine_Primitives
///
/// // Bare displacement.
/// let forward: Affine.Discrete.Vector = 5
/// let backward: Affine.Discrete.Vector = -3
/// let combined = forward + backward                      // Vector(2)
///
/// // Same-domain ratio (identity factor).
/// let identity: Affine.Discrete.Ratio<Int, Int> = 1
/// ```
///
/// For typed-offset and cross-domain-ratio examples that pair `Affine.Discrete.Vector`
/// with consumer-defined phantom tags, see ``Discrete/Vector`` and ``Discrete/Ratio``
/// in the DocC catalogue.
public enum Affine {}
