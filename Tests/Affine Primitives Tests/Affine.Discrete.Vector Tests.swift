import Affine_Primitives_Test_Support
import Testing

@testable import Affine_Primitives

extension Affine.Discrete.Vector {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite struct Performance {}
    }
}

// MARK: - Unit

extension Affine.Discrete.Vector.Test.Unit {

    // MARK: Construction

    @Test
    func `construction from int`() {
        let v = Affine.Discrete.Vector(5)
        #expect(v.rawValue == 5)
    }

    @Test
    func `construction from negative int`() {
        let v = Affine.Discrete.Vector(-3)
        #expect(v.rawValue == -3)
    }

    @Test
    func `construction from integer literal`() {
        let v: Affine.Discrete.Vector = 7
        #expect(v.rawValue == 7)
    }

    @Test
    func `construction from negative integer literal`() {
        let v: Affine.Discrete.Vector = -2
        #expect(v.rawValue == -2)
    }

    // MARK: Constants

    @Test
    func `zero constant`() {
        #expect(Affine.Discrete.Vector.zero.rawValue == 0)
    }

    @Test
    func `one constant`() {
        #expect(Affine.Discrete.Vector.one.rawValue == 1)
    }

    // MARK: Arithmetic

    @Test
    func `addition operator`() {
        let a: Affine.Discrete.Vector = 5
        let b: Affine.Discrete.Vector = 3
        #expect((a + b).rawValue == 8)
    }

    @Test
    func `addition of opposing signs`() {
        let a: Affine.Discrete.Vector = 5
        let b: Affine.Discrete.Vector = -3
        #expect((a + b).rawValue == 2)
    }

    @Test
    func `subtraction operator`() {
        let a: Affine.Discrete.Vector = 5
        let b: Affine.Discrete.Vector = 3
        #expect((a - b).rawValue == 2)
    }

    @Test
    func `subtraction yielding negative`() {
        let a: Affine.Discrete.Vector = 3
        let b: Affine.Discrete.Vector = 5
        #expect((a - b).rawValue == -2)
    }

    @Test
    func `compound addition`() {
        var a: Affine.Discrete.Vector = 5
        a += Affine.Discrete.Vector(3)
        #expect(a.rawValue == 8)
    }

    @Test
    func `compound subtraction`() {
        var a: Affine.Discrete.Vector = 5
        a -= Affine.Discrete.Vector(3)
        #expect(a.rawValue == 2)
    }

    @Test
    func `unary minus`() {
        let v: Affine.Discrete.Vector = 5
        let negated: Affine.Discrete.Vector = -v
        #expect(negated.rawValue == -5)
    }

    // MARK: Magnitude

    @Test
    func `magnitude of positive`() {
        let v: Affine.Discrete.Vector = 5
        #expect(v.magnitude == Cardinal(5))
    }

    @Test
    func `magnitude of negative`() {
        let v: Affine.Discrete.Vector = -5
        #expect(v.magnitude == Cardinal(5))
    }

    @Test
    func `magnitude of zero`() {
        let v: Affine.Discrete.Vector = .zero
        #expect(v.magnitude == .zero)
    }

    // MARK: Comparison

    @Test
    func comparison() {
        let a: Affine.Discrete.Vector = 3
        let b: Affine.Discrete.Vector = 5
        #expect(a < b)
        #expect(a <= b)
        #expect(b > a)
        #expect(b >= a)
        #expect(a == a)
        #expect(a != b)
    }

    @Test
    func `negative before positive`() {
        let neg: Affine.Discrete.Vector = -5
        let pos: Affine.Discrete.Vector = 5
        #expect(neg < pos)
    }
}

// MARK: - Edge Case

extension Affine.Discrete.Vector.Test.`Edge Case` {

    @Test
    func `error unrepresentable`() {
        let error: Affine.Discrete.Vector.Error = .unrepresentable
        #expect(error == .unrepresentable)
    }
}

// MARK: - Integration

extension Affine.Discrete.Vector.Test.Integration {

    @Test
    func `description contains raw value`() {
        let v = Affine.Discrete.Vector(42)
        #expect(v.description == "Vector(42)")
    }

    @Test
    func `description of negative`() {
        let v = Affine.Discrete.Vector(-7)
        #expect(v.description == "Vector(-7)")
    }

    @Test
    func `hashable conformance`() {
        let a: Affine.Discrete.Vector = 5
        let b: Affine.Discrete.Vector = 5
        let c: Affine.Discrete.Vector = 6
        var seen: Set<Affine.Discrete.Vector> = []
        seen.insert(a)
        #expect(seen.contains(b))
        #expect(!seen.contains(c))
    }
}
