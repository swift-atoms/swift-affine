import Affine
import Testing

@Suite struct `Points obey affine laws` {
    enum Frame {}

    @Test func `Displacement reconstructs the other point`() {
        let origin = Affine.Point<Frame, Double>(coordinates: 2.5)
        let destination = Affine.Point<Frame, Double>(coordinates: 9.5)
        let displacement = origin.displacement(to: destination)
        #expect(displacement.underlying == 7)
        #expect(origin.translated(by: displacement) == destination)
    }

    @Test func `Changing the origin preserves displacement`() {
        let a = Affine.Point<Frame, Int>(coordinates: 2)
        let b = Affine.Point<Frame, Int>(coordinates: 8)
        let shift = Affine.Point<Frame, Int>.Offset(_unchecked: 13)
        #expect(a.translated(by: shift).displacement(to: b.translated(by: shift)) == a.displacement(to: b))
        #expect(a.translated(by: .init(_unchecked: 0)) == a)
    }
}
