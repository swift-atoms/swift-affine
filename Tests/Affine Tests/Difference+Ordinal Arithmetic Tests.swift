import Affine_Test_Support
import Testing

@testable import Affine

private enum Element {}

extension Difference {
    @Suite
    struct `Ordinal positions support signed differences and domain preserving scaling` {
        @Suite struct `Ordinal translation and subtraction preserve positions and displacements` {}
        @Suite struct `Ordinal translation and conversion reject negative positions` {}
        @Suite struct `No ordinal affine arithmetic integration cases are defined` {}
        @Suite(.serialized) struct `No ordinal affine arithmetic performance cases are defined` {}
    }
}

extension Difference.`Ordinal positions support signed differences and domain preserving scaling`.`Ordinal translation and subtraction preserve positions and displacements` {

    @Test
    func `Positive differences advance ordinal positions`() throws {
        let p = Ordinal(UInt(5))
        let v = Difference(3)
        let q: Ordinal = try p + v
        #expect(q == Ordinal(UInt(8)))
    }

    @Test
    func `Negative differences retreat ordinal positions`() throws {
        let p = Ordinal(UInt(5))
        let v = Difference(-3)
        let q: Ordinal = try p + v
        #expect(q == Ordinal(UInt(2)))
    }

    @Test
    func `Subtracting a difference yields the translated ordinal position`() throws {
        let p = Ordinal(UInt(5))
        let v = Difference(3)
        let q: Ordinal = try p - v
        #expect(q == Ordinal(UInt(2)))
    }

    @Test
    func `Subtracting ordinal positions yields their positive displacement`() throws {
        let p = Ordinal(UInt(8))
        let q = Ordinal(UInt(3))
        let displacement: Difference = p - q
        #expect(try displacement.intValue() == 5)
    }

    @Test
    func `Subtracting a later ordinal position yields a negative displacement`() throws
    {
        let p = Ordinal(UInt(3))
        let q = Ordinal(UInt(8))
        let displacement: Difference = p - q
        #expect(try displacement.intValue() == -5)
    }

    @Test
    func `Positive tagged offsets advance positions in the same domain`() throws {
        let p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        let q: Tagged<Element, Ordinal> = try p + step
        #expect(q.underlying == Ordinal(UInt(8)))
    }

    @Test
    func `Negative tagged offsets retreat positions in the same domain`() throws {
        let p: Tagged<Element, Ordinal> = 5
        let stepBack: Tagged<Element, Ordinal>.Offset = -3
        let q: Tagged<Element, Ordinal> = try p + stepBack
        #expect(q.underlying == Ordinal(UInt(2)))
    }

    @Test
    func `Tagged offsets can precede the position in an addition`() throws {
        let p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        let q: Tagged<Element, Ordinal> = try step + p
        #expect(q.underlying == Ordinal(UInt(8)))
    }

    @Test
    func `Subtracting tagged offsets preserves the position domain`() throws {
        let p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        let q: Tagged<Element, Ordinal> = try p - step
        #expect(q.underlying == Ordinal(UInt(2)))
    }

    @Test
    func `Compound tagged addition advances the position`() throws {
        var p: Tagged<Element, Ordinal> = 5
        let step: Tagged<Element, Ordinal>.Offset = 3
        try p += step
        #expect(p.underlying == Ordinal(UInt(8)))
    }

    @Test
    func `Compound tagged subtraction retreats the position`() throws {
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
    func `Ratios can precede tagged counts when scaling domains`() throws {
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
    func `Nonnegative differences convert to ordinal positions`() throws {
        let v = Difference(5)
        let o = try Ordinal(v)
        #expect(o == Ordinal(UInt(5)))
    }
}

extension Difference.`Ordinal positions support signed differences and domain preserving scaling`.`Ordinal translation and conversion reject negative positions` {

    @Test
    func `Ordinal translation rejects a negative resulting position`() throws {
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
