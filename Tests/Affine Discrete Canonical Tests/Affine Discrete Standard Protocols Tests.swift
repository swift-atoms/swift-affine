import Affine_Discrete
import Cardinal
import Ordinal
import Testing

#if SYNCHRONIZATION_AVAILABLE
    import Synchronization
#endif

@Test
func `discrete values own their standard conformances`() {
    let one: Affine.Discrete.Vector = 1
    let two: Affine.Discrete.Vector = 2
    let region = Affine.Discrete.Region(start: Ordinal(1), count: Cardinal(2))

    #expect(one < two)
    #expect(Set([one, one, two]).count == 2)
    #expect(Set([region, region]).count == 1)

    #if SYNCHRONIZATION_AVAILABLE
        func requireAtomic<T: AtomicRepresentable>(_: T.Type) {}
        requireAtomic(Affine.Discrete.Vector.self)
    #endif
}
