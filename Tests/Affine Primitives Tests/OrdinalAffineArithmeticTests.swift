import Affine_Primitives_Test_Support
import Testing

@testable import Affine_Primitives

@Suite
struct OrdinalAffineArithmeticTests {
    enum Element {}

    typealias Position = Tagged<Element, Ordinal>
    typealias Offset = Tagged<Element, Ordinal>.Offset

    // MARK: - Bare Ordinal ± Bare Vector

    @Test
    func barePositionPlusVectorPositive() throws(Ordinal.Error) {
        let p = Ordinal(UInt(5))
        let v = Affine.Discrete.Vector(3)
        let q: Ordinal = try p + v
        #expect(q == Ordinal(UInt(8)))
    }

    @Test
    func barePositionPlusVectorNegative() throws(Ordinal.Error) {
        let p = Ordinal(UInt(5))
        let v = Affine.Discrete.Vector(-3)
        let q: Ordinal = try p + v
        #expect(q == Ordinal(UInt(2)))
    }

    @Test
    func barePositionPlusVectorUnderflow() {
        let p = Ordinal(UInt(2))
        let v = Affine.Discrete.Vector(-5)
        #expect(throws: Ordinal.Error.underflow) {
            let _: Ordinal = try p + v
        }
    }

    @Test
    func barePositionMinusVectorYieldsPosition() throws(Ordinal.Error) {
        let p = Ordinal(UInt(5))
        let v = Affine.Discrete.Vector(3)
        let q: Ordinal = try p - v
        #expect(q == Ordinal(UInt(2)))
    }

    @Test
    func barePositionMinusPositionYieldsVector() throws(Affine.Discrete.Vector.Error) {
        let p = Ordinal(UInt(8))
        let q = Ordinal(UInt(3))
        let displacement: Affine.Discrete.Vector = try p - q
        #expect(displacement.rawValue == 5)
    }

    @Test
    func barePositionMinusPositionYieldsNegativeVector() throws(Affine.Discrete.Vector.Error) {
        let p = Ordinal(UInt(3))
        let q = Ordinal(UInt(8))
        let displacement: Affine.Discrete.Vector = try p - q
        #expect(displacement.rawValue == -5)
    }

    // MARK: - Tagged Position ± Tagged Offset

    @Test
    func taggedPositionPlusOffsetPositive() throws(Ordinal.Error) {
        let p: Position = 5
        let step: Offset = 3
        let q: Position = try p + step
        #expect(q.underlying == Ordinal(UInt(8)))
    }

    @Test
    func taggedPositionPlusOffsetNegative() throws(Ordinal.Error) {
        let p: Position = 5
        let stepBack: Offset = -3
        let q: Position = try p + stepBack
        #expect(q.underlying == Ordinal(UInt(2)))
    }

    @Test
    func taggedOffsetPlusPositionCommutative() throws(Ordinal.Error) {
        let p: Position = 5
        let step: Offset = 3
        let q: Position = try step + p
        #expect(q.underlying == Ordinal(UInt(8)))
    }

    @Test
    func taggedPositionMinusOffsetYieldsPosition() throws(Ordinal.Error) {
        let p: Position = 5
        let step: Offset = 3
        let q: Position = try p - step
        #expect(q.underlying == Ordinal(UInt(2)))
    }

    @Test
    func compoundAdvanceTagged() throws(Ordinal.Error) {
        var p: Position = 5
        let step: Offset = 3
        try p += step
        #expect(p.underlying == Ordinal(UInt(8)))
    }

    @Test
    func compoundRetreatTagged() throws(Ordinal.Error) {
        var p: Position = 5
        let step: Offset = 3
        try p -= step
        #expect(p.underlying == Ordinal(UInt(2)))
    }

    // MARK: - Cross-Domain Scaling on Cardinal

    @Test
    func taggedCardinalScalesViaRatio() {
        enum Byte {}
        enum Bit {}
        let bytes: Tagged<Byte, Cardinal> = 4
        let bitsPerByte: Affine.Discrete.Ratio<Byte, Bit> = .init(8)
        let bits: Tagged<Bit, Cardinal> = bytes * bitsPerByte
        #expect(bits.underlying == Cardinal(32))
    }

    @Test
    func taggedCardinalScalingCommutative() {
        enum Byte {}
        enum Bit {}
        let bytes: Tagged<Byte, Cardinal> = 4
        let bitsPerByte: Affine.Discrete.Ratio<Byte, Bit> = .init(8)
        let bits: Tagged<Bit, Cardinal> = bitsPerByte * bytes
        #expect(bits.underlying == Cardinal(32))
    }

    // MARK: - Cross-Domain Scaling on Vector

    @Test
    func taggedVectorScalesViaRatio() {
        enum Byte {}
        enum Bit {}
        let byteOffset: Tagged<Byte, Affine.Discrete.Vector> = -2
        let bitsPerByte: Affine.Discrete.Ratio<Byte, Bit> = .init(8)
        let bitOffset: Tagged<Bit, Affine.Discrete.Vector> = byteOffset * bitsPerByte
        #expect(bitOffset.underlying == Affine.Discrete.Vector(-16))
    }

    // MARK: - Ordinal init from Vector

    @Test
    func ordinalFromNonNegativeVector() throws(Ordinal.Error) {
        let v = Affine.Discrete.Vector(5)
        let o = try Ordinal(v)
        #expect(o == Ordinal(UInt(5)))
    }

    @Test
    func ordinalFromNegativeVectorThrows() {
        let v = Affine.Discrete.Vector(-5)
        #expect(throws: Ordinal.Error.negativeSource(-5)) {
            try Ordinal(v)
        }
    }
}
