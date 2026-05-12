import Affine_Primitives_Test_Support
import Testing

@testable import Affine_Primitives

@Suite
struct AffineRatioTests {
    // Phantom-tag types for cross-domain ratio tests.
    enum Byte {}
    enum Bit {}
    enum Word {}

    // MARK: - Construction

    @Test
    func constructionFromInt() {
        let r = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        #expect(r.factor == 8)
    }

    @Test
    func constructionFromTaggedCardinal() {
        let count: Tagged<Bit, Cardinal> = 64
        let r = Affine.Discrete.Ratio<Word, Bit>(count)
        #expect(r.factor == 64)
    }

    // MARK: - Same-Domain (Endomorphism) Operations

    @Test
    func identityFactor() {
        let identity = Affine.Discrete.Ratio<Byte, Byte>.identity
        #expect(identity.factor == 1)
    }

    @Test
    func negateFactor() {
        let negate = Affine.Discrete.Ratio<Byte, Byte>.negate
        #expect(negate.factor == -1)
    }

    @Test
    func sameDomainExpressibleByIntegerLiteral() {
        let r: Affine.Discrete.Ratio<Byte, Byte> = 3
        #expect(r.factor == 3)
    }

    // MARK: - Composition

    @Test
    func ratioComposition() {
        let bitsPerByte = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let bytesPerWord = Affine.Discrete.Ratio<Word, Byte>.init(8)
        let bitsPerWord: Affine.Discrete.Ratio<Word, Bit> = bytesPerWord * bitsPerByte
        #expect(bitsPerWord.factor == 64)
    }

    @Test
    func compositionWithIdentity() {
        let r = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let identity = Affine.Discrete.Ratio<Bit, Bit>.identity
        let composed: Affine.Discrete.Ratio<Byte, Bit> = r * identity
        #expect(composed.factor == 8)
    }

    @Test
    func compositionWithNegate() {
        let r = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let negate = Affine.Discrete.Ratio<Bit, Bit>.negate
        let composed: Affine.Discrete.Ratio<Byte, Bit> = r * negate
        #expect(composed.factor == -8)
    }

    // MARK: - Quotient and Remainder (Tagged Cardinal)

    @Test
    func quotientAndRemainderCardinalEvenDivision() {
        let bitsPerByte = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let count: Tagged<Bit, Cardinal> = 64
        let (quotient, remainder) = bitsPerByte.quotientAndRemainder(dividing: count)
        #expect(quotient.underlying == Cardinal(8))
        #expect(remainder.underlying == .zero)
    }

    @Test
    func quotientAndRemainderCardinalWithRemainder() {
        let bitsPerByte = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let count: Tagged<Bit, Cardinal> = 100
        let (quotient, remainder) = bitsPerByte.quotientAndRemainder(dividing: count)
        #expect(quotient.underlying == Cardinal(12))
        #expect(remainder.underlying == Cardinal(4))
    }

    // MARK: - Quotient and Remainder (Tagged Ordinal)

    @Test
    func quotientAndRemainderOrdinalEvenDivision() {
        let bitsPerByte = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let index: Tagged<Bit, Ordinal> = 64
        let (quotient, remainder) = bitsPerByte.quotientAndRemainder(dividing: index)
        #expect(quotient.underlying == Ordinal(UInt(8)))
        #expect(remainder.underlying == Affine.Discrete.Vector(0))
    }

    @Test
    func quotientAndRemainderOrdinalWithRemainder() {
        let bitsPerByte = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let index: Tagged<Bit, Ordinal> = 100
        let (quotient, remainder) = bitsPerByte.quotientAndRemainder(dividing: index)
        #expect(quotient.underlying == Ordinal(UInt(12)))
        #expect(remainder.underlying == Affine.Discrete.Vector(4))
    }

    // MARK: - Description

    @Test
    func descriptionContainsFactor() {
        let r = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        #expect(r.description.contains("8"))
    }

    // MARK: - Hashable / Sendable conformances

    @Test
    func hashableConformance() {
        let a = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let b = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let c = Affine.Discrete.Ratio<Byte, Bit>.init(16)
        var seen: Set<Affine.Discrete.Ratio<Byte, Bit>> = []
        seen.insert(a)
        #expect(seen.contains(b))
        #expect(!seen.contains(c))
    }
}
