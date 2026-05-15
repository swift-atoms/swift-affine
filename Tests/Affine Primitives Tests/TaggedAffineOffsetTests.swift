import Affine_Primitives_Test_Support
import Testing

@testable import Affine_Primitives

@Suite
struct TaggedAffineOffsetTests {
    // Phantom-tag types.
    enum Element {}
    enum Other {}

    typealias Position = Tagged<Element, Ordinal>
    typealias Offset = Tagged<Element, Ordinal>.Offset
    typealias Count = Tagged<Element, Cardinal>

    // MARK: - Offset Typealias Identity

    @Test
    func `offset is tagged vector`() {
        let offset: Offset = 3
        // The typealias resolves to Tagged<Element, Affine.Discrete.Vector>.
        let taggedVector: Tagged<Element, Affine.Discrete.Vector> = offset
        #expect(taggedVector.underlying == Affine.Discrete.Vector(3))
    }

    // MARK: - Construction

    @Test
    func `construction from int`() {
        let offset = Offset(5)
        #expect(offset.underlying == Affine.Discrete.Vector(5))
    }

    @Test
    func `construction from negative int`() {
        let offset = Offset(-3)
        #expect(offset.underlying == Affine.Discrete.Vector(-3))
    }

    @Test
    func `construction from tagged cardinal`() {
        let count: Tagged<Element, Cardinal> = 7
        let offset = Tagged<Element, Affine.Discrete.Vector>(count)
        #expect(offset.underlying == Affine.Discrete.Vector(7))
    }

    @Test
    func `construction from ordinal protocol`() throws(Affine.Discrete.Vector.Error) {
        let position = Ordinal(UInt(5))
        let offset = try Tagged<Element, Affine.Discrete.Vector>(position)
        #expect(offset.underlying == Affine.Discrete.Vector(5))
    }

    @Test
    func `construction from zero`() {
        let position = Ordinal(UInt(5))
        let offset = Tagged<Element, Affine.Discrete.Vector>(fromZero: position)
        #expect(offset.underlying == Affine.Discrete.Vector(5))
    }

    @Test
    func `construction from integer literal`() {
        let offset: Offset = 3
        #expect(offset.underlying == Affine.Discrete.Vector(3))
    }

    // MARK: - Constants

    @Test
    func `zero constant`() {
        let offset: Offset = .zero
        #expect(offset.underlying == Affine.Discrete.Vector(0))
    }

    @Test
    func `one constant`() {
        let offset: Offset = .one
        #expect(offset.underlying == Affine.Discrete.Vector(1))
    }

    // MARK: - Arithmetic

    @Test
    func `addition on tagged`() {
        let a: Offset = 3
        let b: Offset = 4
        let sum = a + b
        #expect(sum.underlying == Affine.Discrete.Vector(7))
    }

    @Test
    func `subtraction on tagged`() {
        let a: Offset = 5
        let b: Offset = 2
        let diff = a - b
        #expect(diff.underlying == Affine.Discrete.Vector(3))
    }

    @Test
    func `compound addition on tagged`() {
        var a: Offset = 5
        a += Offset(3)
        #expect(a.underlying == Affine.Discrete.Vector(8))
    }

    @Test
    func `compound subtraction on tagged`() {
        var a: Offset = 5
        a -= Offset(3)
        #expect(a.underlying == Affine.Discrete.Vector(2))
    }

    @Test
    func `unary minus on tagged`() {
        let v: Offset = 5
        let negated: Offset = -v
        #expect(negated.underlying == Affine.Discrete.Vector(-5))
    }

    // MARK: - Typed Magnitude

    @Test
    func `magnitude of positive tagged offset`() {
        let offset: Offset = 5
        let magnitude: Tagged<Element, Cardinal> = offset.magnitude
        #expect(magnitude.underlying == Cardinal(5))
    }

    @Test
    func `magnitude of negative tagged offset`() {
        let offset: Offset = -5
        let magnitude: Tagged<Element, Cardinal> = offset.magnitude
        #expect(magnitude.underlying == Cardinal(5))
    }

    // MARK: - Tagged<Tag, Cardinal> from Tagged<Tag, Vector>

    @Test
    func `tagged cardinal from non negative tagged vector`() throws(Cardinal.Error) {
        let offset: Offset = 5
        let count: Tagged<Element, Cardinal> = try Tagged<Element, Cardinal>(offset)
        #expect(count.underlying == Cardinal(5))
    }

    @Test
    func `tagged cardinal from negative tagged vector throws`() {
        let offset: Offset = -5
        #expect(throws: Cardinal.Error.negativeSource(-5)) {
            try Tagged<Element, Cardinal>(offset)
        }
    }

    // MARK: - Cross-Type Comparisons (Vector ↔ Cardinal, same Domain)

    @Test
    func `vector less than cardinal same domain`() {
        let offset: Offset = 3
        let count: Tagged<Element, Cardinal> = 5
        #expect(offset < count)
    }

    @Test
    func `cardinal less than vector same domain`() {
        let count: Tagged<Element, Cardinal> = 3
        let offset: Offset = 5
        #expect(count < offset)
    }

    @Test
    func `vector equal to cardinal at zero`() {
        let offset: Offset = .zero
        let count: Tagged<Element, Cardinal> = .zero
        #expect(offset <= count)
        #expect(offset >= count)
    }

    @Test
    func `negative vector less than any cardinal`() {
        let offset: Offset = -1
        let count: Tagged<Element, Cardinal> = .zero
        #expect(offset < count)
    }
}
