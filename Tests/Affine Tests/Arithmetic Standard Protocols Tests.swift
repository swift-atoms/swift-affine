import Difference
import Interval
import Cardinal
import Ordinal
import Testing

#if SYNCHRONIZATION_AVAILABLE
    import Synchronization
#endif

@Test
func `discrete values own their standard conformances`() throws {
    let one: Difference = 1
    let two: Difference = 2
    let region = try Interval.Discrete<Ordinal>(start: Ordinal(1), count: Cardinal(2))

    #expect(one < two)
    #expect(Set([one, one, two]).count == 2)
    #expect(Set([region, region]).count == 1)

    #if SYNCHRONIZATION_AVAILABLE
        func requireAtomic<T: AtomicRepresentable>(_: T.Type) {}
        requireAtomic(Difference.self)
    #endif
}
