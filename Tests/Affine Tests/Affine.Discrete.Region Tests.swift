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
        let region = Affine.Discrete.Region(start: 3, count: 4)
        #expect(region.start == 3)
        #expect(region.count == 4)
        #expect(region.end == 7)
        #expect(region.range == 3..<7)
    }

    @Test
    func `contains the half-open run`() {
        let region = Affine.Discrete.Region(start: 3, count: 4)
        #expect(region.contains(3))
        #expect(region.contains(6))
        #expect(!region.contains(7))
        #expect(!region.contains(2))
    }

    @Test
    func `empty region contains nothing`() {
        let region = Affine.Discrete.Region(start: 5, count: 0)
        #expect(region.end == 5)
        #expect(region.range.isEmpty)
        #expect(!region.contains(5))
    }

    @Test
    func `translated shifts start and keeps count`() {
        let region = Affine.Discrete.Region(start: 3, count: 4)
        #expect(region.translated(by: 2).start == 5)
        #expect(region.translated(by: 2).count == 4)
        #expect(region.translated(by: -1).start == 2)
        #expect(region.translated(by: -10).start == 0)
    }

    @Test
    func `Equatable and Hashable`() {
        let a = Affine.Discrete.Region(start: 1, count: 2)
        let b = Affine.Discrete.Region(start: 1, count: 2)
        let c = Affine.Discrete.Region(start: 1, count: 3)
        #expect(a == b)
        #expect(a != c)
        let set: Set<Affine.Discrete.Region> = [a, b, c]
        #expect(set.count == 2)
    }
}
