import Affine_Primitives_Test_Support
import Testing

@testable import Affine_Primitives

@Suite
struct AffineVectorTests {
    // MARK: - Construction

    @Test
    func constructionFromInt() {
        let v = Affine.Discrete.Vector(5)
        #expect(v.rawValue == 5)
    }

    @Test
    func constructionFromNegativeInt() {
        let v = Affine.Discrete.Vector(-3)
        #expect(v.rawValue == -3)
    }

    @Test
    func constructionFromIntegerLiteral() {
        let v: Affine.Discrete.Vector = 7
        #expect(v.rawValue == 7)
    }

    @Test
    func constructionFromNegativeIntegerLiteral() {
        let v: Affine.Discrete.Vector = -2
        #expect(v.rawValue == -2)
    }

    // MARK: - Constants

    @Test
    func zeroConstant() {
        #expect(Affine.Discrete.Vector.zero.rawValue == 0)
    }

    @Test
    func oneConstant() {
        #expect(Affine.Discrete.Vector.one.rawValue == 1)
    }

    // MARK: - Arithmetic

    @Test
    func additionOperator() {
        let a: Affine.Discrete.Vector = 5
        let b: Affine.Discrete.Vector = 3
        #expect((a + b).rawValue == 8)
    }

    @Test
    func additionOfOpposingSigns() {
        let a: Affine.Discrete.Vector = 5
        let b: Affine.Discrete.Vector = -3
        #expect((a + b).rawValue == 2)
    }

    @Test
    func subtractionOperator() {
        let a: Affine.Discrete.Vector = 5
        let b: Affine.Discrete.Vector = 3
        #expect((a - b).rawValue == 2)
    }

    @Test
    func subtractionYieldingNegative() {
        let a: Affine.Discrete.Vector = 3
        let b: Affine.Discrete.Vector = 5
        #expect((a - b).rawValue == -2)
    }

    @Test
    func compoundAddition() {
        var a: Affine.Discrete.Vector = 5
        a += Affine.Discrete.Vector(3)
        #expect(a.rawValue == 8)
    }

    @Test
    func compoundSubtraction() {
        var a: Affine.Discrete.Vector = 5
        a -= Affine.Discrete.Vector(3)
        #expect(a.rawValue == 2)
    }

    @Test
    func unaryMinus() {
        let v: Affine.Discrete.Vector = 5
        let negated: Affine.Discrete.Vector = -v
        #expect(negated.rawValue == -5)
    }

    // MARK: - Magnitude

    @Test
    func magnitudeOfPositive() {
        let v: Affine.Discrete.Vector = 5
        #expect(v.magnitude == Cardinal(5))
    }

    @Test
    func magnitudeOfNegative() {
        let v: Affine.Discrete.Vector = -5
        #expect(v.magnitude == Cardinal(5))
    }

    @Test
    func magnitudeOfZero() {
        let v: Affine.Discrete.Vector = .zero
        #expect(v.magnitude == .zero)
    }

    // MARK: - Comparison

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
    func negativeBeforePositive() {
        let neg: Affine.Discrete.Vector = -5
        let pos: Affine.Discrete.Vector = 5
        #expect(neg < pos)
    }

    // MARK: - Description

    @Test
    func descriptionContainsRawValue() {
        let v = Affine.Discrete.Vector(42)
        #expect(v.description == "Vector(42)")
    }

    @Test
    func descriptionOfNegative() {
        let v = Affine.Discrete.Vector(-7)
        #expect(v.description == "Vector(-7)")
    }

    // MARK: - Conformances

    @Test
    func hashableConformance() {
        let a: Affine.Discrete.Vector = 5
        let b: Affine.Discrete.Vector = 5
        let c: Affine.Discrete.Vector = 6
        var seen: Set<Affine.Discrete.Vector> = []
        seen.insert(a)
        #expect(seen.contains(b))
        #expect(!seen.contains(c))
    }

    // MARK: - Errors

    @Test
    func errorUnrepresentable() {
        let error: Affine.Discrete.Vector.Error = .unrepresentable
        #expect(error == .unrepresentable)
    }
}
