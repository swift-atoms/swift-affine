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
    func offsetIsTaggedVector() {
        let offset: Offset = 3
        // The typealias resolves to Tagged<Element, Affine.Discrete.Vector>.
        let taggedVector: Tagged<Element, Affine.Discrete.Vector> = offset
        #expect(taggedVector.underlying == Affine.Discrete.Vector(3))
    }

    // MARK: - Construction

    @Test
    func constructionFromInt() {
        let offset = Offset(5)
        #expect(offset.underlying == Affine.Discrete.Vector(5))
    }

    @Test
    func constructionFromNegativeInt() {
        let offset = Offset(-3)
        #expect(offset.underlying == Affine.Discrete.Vector(-3))
    }

    @Test
    func constructionFromTaggedCardinal() {
        let count: Tagged<Element, Cardinal> = 7
        let offset = Tagged<Element, Affine.Discrete.Vector>(count)
        #expect(offset.underlying == Affine.Discrete.Vector(7))
    }

    @Test
    func constructionFromOrdinalProtocol() throws(Affine.Discrete.Vector.Error) {
        let position = Ordinal(UInt(5))
        let offset = try Tagged<Element, Affine.Discrete.Vector>(position)
        #expect(offset.underlying == Affine.Discrete.Vector(5))
    }

    @Test
    func constructionFromZero() {
        let position = Ordinal(UInt(5))
        let offset = Tagged<Element, Affine.Discrete.Vector>(fromZero: position)
        #expect(offset.underlying == Affine.Discrete.Vector(5))
    }

    @Test
    func constructionFromIntegerLiteral() {
        let offset: Offset = 3
        #expect(offset.underlying == Affine.Discrete.Vector(3))
    }

    // MARK: - Constants

    @Test
    func zeroConstant() {
        let offset: Offset = .zero
        #expect(offset.underlying == Affine.Discrete.Vector(0))
    }

    @Test
    func oneConstant() {
        let offset: Offset = .one
        #expect(offset.underlying == Affine.Discrete.Vector(1))
    }

    // MARK: - Arithmetic

    @Test
    func additionOnTagged() {
        let a: Offset = 3
        let b: Offset = 4
        let sum = a + b
        #expect(sum.underlying == Affine.Discrete.Vector(7))
    }

    @Test
    func subtractionOnTagged() {
        let a: Offset = 5
        let b: Offset = 2
        let diff = a - b
        #expect(diff.underlying == Affine.Discrete.Vector(3))
    }

    @Test
    func compoundAdditionOnTagged() {
        var a: Offset = 5
        a += Offset(3)
        #expect(a.underlying == Affine.Discrete.Vector(8))
    }

    @Test
    func compoundSubtractionOnTagged() {
        var a: Offset = 5
        a -= Offset(3)
        #expect(a.underlying == Affine.Discrete.Vector(2))
    }

    @Test
    func unaryMinusOnTagged() {
        let v: Offset = 5
        let negated: Offset = -v
        #expect(negated.underlying == Affine.Discrete.Vector(-5))
    }

    // MARK: - Typed Magnitude

    @Test
    func magnitudeOfPositiveTaggedOffset() {
        let offset: Offset = 5
        let magnitude: Tagged<Element, Cardinal> = offset.magnitude
        #expect(magnitude.underlying == Cardinal(5))
    }

    @Test
    func magnitudeOfNegativeTaggedOffset() {
        let offset: Offset = -5
        let magnitude: Tagged<Element, Cardinal> = offset.magnitude
        #expect(magnitude.underlying == Cardinal(5))
    }

    // MARK: - Tagged<Tag, Cardinal> from Tagged<Tag, Vector>

    @Test
    func taggedCardinalFromNonNegativeTaggedVector() throws(Cardinal.Error) {
        let offset: Offset = 5
        let count: Tagged<Element, Cardinal> = try Tagged<Element, Cardinal>(offset)
        #expect(count.underlying == Cardinal(5))
    }

    @Test
    func taggedCardinalFromNegativeTaggedVectorThrows() {
        let offset: Offset = -5
        #expect(throws: Cardinal.Error.negativeSource(-5)) {
            try Tagged<Element, Cardinal>(offset)
        }
    }

    // MARK: - Cross-Type Comparisons (Vector ↔ Cardinal, same Domain)

    @Test
    func vectorLessThanCardinalSameDomain() {
        let offset: Offset = 3
        let count: Tagged<Element, Cardinal> = 5
        #expect(offset < count)
    }

    @Test
    func cardinalLessThanVectorSameDomain() {
        let count: Tagged<Element, Cardinal> = 3
        let offset: Offset = 5
        #expect(count < offset)
    }

    @Test
    func vectorEqualToCardinalAtZero() {
        let offset: Offset = .zero
        let count: Tagged<Element, Cardinal> = .zero
        #expect(offset <= count)
        #expect(offset >= count)
    }

    @Test
    func negativeVectorLessThanAnyCardinal() {
        let offset: Offset = -1
        let count: Tagged<Element, Cardinal> = .zero
        #expect(offset < count)
    }
}
