import Affine_Test_Support
import Testing

@testable import Affine

private enum Byte {}
private enum Bit {}
private enum Word {}

extension Affine.Discrete {
    @Suite
    struct `Ratio Test` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

extension Affine.Discrete.`Ratio Test`.Unit {

    @Test
    func `construction from int`() {
        let r = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        #expect(r.factor == 8)
    }

    @Test
    func `construction from tagged cardinal`() {
        let count: Tagged<Bit, Cardinal> = 64
        let r = Affine.Discrete.Ratio<Word, Bit>(count)
        #expect(r.factor == 64)
    }

    @Test
    func `identity factor`() {
        let identity = Affine.Discrete.Ratio<Byte, Byte>.identity
        #expect(identity.factor == 1)
    }

    @Test
    func `negate factor`() {
        let negate = Affine.Discrete.Ratio<Byte, Byte>.negate
        #expect(negate.factor == -1)
    }

    @Test
    func `same domain expressible by integer literal`() {
        let r: Affine.Discrete.Ratio<Byte, Byte> = 3
        #expect(r.factor == 3)
    }

    @Test
    func `ratio composition`() {
        let bitsPerByte = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let bytesPerWord = Affine.Discrete.Ratio<Word, Byte>.init(8)
        let bitsPerWord: Affine.Discrete.Ratio<Word, Bit> = bytesPerWord * bitsPerByte
        #expect(bitsPerWord.factor == 64)
    }

    @Test
    func `composition with identity`() {
        let r = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let identity = Affine.Discrete.Ratio<Bit, Bit>.identity
        let composed: Affine.Discrete.Ratio<Byte, Bit> = r * identity
        #expect(composed.factor == 8)
    }

    @Test
    func `composition with negate`() {
        let r = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let negate = Affine.Discrete.Ratio<Bit, Bit>.negate
        let composed: Affine.Discrete.Ratio<Byte, Bit> = r * negate
        #expect(composed.factor == -8)
    }

    @Test
    func `quotient and remainder cardinal even division`() throws {
        let bitsPerByte = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let count: Tagged<Bit, Cardinal> = 64
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: count)
        #expect(quotient.underlying == Cardinal(8))
        #expect(remainder.underlying == .zero)
    }

    @Test
    func `quotient and remainder cardinal with remainder`() throws {
        let bitsPerByte = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let count: Tagged<Bit, Cardinal> = 100
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: count)
        #expect(quotient.underlying == Cardinal(12))
        #expect(remainder.underlying == Cardinal(4))
    }

    @Test
    func `quotient and remainder ordinal even division`() throws {
        let bitsPerByte = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let index: Tagged<Bit, Ordinal> = 64
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: index)
        #expect(quotient.underlying == Ordinal(UInt(8)))
        #expect(remainder.underlying == Affine.Discrete.Vector(0))
    }

    @Test
    func `quotient and remainder ordinal with remainder`() throws {
        let bitsPerByte = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let index: Tagged<Bit, Ordinal> = 100
        let (quotient, remainder) = try bitsPerByte.quotientAndRemainder(dividing: index)
        #expect(quotient.underlying == Ordinal(UInt(12)))
        #expect(remainder.underlying == Affine.Discrete.Vector(4))
    }
}

extension Affine.Discrete.`Ratio Test`.`Edge Case` {

    @Test
    func `quotient and remainder cardinal throws on zero factor`() {
        let zero = Affine.Discrete.Ratio<Byte, Bit>.init(0)
        let count: Tagged<Bit, Cardinal> = 64
        #expect(throws: Affine.Discrete.Ratio<Byte, Bit>.Error.zeroFactor) {
            try zero.quotientAndRemainder(dividing: count)
        }
    }

    @Test
    func `quotient and remainder ordinal throws on zero factor`() {
        let zero = Affine.Discrete.Ratio<Byte, Bit>.init(0)
        let index: Tagged<Bit, Ordinal> = 64
        #expect(throws: Affine.Discrete.Ratio<Byte, Bit>.Error.zeroFactor) {
            try zero.quotientAndRemainder(dividing: index)
        }
    }

    @Test
    func `quotient and remainder cardinal throws on negative factor`() {
        let negative = Affine.Discrete.Ratio<Byte, Bit>.init(-8)
        let count: Tagged<Bit, Cardinal> = 64
        #expect(throws: Affine.Discrete.Ratio<Byte, Bit>.Error.negativeFactor(-8)) {
            try negative.quotientAndRemainder(dividing: count)
        }
    }

    @Test
    func `quotient and remainder ordinal throws on negative factor`() {
        let negative = Affine.Discrete.Ratio<Byte, Bit>.init(-8)
        let index: Tagged<Bit, Ordinal> = 64
        #expect(throws: Affine.Discrete.Ratio<Byte, Bit>.Error.negativeFactor(-8)) {
            try negative.quotientAndRemainder(dividing: index)
        }
    }

    @Test
    func `quotient and remainder cardinal throws when dividend exceeds int max`() {
        let bitsPerByte = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let count = Tagged<Bit, Cardinal>(_unchecked: .max)
        #expect(throws: Affine.Discrete.Ratio<Byte, Bit>.Error.unrepresentable) {
            try bitsPerByte.quotientAndRemainder(dividing: count)
        }
    }

    @Test
    func `quotient and remainder ordinal throws when dividend exceeds int max`() {
        let bitsPerByte = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let index = Tagged<Bit, Ordinal>(_unchecked: Ordinal(UInt.max))
        #expect(throws: Affine.Discrete.Ratio<Byte, Bit>.Error.unrepresentable) {
            try bitsPerByte.quotientAndRemainder(dividing: index)
        }
    }
}

extension Affine.Discrete.`Ratio Test`.Integration {

    @Test
    func `description contains factor`() {
        let r = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        #expect(r.description.contains("8"))
    }

    @Test
    func `hashable conformance`() {
        let a = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let b = Affine.Discrete.Ratio<Byte, Bit>.init(8)
        let c = Affine.Discrete.Ratio<Byte, Bit>.init(16)
        var seen: Set<Affine.Discrete.Ratio<Byte, Bit>> = []
        seen.insert(a)
        #expect(seen.contains(b))
        #expect(!seen.contains(c))
    }
}
