import Affine_Test_Support
import Testing

@testable import Affine

private enum Byte {}
private enum Bit {}
private enum Word {}

extension Affine {
    @Suite
    struct `Ratio Test` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

extension Affine.`Ratio Test`.Unit {

    @Test
    func `construction from int`() throws {
        let r = Ratio<Byte, Bit>.init(8)
        #expect(try r.intValue() == 8)
    }

    @Test
    func `construction from tagged cardinal`() throws {
        let count: Tagged<Bit, Cardinal> = 64
        let r = Ratio<Word, Bit>.positive(Rational(Int128(count.underlying.rawValue)).magnitude)
        #expect(try r.intValue() == 64)
    }

    @Test
    func `identity factor`() throws {
        let identity = Ratio<Byte, Byte>.identity
        #expect(try identity.intValue() == 1)
    }

    @Test
    func `negate factor`() throws {
        let negate = Ratio<Byte, Byte>.negate
        #expect(try negate.intValue() == -1)
    }

    @Test
    func `same domain expressible by integer literal`() throws {
        let r: Ratio<Byte, Byte> = 3
        #expect(try r.intValue() == 3)
    }

    @Test
    func `ratio composition`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let bytesPerWord = Ratio<Word, Byte>.init(8)
        let bitsPerWord: Ratio<Word, Bit> = bytesPerWord * bitsPerByte
        #expect(try bitsPerWord.intValue() == 64)
    }

    @Test
    func `composition with identity`() throws {
        let r = Ratio<Byte, Bit>.init(8)
        let identity = Ratio<Bit, Bit>.identity
        let composed: Ratio<Byte, Bit> = r * identity
        #expect(try composed.intValue() == 8)
    }

    @Test
    func `composition with negate`() throws {
        let r = Ratio<Byte, Bit>.init(8)
        let negate = Ratio<Bit, Bit>.negate
        let composed: Ratio<Byte, Bit> = r * negate
        #expect(try composed.intValue() == -8)
    }

    @Test
    func `quotient and remainder cardinal even division`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let count: Tagged<Bit, Cardinal> = 64
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: count)
        #expect(quotient.underlying == Cardinal(8))
        #expect(remainder.underlying == .zero)
    }

    @Test
    func `quotient and remainder cardinal with remainder`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let count: Tagged<Bit, Cardinal> = 100
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: count)
        #expect(quotient.underlying == Cardinal(12))
        #expect(remainder.underlying == Cardinal(4))
    }

    @Test
    func `quotient and remainder ordinal even division`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let index: Tagged<Bit, Ordinal> = 64
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: index)
        #expect(quotient.underlying == Ordinal(UInt(8)))
        #expect(remainder.underlying == Difference(0))
    }

    @Test
    func `quotient and remainder ordinal with remainder`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let index: Tagged<Bit, Ordinal> = 100
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: index)
        #expect(quotient.underlying == Ordinal(UInt(12)))
        #expect(remainder.underlying == Difference(4))
    }
}

extension Affine.`Ratio Test`.`Edge Case` {

    @Test
    func `quotient and remainder cardinal throws on zero factor`() throws {
        let zero = Ratio<Byte, Bit>.init(0)
        let count: Tagged<Bit, Cardinal> = 64
        #expect(throws: Ratio<Byte, Bit>.Error.zeroFactor) {
            try zero.quotientAndRemainder(dividing: count)
        }
    }

    @Test
    func `quotient and remainder ordinal throws on zero factor`() throws {
        let zero = Ratio<Byte, Bit>.init(0)
        let index: Tagged<Bit, Ordinal> = 64
        #expect(throws: Ratio<Byte, Bit>.Error.zeroFactor) {
            try zero.quotientAndRemainder(dividing: index)
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
    func `quotient and remainder ordinal throws on negative factor`() throws {
        let negative = Ratio<Byte, Bit>.init(-8)
        let index: Tagged<Bit, Ordinal> = 64
        #expect(throws: Ratio<Byte, Bit>.Error.negativeFactor) {
            try negative.quotientAndRemainder(dividing: index)
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
    func `quotient and remainder ordinal supports full range`() throws {
        let bitsPerByte = Ratio<Byte, Bit>.init(8)
        let index = Tagged<Bit, Ordinal>(_unchecked: Ordinal(UInt.max))
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: index)
        #expect(quotient.underlying.rawValue == UInt.max / 8)
        #expect(remainder.underlying.magnitude.value.rawValue == UInt.max % 8)
    }
}

extension Affine.`Ratio Test`.Integration {

    @Test
    func `description contains factor`() throws {
        let r = Ratio<Byte, Bit>.init(8)
        #expect(r.description.contains("8"))
    }

    @Test
    func `hashable conformance`() throws {
        let a = Ratio<Byte, Bit>.init(8)
        let b = Ratio<Byte, Bit>.init(8)
        let c = Ratio<Byte, Bit>.init(16)
        var seen: Set<Ratio<Byte, Bit>> = []
        seen.insert(a)
        #expect(seen.contains(b))
        #expect(!seen.contains(c))
    }
}
