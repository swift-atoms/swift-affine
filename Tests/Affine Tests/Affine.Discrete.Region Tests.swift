import Cardinal
import Cardinal_Standard_Library_Integration
import Ordinal
import Testing

@testable import Affine

extension Affine.Discrete.Region {
    @Suite
    struct Test {
        @Suite struct Unit {}
    }
}

extension Affine.Discrete.Region.Test.Unit {
    @Test
    func `extent is half-open start ..< start + count`() {
        let region = Affine.Discrete.Region(start: Ordinal(UInt(3)), count: Cardinal(4))
        #expect(region.start == Ordinal(UInt(3)))
        #expect(region.count == Cardinal(4))
        #expect(region.end == Ordinal(UInt(7)))
    }

    @Test
    func `contains the half-open run`() {
        let region = Affine.Discrete.Region(start: Ordinal(UInt(3)), count: Cardinal(4))
        #expect(region.contains(Ordinal(UInt(3))))
        #expect(region.contains(Ordinal(UInt(6))))
        #expect(!region.contains(Ordinal(UInt(7))))
        #expect(!region.contains(Ordinal(UInt(2))))
    }

    @Test
    func `empty region contains nothing`() {
        let region = Affine.Discrete.Region(start: Ordinal(UInt(5)), count: Cardinal(0))
        #expect(region.end == Ordinal(UInt(5)))
        #expect(!region.contains(Ordinal(UInt(5))))
    }

    @Test
    func `translated shifts start and keeps count`() {
        let region = Affine.Discrete.Region(start: Ordinal(UInt(3)), count: Cardinal(4))
        #expect(region.translated(by: 2).start == Ordinal(UInt(5)))
        #expect(region.translated(by: 2).count == Cardinal(4))
        #expect(region.translated(by: -1).start == Ordinal(UInt(2)))
        #expect(region.translated(by: -10).start == Ordinal(UInt(0)))
    }

    @Test
    func `Equatable and Hashable`() {
        let a = Affine.Discrete.Region(start: Ordinal(UInt(1)), count: Cardinal(2))
        let b = Affine.Discrete.Region(start: Ordinal(UInt(1)), count: Cardinal(2))
        let c = Affine.Discrete.Region(start: Ordinal(UInt(1)), count: Cardinal(3))
        #expect(a == b)
        #expect(a != c)
        let set: Set<Affine.Discrete.Region> = [a, b, c]
        #expect(set.count == 2)
    }
}
