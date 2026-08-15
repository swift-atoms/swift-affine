import Affine_Primitives_Test_Support
import Testing

@testable import Affine_Primitives

private enum Element {}

extension Affine.Discrete.Vector {
    @Suite
    struct `Ordinal Arithmetic` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

// MARK: - Unit

extension Affine.Discrete.Vector.`Ordinal Arithmetic`.Unit {

    // MARK: Bare Ordinal ± Bare Vector

    @Test
    func `bare position plus vector positive`() throws(Ordinal.Error) {
        let p = Ordinal(UInt(5))
        let v = Affine.Discrete.Vector(3)
        let q: Ordinal = try p + v
        #expect(q == Ordinal(UInt(8)))
    }

    @Test
    func `bare position plus vector negative`() throws(Ordinal.Error) {
        let p = Ordinal(UInt(5))
        let v = Affine.Discrete.Vector(-3)
        let q: Ordinal = try p + v
        #expect(q == Ordinal(UInt(2)))
    }

    @Test
    func `bare position minus vector yields position`() throws(Ordinal.Error) {
        let p = Ordinal(UInt(5))
        let v = Affine.Discrete.Vector(3)
        let q: Ordinal = try p - v
        #expect(q == Ordinal(UInt(2)))
    }

    @Test
    func `bare position minus position yields vector`() throws(Affine.Discrete.Vector.Error) {
        let p = Ordinal(UInt(8))
        let q = Ordinal(UInt(3))
        let displacement: Affine.Discrete.Vector = try p - q
        #expect(displacement.rawValue == 5)
    }

    @Test
    func `bare position minus position yields negative vector`() throws(Affine.Discrete.Vector
        .Error)
    {
        let p = Ordinal(UInt(3))
        let q = Ordinal(UInt(8))
        let displacement: Affine.Discrete.Vector = try p - q
        #expect(displacement.rawValue == -5)
    }

    // MARK: Tagged Position ± Tagged Offset

    @Test
    func `tagged position plus offset positive`() throws(Ordinal.Error) {
        let p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        let q: Tagged<Element, Ordinal> = try p + step
        #expect(q.underlying == Ordinal(UInt(8)))
    }

    @Test
    func `tagged position plus offset negative`() throws(Ordinal.Error) {
        let p: Tagged<Element, Ordinal> = 5
        let stepBack: Tagged<Element, Ordinal>.Offset = -3
        let q: Tagged<Element, Ordinal> = try p + stepBack
        #expect(q.underlying == Ordinal(UInt(2)))
    }

    @Test
    func `tagged offset plus position commutative`() throws(Ordinal.Error) {
        let p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        let q: Tagged<Element, Ordinal> = try step + p
        #expect(q.underlying == Ordinal(UInt(8)))
    }

    @Test
    func `tagged position minus offset yields position`() throws(Ordinal.Error) {
        let p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        let q: Tagged<Element, Ordinal> = try p - step
        #expect(q.underlying == Ordinal(UInt(2)))
    }

    @Test
    func `compound advance tagged`() throws(Ordinal.Error) {
        var p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        try p += step
        #expect(p.underlying == Ordinal(UInt(8)))
    }

    @Test
    func `compound retreat tagged`() throws(Ordinal.Error) {
        var p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        try p -= step
        #expect(p.underlying == Ordinal(UInt(2)))
    }

    // MARK: Cross-Domain Scaling on Cardinal

    @Test
    func `tagged cardinal scales via ratio`() {
        enum Byte {}
        enum Bit {}
        let bytes: Tagged<Byte, Cardinal> = 4
        let bitsPerByte: Affine.Discrete.Ratio<Byte, Bit> = .init(8)
        let bits: Tagged<Bit, Cardinal> = bytes * bitsPerByte
        #expect(bits.underlying == Cardinal(32))
    }

    @Test
    func `tagged cardinal scaling commutative`() {
        enum Byte {}
        enum Bit {}
        let bytes: Tagged<Byte, Cardinal> = 4
        let bitsPerByte: Affine.Discrete.Ratio<Byte, Bit> = .init(8)
        let bits: Tagged<Bit, Cardinal> = bitsPerByte * bytes
        #expect(bits.underlying == Cardinal(32))
    }

    // MARK: Cross-Domain Scaling on Vector

    @Test
    func `tagged vector scales via ratio`() {
        enum Byte {}
        enum Bit {}
        let byteOffset: Tagged<Byte, Affine.Discrete.Vector> = -2
        let bitsPerByte: Affine.Discrete.Ratio<Byte, Bit> = .init(8)
        let bitOffset: Tagged<Bit, Affine.Discrete.Vector> = byteOffset * bitsPerByte
        #expect(bitOffset.underlying == Affine.Discrete.Vector(-16))
    }

    // MARK: Ordinal init from Vector

    @Test
    func `ordinal from non negative vector`() throws(Ordinal.Error) {
        let v = Affine.Discrete.Vector(5)
        let o = try Ordinal(v)
        #expect(o == Ordinal(UInt(5)))
    }
}

// MARK: - Edge Case

extension Affine.Discrete.Vector.`Ordinal Arithmetic`.`Edge Case` {

    @Test
    func `bare position plus vector underflow`() {
        let p = Ordinal(UInt(2))
        let v = Affine.Discrete.Vector(-5)
        #expect(throws: Ordinal.Error.underflow) {
            let _: Ordinal = try p + v
        }
    }

    @Test
    func `ordinal from negative vector throws`() {
        let v = Affine.Discrete.Vector(-5)
        #expect(throws: Ordinal.Error.negativeSource(-5)) {
            try Ordinal(v)
        }
    }
}
