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
    struct `Tagged offsets preserve their domains through signed arithmetic` {
        @Suite struct `Tagged offsets retain signed values magnitudes and comparisons` {}
        @Suite struct `Tagged displacement comparisons preserve the full signed and unsigned ranges` {}
        @Suite struct `No tagged displacement integration cases are defined` {}
        @Suite(.serialized) struct `No tagged displacement performance cases are defined` {}
    }
}

extension Difference.`Tagged offsets preserve their domains through signed arithmetic`.`Tagged offsets retain signed values magnitudes and comparisons` {

    @Test
    func `offset is tagged vector`() {
        let offset: Tagged<Element, Ordinal>.Offset = 3

        let taggedVector: Tagged<Element, Difference> = offset
        #expect(taggedVector.underlying == Difference(3))
    }

    @Test
    func `Tagged offset construction preserves a positive integer`() {
        let offset = Tagged<Element, Ordinal>.Offset(5)
        #expect(offset.underlying == Difference(5))
    }

    @Test
    func `Tagged offset construction preserves a negative integer`() {
        let offset = Tagged<Element, Ordinal>.Offset(-3)
        #expect(offset.underlying == Difference(-3))
    }

    @Test
    func `Positive tagged counts construct offsets in the same domain`() {
        let count: Tagged<Element, Cardinal> = 7
        let offset = positiveDifference(count)
        #expect(offset.underlying == Difference(7))
    }

    @Test
    func `Tagged ordinal conversion preserves its position as a difference`() throws(Difference.Error) {
        let position = Tagged<Element, Ordinal>(Ordinal(UInt(5)))
        let offset = Tagged<Element, Difference>(position)
        #expect(offset.underlying == Difference(5))
    }

    @Test
    func `Differences measured from zero retain the tagged ordinal position`() {
        let position = Tagged<Element, Ordinal>(Ordinal(UInt(5)))
        let offset = Tagged<Element, Difference>(fromZero: position)
        #expect(offset.underlying == Difference(5))
    }

    @Test
    func `Integer literals construct tagged offsets in their declared domain`() {
        let offset: Tagged<Element, Ordinal>.Offset = 3
        #expect(offset.underlying == Difference(3))
    }

    @Test
    func `The tagged zero offset preserves its domain and zero value`() {
        let offset: Tagged<Element, Ordinal>.Offset = .zero
        #expect(offset.underlying == Difference(0))
    }

    @Test
    func `The tagged unit offset preserves its domain and one value`() {
        let offset: Tagged<Element, Ordinal>.Offset = .one
        #expect(offset.underlying == Difference(1))
    }

    @Test
    func `Tagged offset addition preserves the domain and signed sum`() {
        let a: Tagged<Element, Ordinal>.Offset = 3
        let b: Tagged<Element, Ordinal>.Offset = 4
        let sum = a + b
        #expect(sum.underlying == Difference(7))
    }

    @Test
    func `Tagged offset subtraction preserves the domain and signed difference`() {
        let a: Tagged<Element, Ordinal>.Offset = 5
        let b: Tagged<Element, Ordinal>.Offset = 2
        let diff = a - b
        #expect(diff.underlying == Difference(3))
    }

    @Test
    func `Compound tagged offset addition updates the signed value`() {
        var a: Tagged<Element, Ordinal>.Offset = 5
        a += Tagged<Element, Ordinal>.Offset(3)
        #expect(a.underlying == Difference(8))
    }

    @Test
    func `Compound tagged offset subtraction updates the signed value`() {
        var a: Tagged<Element, Ordinal>.Offset = 5
        a -= Tagged<Element, Ordinal>.Offset(3)
        #expect(a.underlying == Difference(2))
    }

    @Test
    func `Tagged offset negation reverses the sign within its domain`() {
        let v: Tagged<Element, Ordinal>.Offset = 5
        let negated: Tagged<Element, Ordinal>.Offset = -v
        #expect(negated.underlying == Difference(-5))
    }

    @Test
    func `Positive tagged offsets expose their domain preserving magnitude`() {
        let offset: Tagged<Element, Ordinal>.Offset = 5
        let magnitude: Tagged<Element, Difference.Magnitude> = offset.magnitude
        #expect(magnitude.underlying == Difference.Magnitude(Cardinal(5)))
    }

    @Test
    func `Negative tagged offsets expose their domain preserving magnitude`() {
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
    func `Tagged offsets compare below larger counts in the same domain`() {
        let offset: Tagged<Element, Ordinal>.Offset = 3
        let count: Tagged<Element, Cardinal> = 5
        #expect(offset < positiveDifference(count))
    }

    @Test
    func `Tagged counts compare below larger offsets in the same domain`() {
        let count: Tagged<Element, Cardinal> = 3
        let offset: Tagged<Element, Ordinal>.Offset = 5
        #expect(positiveDifference(count) < offset)
    }

    @Test
    func `Tagged counts and offsets compare equally at zero`() {
        let offset: Tagged<Element, Ordinal>.Offset = .zero
        let count: Tagged<Element, Cardinal> = .zero
        #expect(offset <= positiveDifference(count))
        #expect(offset >= positiveDifference(count))
    }

    @Test
    func `Negative tagged offsets compare below nonnegative counts`() {
        let offset: Tagged<Element, Ordinal>.Offset = -1
        let count: Tagged<Element, Cardinal> = .zero
        #expect(offset < positiveDifference(count))
    }
}

extension Difference.`Tagged offsets preserve their domains through signed arithmetic`.`Tagged displacement comparisons preserve the full signed and unsigned ranges` {

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
