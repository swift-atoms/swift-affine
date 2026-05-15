// TODO post-launch: restore for full coverage.
//
// File covers the previous-generation `Affine<T, Tag>.{X, Y, Z, Dx, Dy, Dz}`
// generic-coordinate API (continuous-affine geometry over numeric T). The
// current 0.1.0 API is `Affine.Discrete.Vector` / `Affine.Discrete.Ratio<From, To>`
// / `Tagged<Tag, Ordinal>.Offset` (one-dimensional discrete-affine, not generic
// over T). Smoke coverage for the current surface lives at
// `AffineVectorTests.swift` and `OrdinalAffineArithmeticTests.swift`.
// Institutional knowledge in the test rationale below is preserved for a
// future cycle that brings continuous-affine types back into the surface.

// swiftlint:disable comment_spacing

///// Affine Tests.swift
///// Tests for Affine.swift coordinate type aliases
////
//import Testing
//@testable import Affine_Primitives_Test_Support
////
//@Suite
//struct `Affine Coordinate Tests` {
//   typealias X = Affine<Double, Void>.X
//   typealias Y = Affine<Double, Void>.Y
//   typealias Z = Affine<Double, Void>.Z
//   typealias Dx = Affine<Double, Void>.Dx
//   typealias Dy = Affine<Double, Void>.Dy
//   typealias Dz = Affine<Double, Void>.Dz
////
//   // MARK: - X Coordinate Tests
////
//   @Suite
//   struct `X Coordinate` {
//       @Test
//       func `X construction`() {
//           let x = X(3.0)
//           #expect(x == 3.0)
//       }
////
//       @Test
//       func `X from integer literal`() {
//           let x: X = 5
//           #expect(x == 5.0)
//       }
////
//       @Test
//       func `X from float literal`() {
//           let x: X = 3.14
//           #expect(x == 3.14)
//       }
////
//       @Test
//       func `X zero`() {
//           let x = X.zero
//           #expect(x == 0)
//       }
////
//       @Test
//       func `X subtraction returns Dx`() {
//           let a = X(7)
//           let b = X(4)
//           let diff: Dx = a - b
//           #expect(diff == 3)
//       }
////
//       @Test
//       func `X comparison`() {
//           let a = X(3)
//           let b = X(5)
//           #expect(a < b)
//           #expect(b > a)
//           #expect(a <= a)
//       }
////
//       @Test
//       func `X equality`() {
//           let a = X(3)
//           let b = X(3)
//           let c = X(4)
//           #expect(a == b)
//           #expect(a != c)
//       }
////
//       @Test
//       func `X map`() throws {
//           let x = X(3.0)
//           let doubled: Affine<Int, Void>.X = x.map { Int($0 * 2) }
//           #expect(doubled == 6)
//       }
//   }
////
//   // MARK: - Y Coordinate Tests
////
//   @Suite
//   struct `Y Coordinate` {
//       @Test
//       func `Y construction`() {
//           let y = Y(4.0)
//           #expect(y == 4.0)
//       }
////
//       @Test
//       func `Y from integer literal`() {
//           let y: Y = 5
//           #expect(y == 5.0)
//       }
////
//       @Test
//       func `Y from float literal`() {
//           let y: Y = 2.71
//           #expect(y == 2.71)
//       }
////
//       @Test
//       func `Y zero`() {
//           let y = Y.zero
//           #expect(y == 0)
//       }
////
//       @Test
//       func `Y subtraction returns Dy`() {
//           let a = Y(7)
//           let b = Y(4)
//           let diff: Dy = a - b
//           #expect(diff == 3)
//       }
////
//       @Test
//       func `Y comparison`() {
//           let a = Y(3)
//           let b = Y(5)
//           #expect(a < b)
//           #expect(b > a)
//           #expect(a <= a)
//       }
////
//       @Test
//       func `Y equality`() {
//           let a = Y(3)
//           let b = Y(3)
//           let c = Y(4)
//           #expect(a == b)
//           #expect(a != c)
//       }
////
//       @Test
//       func `Y map`() throws {
//           let y = Y(4.0)
//           let doubled: Affine<Int, Void>.Y = y.map { Int($0 * 2) }
//           #expect(doubled == 8)
//       }
//   }
////
//   // MARK: - Z Coordinate Tests
////
//   @Suite
//   struct `Z Coordinate` {
//       @Test
//       func `Z construction`() {
//           let z = Z(5.0)
//           #expect(z == 5.0)
//       }
////
//       @Test
//       func `Z zero`() {
//           let z = Z.zero
//           #expect(z == 0)
//       }
////
//       @Test
//       func `z equality`() {
//           let a = Z(3)
//           let b = Z(3)
//           let c = Z(4)
//           #expect(a == b)
//           #expect(a != c)
//       }
//   }
//}

// swiftlint:enable comment_spacing
