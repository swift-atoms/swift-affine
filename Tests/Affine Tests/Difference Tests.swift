import Affine_Test_Support
import Testing

@testable import Affine

extension Difference {
    @Suite
    struct `Test` {
        @Suite struct `Unit` {}
        @Suite struct `Edge Case` {}
        @Suite struct `Integration` {}
        @Suite(.serialized) struct `Performance` {}
    }
}

extension Difference.Test.Unit {

    @Test
    func `construction from int`() throws {
        let v = Difference(5)
        #expect(try v.intValue() == 5)
    }

    @Test
    func `construction from negative int`() throws {
        let v = Difference(-3)
        #expect(try v.intValue() == -3)
    }

    @Test
    func `construction from integer literal`() throws {
        let v: Difference = 7
        #expect(try v.intValue() == 7)
    }

    @Test
    func `construction from negative integer literal`() throws {
        let v: Difference = -2
        #expect(try v.intValue() == -2)
    }

    @Test
    func `zero constant`() throws {
        #expect(try Difference.zero.intValue() == 0)
    }

    @Test
    func `one constant`() throws {
        #expect(try Difference.one.intValue() == 1)
    }

    @Test
    func `addition operator`() throws {
        let a: Difference = 5
        let b: Difference = 3
        #expect(try (a + b).intValue() == 8)
    }

    @Test
    func `addition of opposing signs`() throws {
        let a: Difference = 5
        let b: Difference = -3
        #expect(try (a + b).intValue() == 2)
    }

    @Test
    func `subtraction operator`() throws {
        let a: Difference = 5
        let b: Difference = 3
        #expect(try (a - b).intValue() == 2)
    }

    @Test
    func `subtraction yielding negative`() throws {
        let a: Difference = 3
        let b: Difference = 5
        #expect(try (a - b).intValue() == -2)
    }

    @Test
    func `compound addition`() throws {
        var a: Difference = 5
        a += Difference(3)
        #expect(try a.intValue() == 8)
    }

    @Test
    func `compound subtraction`() throws {
        var a: Difference = 5
        a -= Difference(3)
        #expect(try a.intValue() == 2)
    }

    @Test
    func `unary minus`() throws {
        let v: Difference = 5
        let negated: Difference = -v
        #expect(try negated.intValue() == -5)
    }

    @Test
    func `magnitude of positive`() throws {
        let v: Difference = 5
        #expect(v.magnitude == Difference.Magnitude(Cardinal(5)))
    }

    @Test
    func `magnitude of negative`() throws {
        let v: Difference = -5
        #expect(v.magnitude == Difference.Magnitude(Cardinal(5)))
    }

    @Test
    func `magnitude of zero`() throws {
        let v: Difference = .zero
        #expect(v.magnitude == .zero)
    }

    @Test
    func `comparison`() {
        let a: Difference = 3
        let b: Difference = 5
        #expect(a < b)
        #expect(a <= b)
        #expect(b > a)
        #expect(b >= a)
        #expect(a == a)
        #expect(a != b)
    }

    @Test
    func `negative before positive`() throws {
        let neg: Difference = -5
        let pos: Difference = 5
        #expect(neg < pos)
    }
}

extension Difference.Test.`Edge Case` {

    @Test
    func `error unrepresentable`() throws {
        let error: Difference.Error = .unrepresentable
        #expect(error == .unrepresentable)
    }
}

extension Difference.Test.Integration {

    @Test
    func `description contains raw value`() throws {
        let v = Difference(42)
        #expect(v.description == "42")
    }

    @Test
    func `description of negative`() throws {
        let v = Difference(-7)
        #expect(v.description == "-7")
    }

    @Test
    func `hashable conformance`() throws {
        let a: Difference = 5
        let b: Difference = 5
        let c: Difference = 6
        var seen: Set<Difference> = []
        seen.insert(a)
        #expect(seen.contains(b))
        #expect(!seen.contains(c))
    }
}
