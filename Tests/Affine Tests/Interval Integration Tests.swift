import Affine_Test_Support
import Testing

@Suite
struct `Interval Integration Tests` {
    @Test
    func `extent is half-open start ..< start + count`() throws {
        let region = try Interval.Discrete<Ordinal>(start: 3, count: 4)
        #expect(region.start == 3)
        #expect(region.count == 4)
        #expect(region.end == 7)
        #expect(region.range == 3..<7)
    }

    @Test
    func `contains the half-open run`() throws {
        let region = try Interval.Discrete<Ordinal>(start: 3, count: 4)
        #expect(region.contains(3))
        #expect(region.contains(6))
        #expect(!region.contains(7))
        #expect(!region.contains(2))
    }

    @Test
    func `empty region contains nothing`() throws {
        let region = try Interval.Discrete<Ordinal>(start: 5, count: 0)
        #expect(region.end == 5)
        #expect(region.range.isEmpty)
        #expect(!region.contains(5))
    }

    @Test
    func `translated shifts start and keeps count`() throws {
        let region = try Interval.Discrete<Ordinal>(start: 3, count: 4)
        #expect(try region.translated(by: 2).start == 5)
        #expect(try region.translated(by: 2).count == 4)
        #expect(try region.translated(by: -1).start == 2)
        #expect(throws: (any Error).self) { try region.translated(by: -10) }
    }

    @Test
    func `Equatable and Hashable`() throws {
        let a = try Interval.Discrete<Ordinal>(start: 1, count: 2)
        let b = try Interval.Discrete<Ordinal>(start: 1, count: 2)
        let c = try Interval.Discrete<Ordinal>(start: 1, count: 3)
        #expect(a == b)
        #expect(a != c)
        let set: Set<Interval.Discrete<Ordinal>> = [a, b, c]
        #expect(set.count == 2)
    }
}
