import Affine
#if Tagged
import Tagged
#endif
#if Vector
import Vector
#endif
import Testing

private enum Screen {}
private enum World {}

@Suite struct `Affine composition preserves independently owned representations` {
    #if Tagged
    @Test func `Affine relationships compose independently owned point and displacement types`() {
        struct Reading: Equatable { let time: Swift.Duration }
        let affine = Affine<Reading, Swift.Duration, Never>(
            translating: { Reading(time: $0.time + $1) },
            displacement: { $1.time - $0.time }
        )
        let start = Reading(time: .seconds(10))
        let end = affine.translated(start, by: .seconds(3))
        #expect(end.time == .seconds(13))
        #expect(affine.displacement(from: start, to: end) == .seconds(3))
        let tagged = affine.tagged(Screen.self)
        let p = Tagged<Screen, Reading>(_unchecked: start)
        let q = tagged.translated(p, by: .seconds(3))
        let duration: Swift.Duration = tagged.displacement(from: p, to: q)
        #expect(duration == .seconds(3))
    }

    #endif

    #if Vector
    @Test func `Positions and displacements can use different scalar representations`() throws {
        enum Failure: Error { case overflow }
        let affine = Affine<Vector<3, Int64>, Vector<3, Int128>, Failure>.componentwise(
            coordinates: { $0 }, point: { $0 },
            components: { $0 }, displacement: { $0 },
            translating: { (position, delta) throws(Failure) in
                let sum = Int128(position).addingReportingOverflow(delta)
                guard !sum.overflow, let result = Int64(exactly: sum.partialValue) else {
                    throw .overflow
                }
                return result
            },
            subtracting: { Int128($1) - Int128($0) }
        )
        let first = Vector<3, Int64>(repeating: .min)
        let last = Vector<3, Int64>(repeating: .max)
        let delta = try affine.displacement(from: first, to: last)
        #expect(delta == Vector(repeating: Int128(UInt64.max)))
        #expect(try affine.translated(first, by: delta) == last)
        #expect(throws: Failure.self) {
            try affine.translated(last, by: Vector(repeating: 1))
        }
    }
    #endif
}
