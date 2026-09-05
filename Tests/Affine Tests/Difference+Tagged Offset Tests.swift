import Affine_Test_Support
import Testing

@testable import Affine
internal import Cardinal

private enum Element {}
private enum Other {}

private func positiveDifference(_ count: Tagged<Element, Cardinal>) -> Tagged<Element, Difference> {
    count.map { Difference.positive(Difference.Magnitude($0)) }
}

extension Difference {
    @Suite
    struct `Tagged Offset` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

extension Difference.`Tagged Offset`.Unit {

    @Test
    func `offset is tagged vector`() {
        let offset: Tagged<Element, Ordinal>.Offset = 3

        let taggedVector: Tagged<Element, Difference> = offset
        #expect(taggedVector.underlying == Difference(3))
    }

    @Test
    func `construction from int`() {
        let offset = Tagged<Element, Ordinal>.Offset(5)
        #expect(offset.underlying == Difference(5))
    }

    @Test
    func `construction from negative int`() {
        let offset = Tagged<Element, Ordinal>.Offset(-3)
        #expect(offset.underlying == Difference(-3))
    }

    @Test
    func `construction from tagged cardinal`() {
        let count: Tagged<Element, Cardinal> = 7
        let offset = positiveDifference(count)
        #expect(offset.underlying == Difference(7))
    }

    @Test
    func `construction from ordinal protocol`() throws(Difference.Error) {
        let position = Tagged<Element, Ordinal>(Ordinal(UInt(5)))
        let offset = Tagged<Element, Difference>(position)
        #expect(offset.underlying == Difference(5))
    }

    @Test
    func `construction from zero`() {
        let position = Tagged<Element, Ordinal>(Ordinal(UInt(5)))
        let offset = Tagged<Element, Difference>(fromZero: position)
        #expect(offset.underlying == Difference(5))
    }

    @Test
    func `construction from integer literal`() {
        let offset: Tagged<Element, Ordinal>.Offset = 3
        #expect(offset.underlying == Difference(3))
    }

    @Test
    func `zero constant`() {
        let offset: Tagged<Element, Ordinal>.Offset = .zero
        #expect(offset.underlying == Difference(0))
    }

    @Test
    func `one constant`() {
        let offset: Tagged<Element, Ordinal>.Offset = .one
        #expect(offset.underlying == Difference(1))
    }

    @Test
    func `addition on tagged`() {
        let a: Tagged<Element, Ordinal>.Offset = 3
        let b: Tagged<Element, Ordinal>.Offset = 4
        let sum = a + b
        #expect(sum.underlying == Difference(7))
    }

    @Test
    func `subtraction on tagged`() {
        let a: Tagged<Element, Ordinal>.Offset = 5
        let b: Tagged<Element, Ordinal>.Offset = 2
        let diff = a - b
        #expect(diff.underlying == Difference(3))
    }

    @Test
    func `compound addition on tagged`() {
        var a: Tagged<Element, Ordinal>.Offset = 5
        a += Tagged<Element, Ordinal>.Offset(3)
        #expect(a.underlying == Difference(8))
    }

    @Test
    func `compound subtraction on tagged`() {
        var a: Tagged<Element, Ordinal>.Offset = 5
        a -= Tagged<Element, Ordinal>.Offset(3)
        #expect(a.underlying == Difference(2))
    }

    @Test
    func `unary minus on tagged`() {
        let v: Tagged<Element, Ordinal>.Offset = 5
        let negated: Tagged<Element, Ordinal>.Offset = -v
        #expect(negated.underlying == Difference(-5))
    }

    @Test
    func `magnitude of positive tagged offset`() {
        let offset: Tagged<Element, Ordinal>.Offset = 5
        let magnitude: Tagged<Element, Difference.Magnitude> = offset.magnitude
        #expect(magnitude.underlying == Difference.Magnitude(Cardinal(5)))
    }

    @Test
    func `magnitude of negative tagged offset`() {
        let offset: Tagged<Element, Ordinal>.Offset = -5
        let magnitude: Tagged<Element, Difference.Magnitude> = offset.magnitude
        #expect(magnitude.underlying == Difference.Magnitude(Cardinal(5)))
    }

    @Test
    func `positive tagged offset has a cardinal magnitude`() {
        let offset: Tagged<Element, Ordinal>.Offset = 5
        let count: Tagged<Element, Cardinal> = offset.map { $0.magnitude.value }
        #expect(offset.underlying.polarity == .positive)
        #expect(count.underlying == Cardinal(5))
    }

    @Test
    func `vector less than cardinal same domain`() {
        let offset: Tagged<Element, Ordinal>.Offset = 3
        let count: Tagged<Element, Cardinal> = 5
        #expect(offset < positiveDifference(count))
    }

    @Test
    func `cardinal less than vector same domain`() {
        let count: Tagged<Element, Cardinal> = 3
        let offset: Tagged<Element, Ordinal>.Offset = 5
        #expect(positiveDifference(count) < offset)
    }

    @Test
    func `vector equal to cardinal at zero`() {
        let offset: Tagged<Element, Ordinal>.Offset = .zero
        let count: Tagged<Element, Cardinal> = .zero
        #expect(offset <= positiveDifference(count))
        #expect(offset >= positiveDifference(count))
    }

    @Test
    func `negative vector less than any cardinal`() {
        let offset: Tagged<Element, Ordinal>.Offset = -1
        let count: Tagged<Element, Cardinal> = .zero
        #expect(offset < positiveDifference(count))
    }
}

extension Difference.`Tagged Offset`.`Edge Case` {

    @Test
    func `negative tagged offset cannot become an unsigned position`() {
        let offset: Tagged<Element, Ordinal>.Offset = -5
        #expect(throws: Ordinal.Error.underflow) {
            try Ordinal(offset.underlying)
        }
    }

    @Test
    func `vector at int max compares below cardinal at uint max`() {
        let offset = Tagged<Element, Ordinal>.Offset(Int.max)
        let count = Tagged<Element, Cardinal>(_unchecked: .max)
        #expect(offset < positiveDifference(count))
        #expect(offset <= positiveDifference(count))
        #expect(!(offset > positiveDifference(count)))
        #expect(!(offset >= positiveDifference(count)))
    }

    @Test
    func `vector at int min compares below cardinal at uint max`() {
        let offset = Tagged<Element, Ordinal>.Offset(Int.min)
        let count = Tagged<Element, Cardinal>(_unchecked: .max)
        #expect(offset < positiveDifference(count))
        #expect(offset <= positiveDifference(count))
        #expect(!(offset > positiveDifference(count)))
        #expect(!(offset >= positiveDifference(count)))
    }

    @Test
    func `cardinal at uint max compares above vector at int max`() {
        let count = Tagged<Element, Cardinal>(_unchecked: .max)
        let offset = Tagged<Element, Ordinal>.Offset(Int.max)
        #expect(positiveDifference(count) > offset)
        #expect(positiveDifference(count) >= offset)
        #expect(!(positiveDifference(count) < offset))
        #expect(!(positiveDifference(count) <= offset))
    }

    @Test
    func `cardinal at uint max compares above vector at int min`() {
        let count = Tagged<Element, Cardinal>(_unchecked: .max)
        let offset = Tagged<Element, Ordinal>.Offset(Int.min)
        #expect(positiveDifference(count) > offset)
        #expect(positiveDifference(count) >= offset)
        #expect(!(positiveDifference(count) < offset))
        #expect(!(positiveDifference(count) <= offset))
    }
}
