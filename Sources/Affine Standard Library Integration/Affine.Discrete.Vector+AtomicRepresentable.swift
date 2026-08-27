public import Affine

#if SYNCHRONIZATION_AVAILABLE
    public import Synchronization

    extension Affine.Discrete.Vector: AtomicRepresentable {

        public typealias AtomicRepresentation = Int.AtomicRepresentation

        @inlinable
        public static func encodeAtomicRepresentation(
            _ value: consuming Affine.Discrete.Vector
        ) -> AtomicRepresentation {
            Int.encodeAtomicRepresentation(value.rawValue)
        }

        @inlinable
        public static func decodeAtomicRepresentation(
            _ representation: consuming AtomicRepresentation
        ) -> Affine.Discrete.Vector {
            Affine.Discrete.Vector(Int.decodeAtomicRepresentation(representation))
        }
    }
#endif
