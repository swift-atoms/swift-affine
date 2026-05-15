// TODO post-launch: restore for full coverage.
//
// File covers a previous-generation `Affine.Translation` continuous-coordinate
// translation type. Out of scope for the 0.1.0 discrete surface; the current
// equivalent is the `Position + Vector → Position` operator in
// `OrdinalAffineArithmeticTests.swift`.

// swiftlint:disable comment_spacing

///// Affine.Translation Tests.swift
///// Tests for Affine.Translation.swift
////
//import Testing
//@testable import Affine_Primitives_Test_Support
////
//@Suite
//struct `Affine.Translation Tests` {
//   typealias Translation = Affine<Double, Void>.Translation
//   typealias Dx = Linear<Double, Void>.Dx
//   typealias Dy = Linear<Double, Void>.Dy
//   typealias Vec2 = Linear<Double, Void>.Vector<2>
////
//   // MARK: - Construction Tests
////
//   @Suite
//   struct `Construction` {
//       @Test
//       func `Construction from typed components`() {
//           let t = Translation(dx: Dx(3), dy: Dy(4))
//           #expect(t.dx == 3)
//           #expect(t.dy == 4)
//       }
////
//       @Test
//       func `Construction from raw scalars`() {
//           let t = Translation(dx: 3.0, dy: 4.0)
//           #expect(t.dx == 3)
//           #expect(t.dy == 4)
//       }
////
//       @Test
//       func `Construction from vector`() {
//           let v = Vec2(dx: 3, dy: 4)
//           let t = Translation(v)
//           #expect(t.dx == 3)
//           #expect(t.dy == 4)
//       }
//   }
////
//   // MARK: - Zero Tests
////
//   @Suite
//   struct `Zero` {
//       @Test
//       func `Zero translation`() {
//           let t = Translation.zero
//           #expect(t.dx == 0)
//           #expect(t.dy == 0)
//       }
////
//       @Test
//       func `Zero is additive identity`() {
//           let t = Translation(dx: 5.0, dy: 10.0)
//           let result1 = t + .zero
//           let result2 = Translation.zero + t
//           #expect(result1.dx == 5)
//           #expect(result1.dy == 10)
//           #expect(result2.dx == 5)
//           #expect(result2.dy == 10)
//       }
//   }
////
//   // MARK: - Addition Tests
////
//   @Suite
//   struct `Addition` {
//       @Test(arguments: [
//           (Translation(dx: 3.0, dy: 4.0), Translation(dx: 1.0, dy: 2.0), 4.0 as Dx, 6.0 as Dy),
//           (Translation(dx: 0.0, dy: 0.0), Translation(dx: 5.0, dy: 10.0), 5.0 as Dx, 10.0 as Dy),
//           (Translation(dx: -3.0, dy: -4.0), Translation(dx: 3.0, dy: 4.0), 0.0 as Dx, 0.0 as Dy)
//       ])
//       func addition(t1: Translation, t2: Translation, expectedDx: Dx, expectedDy: Dy) {
//           let result = t1 + t2
//           #expect(result.dx == expectedDx)
//           #expect(result.dy == expectedDy)
//       }
////
//       @Test
//       func `Addition is commutative`() {
//           let t1 = Translation(dx: 3.0, dy: 4.0)
//           let t2 = Translation(dx: 5.0, dy: 6.0)
//           let result1 = t1 + t2
//           let result2 = t2 + t1
//           #expect(result1.dx == result2.dx)
//           #expect(result1.dy == result2.dy)
//       }
////
//       @Test
//       func `Addition is associative`() {
//           let t1 = Translation(dx: 1.0, dy: 2.0)
//           let t2 = Translation(dx: 3.0, dy: 4.0)
//           let t3 = Translation(dx: 5.0, dy: 6.0)
//           let result1 = (t1 + t2) + t3
//           let result2 = t1 + (t2 + t3)
//           #expect(result1.dx == result2.dx)
//           #expect(result1.dy == result2.dy)
//       }
//   }
////
//   // MARK: - Subtraction Tests
////
//   @Suite
//   struct `Subtraction` {
//       @Test(arguments: [
//           (Translation(dx: 5.0, dy: 8.0), Translation(dx: 2.0, dy: 3.0), 3.0 as Dx, 5.0 as Dy),
//           (Translation(dx: 0.0, dy: 0.0), Translation(dx: 1.0, dy: 1.0), -1.0 as Dx, -1.0 as Dy),
//           (Translation(dx: 10.0, dy: 10.0), Translation(dx: 10.0, dy: 10.0), 0.0 as Dx, 0.0 as Dy)
//       ])
//       func subtraction(
//           t1: Translation,
//           t2: Translation,
//           expectedDx: Dx,
//           expectedDy: Dy
//       ) {
//           let result = t1 - t2
//           #expect(result.dx == expectedDx)
//           #expect(result.dy == expectedDy)
//       }
////
//       @Test
//       func `Subtraction with zero`() {
//           let t = Translation(dx: 5.0, dy: 10.0)
//           let result1 = t - .zero
//           let result2 = Translation.zero - t
//           #expect(result1.dx == 5)
//           #expect(result1.dy == 10)
//           #expect(result2.dx == -5)
//           #expect(result2.dy == -10)
//       }
////
//       @Test
//       func `Self-subtraction gives zero`() {
//           let t = Translation(dx: 5.0, dy: 10.0)
//           let result = t - t
//           #expect(result.dx == 0)
//           #expect(result.dy == 0)
//       }
//   }
////
//   // MARK: - Negation Tests
////
//   @Suite
//   struct `Negation` {
//       @Test(arguments: [
//           (Translation(dx: 3.0, dy: 4.0), -3.0 as Dx, -4.0 as Dy),
//           (Translation(dx: -5.0, dy: -10.0), 5.0 as Dx, 10.0 as Dy),
//           (Translation(dx: 0.0, dy: 0.0), 0.0 as Dx, 0.0 as Dy)
//       ])
//       func negation(t: Translation, expectedDx: Dx, expectedDy: Dy) {
//           let result = -t
//           #expect(result.dx == expectedDx)
//           #expect(result.dy == expectedDy)
//       }
////
//       @Test
//       func `Double negation`() {
//           let t = Translation(dx: 3.0, dy: 4.0)
//           let result = -(-t)
//           #expect(result.dx == 3)
//           #expect(result.dy == 4)
//       }
////
//       @Test
//       func `Adding negation gives zero`() {
//           let t = Translation(dx: 5.0, dy: 10.0)
//           let result = t + (-t)
//           #expect(result.dx == 0)
//           #expect(result.dy == 0)
//       }
//   }
////
//   // MARK: - Vector Conversion Tests
////
//   @Suite
//   struct `Vector Conversion` {
//       @Test
//       func `Convert to vector`() {
//           let t = Translation(dx: 3.0, dy: 4.0)
//           let v = t.vector
//           #expect(v.dx == 3)
//           #expect(v.dy == 4)
//       }
////
//       @Test
//       func `Round-trip conversion`() {
//           let original = Translation(dx: 5.0, dy: 10.0)
//           let v = original.vector
//           let roundTripped = Translation(v)
//           #expect(roundTripped.dx == original.dx)
//           #expect(roundTripped.dy == original.dy)
//       }
////
//       @Test
//       func `Zero translation to zero vector`() {
//           let t = Translation.zero
//           let v = t.vector
//           #expect(v.dx == 0)
//           #expect(v.dy == 0)
//       }
//   }
////
//   // MARK: - Equatable Tests
////
//   @Suite
//   struct `Equatable` {
//       @Test
//       func `Translation equality`() {
//           let a = Translation(dx: 3.0, dy: 4.0)
//           let b = Translation(dx: 3.0, dy: 4.0)
//           let c = Translation(dx: 3.0, dy: 5.0)
//           #expect(a == b)
//           #expect(a != c)
//       }
////
//       @Test
//       func `Zero equals zero`() {
//           #expect(Translation.zero == Translation.zero)
//       }
////
//       @Test
//       func `Different translations are not equal`() {
//           let t1 = Translation(dx: 1.0, dy: 2.0)
//           let t2 = Translation(dx: 2.0, dy: 1.0)
//           #expect(t1 != t2)
//       }
//   }
////
//   // MARK: - Hashable Tests
////
//   @Suite
//   struct `Hashable` {
//       @Test
//       func `Equal translations have same hash`() {
//           let a = Translation(dx: 3.0, dy: 4.0)
//           let b = Translation(dx: 3.0, dy: 4.0)
//           #expect(a.hashValue == b.hashValue)
//       }
////
//       @Test
//       func `Can use translation as dictionary key`() {
//           var dict: [Translation: String] = [:]
//           let key = Translation(dx: 1.0, dy: 2.0)
//           dict[key] = "test"
//           #expect(dict[key] == "test")
//       }
//   }
////
//   // MARK: - AdditiveArithmetic-like Operations Tests
////
//   @Suite
//   struct `AdditiveArithmetic Operations` {
//       @Test
//       func `Translation has AdditiveArithmetic-like operations`() {
//           // Translation has +, -, and .zero like AdditiveArithmetic
//           // (but doesn't formally conform to the protocol)
//           let t = Translation(dx: 1.0, dy: 2.0)
//           let sum = t + t
//           let diff = t - t
//           #expect(sum.dx == 2)
//           #expect(diff.dx == 0)
//       }
////
//       @Test
//       func `additive arithmetic zero`() {
//           let z: Translation = .zero
//           #expect(z.dx == 0)
//           #expect(z.dy == 0)
//       }
//   }
//}

// swiftlint:enable comment_spacing
