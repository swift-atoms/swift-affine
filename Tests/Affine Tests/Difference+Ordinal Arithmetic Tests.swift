import Affine_Test_Support
import Testing

@testable import Affine

private enum Element {}

extension Difference {
    @Suite
    struct `Ordinal Arithmetic` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

extension Difference.`Ordinal Arithmetic`.Unit {

    @Test
    func `bare position plus vector positive`() throws {
        let p = Ordinal(UInt(5))
        let v = Difference(3)
        let q: Ordinal = try p + v
        #expect(q == Ordinal(UInt(8)))
    }

    @Test
    func `bare position plus vector negative`() throws {
        let p = Ordinal(UInt(5))
        let v = Difference(-3)
        let q: Ordinal = try p + v
        #expect(q == Ordinal(UInt(2)))
    }

    @Test
    func `bare position minus vector yields position`() throws {
        let p = Ordinal(UInt(5))
        let v = Difference(3)
        let q: Ordinal = try p - v
        #expect(q == Ordinal(UInt(2)))
    }

    @Test
    func `bare position minus position yields vector`() throws {
        let p = Ordinal(UInt(8))
        let q = Ordinal(UInt(3))
        let displacement: Difference = p - q
        #expect(try displacement.intValue() == 5)
    }

    @Test
    func `bare position minus position yields negative vector`() throws
    {
        let p = Ordinal(UInt(3))
        let q = Ordinal(UInt(8))
        let displacement: Difference = p - q
        #expect(try displacement.intValue() == -5)
    }

    @Test
    func `tagged position plus offset positive`() throws {
        let p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        let q: Tagged<Element, Ordinal> = try p + step
        #expect(q.underlying == Ordinal(UInt(8)))
    }

    @Test
    func `tagged position plus offset negative`() throws {
        let p: Tagged<Element, Ordinal> = 5
        let stepBack: Tagged<Element, Ordinal>.Offset = -3
        let q: Tagged<Element, Ordinal> = try p + stepBack
        #expect(q.underlying == Ordinal(UInt(2)))
    }

    @Test
    func `tagged offset plus position commutative`() throws {
        let p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        let q: Tagged<Element, Ordinal> = try step + p
        #expect(q.underlying == Ordinal(UInt(8)))
    }

    @Test
    func `tagged position minus offset yields position`() throws {
        let p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        let q: Tagged<Element, Ordinal> = try p - step
        #expect(q.underlying == Ordinal(UInt(2)))
    }

    @Test
    func `compound advance tagged`() throws {
        var p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        try p += step
        #expect(p.underlying == Ordinal(UInt(8)))
    }

    @Test
    func `compound retreat tagged`() throws {
        var p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        try p -= step
        #expect(p.underlying == Ordinal(UInt(2)))
    }

    @Test
    func `tagged cardinal scales via ratio`() throws {
        enum Byte {}
        enum Bit {}
        let bytes: Tagged<Byte, Cardinal> = 4
        let bitsPerByte: Ratio<Byte, Bit> = .init(8)
        let bits: Tagged<Bit, Cardinal> = bytes * bitsPerByte
        #expect(bits.underlying == Cardinal(32))
    }

    @Test
    func `tagged cardinal scaling commutative`() throws {
        enum Byte {}
        enum Bit {}
        let bytes: Tagged<Byte, Cardinal> = 4
        let bitsPerByte: Ratio<Byte, Bit> = .init(8)
        let bits: Tagged<Bit, Cardinal> = bitsPerByte * bytes
        #expect(bits.underlying == Cardinal(32))
    }

    @Test
    func `tagged vector scales via ratio`() throws {
        enum Byte {}
        enum Bit {}
        let byteOffset: Tagged<Byte, Difference> = -2
        let bitsPerByte: Ratio<Byte, Bit> = .init(8)
        let bitOffset: Tagged<Bit, Difference> = try bitsPerByte.applying(to: byteOffset)
        #expect(bitOffset.underlying == Difference(-16))
    }

    @Test
    func `ordinal from non negative vector`() throws {
        let v = Difference(5)
        let o = try Ordinal(v)
        #expect(o == Ordinal(UInt(5)))
    }
}

extension Difference.`Ordinal Arithmetic`.`Edge Case` {

    @Test
    func `bare position plus vector underflow`() throws {
        let p = Ordinal(UInt(2))
        let v = Difference(-5)
        #expect(throws: Ordinal.Error.underflow) {
            let _: Ordinal = try p + v
        }
    }

    @Test
    func `ordinal from negative vector throws`() throws {
        let v = Difference(-5)
        #expect(throws: Ordinal.Error.underflow) {
            try Ordinal(v)
        }
    }
}
