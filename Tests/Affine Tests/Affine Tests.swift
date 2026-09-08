import Affine
import Testing

@Suite struct `Affine relationships operate on independently owned types` {
    private struct Reading: Equatable { let value: Int }

    private var relationship: Affine<Reading, Int, Never> {
        .init(
            translating: { Reading(value: $0.value + $1) },
            displacement: { $1.value - $0.value }
        )
    }

    @Test func `Translation uses the supplied point and displacement`() {
        let start = Reading(value: 7)
        let end = relationship.translated(start, by: 3)
        #expect(end == Reading(value: 10))
    }

    @Test func `Displacement preserves the direction from start to end`() {
        let start = Reading(value: 7)
        let end = Reading(value: 10)
        #expect(relationship.displacement(from: start, to: end) == 3)
        #expect(relationship.displacement(from: end, to: start) == -3)
    }

    @Test(arguments: [-5, 0, 5])
    func `Zero translation preserves a point and self displacement is zero`(value: Int) {
        let point = Reading(value: value)
        #expect(relationship.translated(point, by: 0) == point)
        #expect(relationship.displacement(from: point, to: point) == 0)
    }

    @Test(arguments: [-5, 0, 5], [-3, 0, 3])
    func `Translation and displacement recover each other`(value: Int, delta: Int) {
        let start = Reading(value: value)
        let end = relationship.translated(start, by: delta)
        #expect(relationship.displacement(from: start, to: end) == delta)
        #expect(relationship.translated(start, by: relationship.displacement(from: start, to: end)) == end)
        #expect(relationship.translated(end, by: -delta) == start)
    }

    @Test(arguments: [-3, 0, 3], [-2, 0, 2])
    func `Successive translations agree with displacement composition`(first: Int, second: Int) {
        let start = Reading(value: 7)
        let middle = relationship.translated(start, by: first)
        let end = relationship.translated(middle, by: second)
        #expect(end == relationship.translated(start, by: first + second))
        #expect(relationship.displacement(from: start, to: end) ==
            relationship.displacement(from: start, to: middle) +
            relationship.displacement(from: middle, to: end))
    }

    @Test func `Native durations need no displacement wrapper`() {
        struct Sample: Equatable { let value: Swift.Duration }
        let relation = Affine<Sample, Swift.Duration, Never>(
            translating: { Sample(value: $0.value + $1) },
            displacement: { $1.value - $0.value }
        )
        let start = Sample(value: .seconds(7))
        let delta = Swift.Duration(attoseconds: 1)
        let end = relation.translated(start, by: delta)
        #expect(relation.displacement(from: start, to: end) == delta)
    }

    @Test func `Closures can capture local state without imposing sendability or numeric protocols`() {
        final class Context { var calls: [String] = [] }
        final class Position {}
        struct Shift { let destination: Position }
        let context = Context()
        let relation = Affine<Position, Shift, Never>(
            translating: { _, shift in
                context.calls.append("translate")
                return shift.destination
            },
            displacement: { _, end in
                context.calls.append("difference")
                return Shift(destination: end)
            }
        )
        let start = Position()
        let end = Position()
        let shift = relation.displacement(from: start, to: end)
        #expect(relation.translated(start, by: shift) === end)
        #expect(context.calls == ["difference", "translate"])
    }
}

@Suite struct `Affine relationships preserve typed failures` {
    private enum Failure: Swift.Error, Equatable {
        case translation(Int)
        case displacement(Int, Int)
    }

    @Test func `Translation propagates its exact failure without invoking displacement`() {
        let relation = Affine<Int, Int, Failure>(
            translating: { (_, delta) throws(Failure) in throw .translation(delta) },
            displacement: { _, _ in
                Issue.record("Translation must not invoke the displacement closure")
                return 0
            }
        )
        do throws(Failure) {
            _ = try relation.translated(7, by: 3)
            Issue.record("Translation should have thrown")
        } catch {
            #expect(error == .translation(3))
        }
    }

    @Test func `Displacement propagates its exact failure without invoking translation`() {
        let relation = Affine<Int, Int, Failure>(
            translating: { _, _ in
                Issue.record("Displacement must not invoke the translation closure")
                return 0
            },
            displacement: { (start, end) throws(Failure) in throw .displacement(start, end) }
        )
        do throws(Failure) {
            _ = try relation.displacement(from: 7, to: 10)
            Issue.record("Displacement should have thrown")
        } catch {
            #expect(error == .displacement(7, 10))
        }
    }

    @Test func `Checked operations retain successful values`() throws {
        let relation = Affine<Int, Int, Failure>(
            translating: { (point, delta) throws(Failure) in
                let result = point.addingReportingOverflow(delta)
                guard !result.overflow else { throw .translation(delta) }
                return result.partialValue
            },
            displacement: { (start, end) throws(Failure) in
                let result = end.subtractingReportingOverflow(start)
                guard !result.overflow else { throw .displacement(start, end) }
                return result.partialValue
            }
        )
        #expect(try relation.translated(7, by: 3) == 10)
        #expect(try relation.displacement(from: 7, to: 10) == 3)
        #expect(throws: Failure.translation(1)) {
            try relation.translated(Int.max, by: 1)
        }
        #expect(throws: Failure.displacement(Int.min, Int.max)) {
            try relation.displacement(from: Int.min, to: Int.max)
        }
    }
}
