import Affine_Test_Support
import Testing

@testable import Affine

private enum Byte {}
private enum Bit {}
private enum Word {}

extension Affine {
    @Suite
    struct `Affine ratios convert counts across domains with exact quotient semantics` {
        @Suite struct `Affine ratio construction composition and division preserve factors and domains` {}
        @Suite struct `Affine ratio division validates factors and supports the full count range` {}
        @Suite struct `Affine ratio descriptions and hashing preserve their factor` {}
        @Suite(.serialized) struct `No affine ratio performance cases are defined` {}
    }
}

extension Affine.`Affine ratios convert counts across domains with exact quotient semantics`.`Affine ratio construction composition and division preserve factors and domains` {

    @Test
    func `Affine ratio construction preserves its integer factor`() throws {
        let r = Ratio<Byte, Bit>.init(8)
        #expect(try r.intValue() == 8)
    }

    @Test
    func `Tagged counts provide the magnitude of a positive ratio`() throws {
        let count: Tagged<Bit, Cardinal> = 64
        let r = Ratio<Word, Bit>.positive(Rational(Int128(count.underlying.rawValue)).magnitude)
        #expect(try r.intValue() == 64)
    }

    @Test
    func `The identity ratio has a factor of one`() throws {
        let identity = Ratio<Byte, Byte>.identity
        #expect(try identity.intValue() == 1)
    }

    @Test
    func `The negating ratio has a factor of negative one`() throws {
        let negate = Ratio<Byte, Byte>.negate
        #expect(try negate.intValue() == -1)
    }

    @Test
    func `Integer literals construct ratios within the same domain`() throws {
        let r: Ratio<Byte, Byte> = 3
        #expect(try r.intValue() == 3)
    }

    @Test
    func `Ratio composition multiplies factors across matching domains`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let bytesPerWord = Ratio<Word, Byte>.init(8)
        let bitsPerWord: Ratio<Word, Bit> = bytesPerWord * bitsPerByte
        #expect(try bitsPerWord.intValue() == 64)
    }

    @Test
    func `Composing with the identity ratio preserves the factor`() throws {
        let r = Ratio<Byte, Bit>.init(8)
        let identity = Ratio<Bit, Bit>.identity
        let composed: Ratio<Byte, Bit> = r * identity
        #expect(try composed.intValue() == 8)
    }

    @Test
    func `Composing with a negating ratio reverses the factor sign`() throws {
        let r = Ratio<Byte, Bit>.init(8)
        let negate = Ratio<Bit, Bit>.negate
        let composed: Ratio<Byte, Bit> = r * negate
        #expect(try composed.intValue() == -8)
    }

    @Test
    func `Ratio division of an exact count produces no remainder`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let count: Tagged<Bit, Cardinal> = 64
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: count)
        #expect(quotient.underlying == Cardinal(8))
        #expect(remainder.underlying == .zero)
    }

    @Test
    func `Ratio division preserves the count quotient and remainder`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let count: Tagged<Bit, Cardinal> = 100
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: count)
        #expect(quotient.underlying == Cardinal(12))
        #expect(remainder.underlying == Cardinal(4))
    }

    @Test
    func `Exact counts derived from ordinal positions divide without a remainder`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let index: Tagged<Bit, Ordinal> = 64
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: Tagged<Bit, Cardinal>(_unchecked: Cardinal(index.underlying.rawValue)))
        #expect(quotient.underlying == Cardinal(8))
        #expect(remainder.underlying == Cardinal(0))
    }

    @Test
    func `Counts derived from ordinal positions retain their quotient and remainder`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let index: Tagged<Bit, Ordinal> = 100
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: Tagged<Bit, Cardinal>(_unchecked: Cardinal(index.underlying.rawValue)))
        #expect(quotient.underlying == Cardinal(12))
        #expect(remainder.underlying == Cardinal(4))
    }
}

extension Affine.`Affine ratios convert counts across domains with exact quotient semantics`.`Affine ratio division validates factors and supports the full count range` {

    @Test
    func `quotient and remainder cardinal throws on zero factor`() throws {
        let zero = Ratio<Byte, Bit>.init(0)
        let count: Tagged<Bit, Cardinal> = 64
        #expect(throws: Ratio<Byte, Bit>.Error.zeroFactor) {
            try zero.quotientAndRemainder(dividing: count)
        }
    }

    @Test
    func `quotient and remainder count from ordinal origin throws on zero factor`() throws {
        let zero = Ratio<Byte, Bit>.init(0)
        let index: Tagged<Bit, Ordinal> = 64
        #expect(throws: Ratio<Byte, Bit>.Error.zeroFactor) {
            try zero.quotientAndRemainder(dividing: Tagged<Bit, Cardinal>(_unchecked: Cardinal(index.underlying.rawValue)))
        }
    }

    @Test
    func `quotient and remainder cardinal throws on negative factor`() throws {
        let negative = Ratio<Byte, Bit>.init(-8)
        let count: Tagged<Bit, Cardinal> = 64
        #expect(throws: Ratio<Byte, Bit>.Error.negativeFactor) {
            try negative.quotientAndRemainder(dividing: count)
        }
    }

    @Test
    func `quotient and remainder count from ordinal origin throws on negative factor`() throws {
        let negative = Ratio<Byte, Bit>.init(-8)
        let index: Tagged<Bit, Ordinal> = 64
        #expect(throws: Ratio<Byte, Bit>.Error.negativeFactor) {
            try negative.quotientAndRemainder(dividing: Tagged<Bit, Cardinal>(_unchecked: Cardinal(index.underlying.rawValue)))
        }
    }

    @Test
    func `quotient and remainder cardinal supports full range`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let count = Tagged<Bit, Cardinal>(_unchecked: .max)
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: count)
        #expect(quotient.underlying.rawValue == UInt.max / 8)
        #expect(remainder.underlying.rawValue == UInt.max % 8)
    }

    @Test
    func `quotient and remainder count from ordinal origin supports full range`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let index = Tagged<Bit, Ordinal>(_unchecked: Ordinal(UInt.max))
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: Tagged<Bit, Cardinal>(_unchecked: Cardinal(index.underlying.rawValue)))
        #expect(quotient.underlying.rawValue == UInt.max / 8)
        #expect(remainder.underlying.rawValue == UInt.max % 8)
    }
}

extension Affine.`Affine ratios convert counts across domains with exact quotient semantics`.`Affine ratio descriptions and hashing preserve their factor` {

    @Test
    func `description contains factor`() throws {
        let r = Ratio<Byte, Bit>.init(8)
        #expect(r.description.contains("8"))
    }

    @Test
    func `Sets deduplicate ratios with equal factors`() throws {
        let a = Ratio<Byte, Bit>.init(8)
        let b = Ratio<Byte, Bit>.init(8)
        let c = Ratio<Byte, Bit>.init(16)
        var seen: Set<Ratio<Byte, Bit>> = []
        seen.insert(a)
        #expect(seen.contains(b))
        #expect(!seen.contains(c))
    }
}
