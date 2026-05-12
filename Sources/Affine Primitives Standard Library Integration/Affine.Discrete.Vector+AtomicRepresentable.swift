// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives
// project authors. Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

#if SYNCHRONIZATION_AVAILABLE
    public import Synchronization

    // MARK: - Affine.Discrete.Vector + AtomicRepresentable

    extension Affine.Discrete.Vector: AtomicRepresentable {
        /// The atomic storage representation used to back ``Affine/Discrete/Vector``
        /// in ``Synchronization/Atomic``.
        ///
        /// Mirrors `Int`'s atomic representation since `Vector` is a single-`Int`
        /// value type. `Tagged<Tag, Vector>` inherits this conformance via the
        /// generic Tagged conformance in swift-tagged-primitives.
        public typealias AtomicRepresentation = Int.AtomicRepresentation

        /// Encodes a signed vector displacement into its atomic storage representation.
        @inlinable
        public static func encodeAtomicRepresentation(
            _ value: consuming Affine.Discrete.Vector
        ) -> AtomicRepresentation {
            Int.encodeAtomicRepresentation(value.rawValue)
        }

        /// Decodes an atomic storage representation back into a signed vector displacement.
        @inlinable
        public static func decodeAtomicRepresentation(
            _ representation: consuming AtomicRepresentation
        ) -> Affine.Discrete.Vector {
            Affine.Discrete.Vector(Int.decodeAtomicRepresentation(representation))
        }
    }
#endif
