import Affine_Test_Support
import Testing

@testable import Affine

extension Difference {
    @Suite
    struct `Differences preserve signed values through construction and arithmetic` {
        @Suite struct `Difference arithmetic preserves magnitudes comparisons and literals` {}
        @Suite struct `Difference errors identify unrepresentable values` {}
        @Suite struct `Difference descriptions and hashing preserve signed values` {}
        @Suite(.serialized) struct `No difference arithmetic performance cases are defined` {}
    }
}

extension Difference.`Differences preserve signed values through construction and arithmetic`.`Difference arithmetic preserves magnitudes comparisons and literals` {

    @Test
    func `Difference construction preserves a positive integer`() throws {
        let v = Difference(5)
        #expect(try v.intValue() == 5)
    }

    @Test
    func `Difference construction preserves a negative integer`() throws {
        let v = Difference(-3)
        #expect(try v.intValue() == -3)
    }

    @Test
    func `Integer literals construct the requested difference`() throws {
        let v: Difference = 7
        #expect(try v.intValue() == 7)
    }

    @Test
    func `Negative integer literals construct the requested difference`() throws {
        let v: Difference = -2
        #expect(try v.intValue() == -2)
    }

    @Test
    func `The zero difference represents zero displacement`() throws {
        #expect(try Difference.zero.intValue() == 0)
    }

    @Test
    func `The unit difference represents one positive step`() throws {
        #expect(try Difference.one.intValue() == 1)
    }

    @Test
    func `Adding differences sums their signed values`() throws {
        let a: Difference = 5
        let b: Difference = 3
        #expect(try (a + b).intValue() == 8)
    }

    @Test
    func `Adding differences with opposing signs preserves the signed sum`() throws {
        let a: Difference = 5
        let b: Difference = -3
        #expect(try (a + b).intValue() == 2)
    }

    @Test
    func `Subtracting differences computes their signed distance`() throws {
        let a: Difference = 5
        let b: Difference = 3
        #expect(try (a - b).intValue() == 2)
    }

    @Test
    func `Subtracting a larger difference produces a negative result`() throws {
        let a: Difference = 3
        let b: Difference = 5
        #expect(try (a - b).intValue() == -2)
    }

    @Test
    func `Compound difference addition updates the signed value`() throws {
        var a: Difference = 5
        a += Difference(3)
        #expect(try a.intValue() == 8)
    }

    @Test
    func `Compound difference subtraction updates the signed value`() throws {
        var a: Difference = 5
        a -= Difference(3)
        #expect(try a.intValue() == 2)
    }

    @Test
    func `Negating a difference reverses its sign`() throws {
        let v: Difference = 5
        let negated: Difference = -v
        #expect(try negated.intValue() == -5)
    }

    @Test
    func `A positive difference exposes its unsigned magnitude`() throws {
        let v: Difference = 5
        #expect(v.magnitude == Difference.Magnitude(Cardinal(5)))
    }

    @Test
    func `A negative difference exposes its unsigned magnitude`() throws {
        let v: Difference = -5
        #expect(v.magnitude == Difference.Magnitude(Cardinal(5)))
    }

    @Test
    func `A zero difference has zero magnitude`() throws {
        let v: Difference = .zero
        #expect(v.magnitude == .zero)
    }

    @Test
    func `Difference comparisons follow signed numeric ordering`() {
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
    func `Negative differences sort before positive differences`() throws {
        let neg: Difference = -5
        let pos: Difference = 5
        #expect(neg < pos)
    }
}

extension Difference.`Differences preserve signed values through construction and arithmetic`.`Difference errors identify unrepresentable values` {

    @Test
    func `Difference errors identify an unrepresentable value`() throws {
        let error: Difference.Error = .unrepresentable
        #expect(error == .unrepresentable)
    }
}

extension Difference.`Differences preserve signed values through construction and arithmetic`.`Difference descriptions and hashing preserve signed values` {

    @Test
    func `description contains raw value`() throws {
        let v = Difference(42)
        #expect(v.description == "42")
    }

    @Test
    func `Negative difference descriptions preserve the minus sign`() throws {
        let v = Difference(-7)
        #expect(v.description == "-7")
    }

    @Test
    func `Sets deduplicate differences with equal signed values`() throws {
        let a: Difference = 5
        let b: Difference = 5
        let c: Difference = 6
        var seen: Set<Difference> = []
        seen.insert(a)
        #expect(seen.contains(b))
        #expect(!seen.contains(c))
    }
}
