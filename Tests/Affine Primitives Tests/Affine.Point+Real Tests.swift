// TODO post-launch: restore for full coverage.
//
// File covers a previous-generation `Affine.Point` real-numeric extension
// (polar coordinates, rotation). Out of scope for the 0.1.0 discrete surface;
// belongs in a future continuous-affine package.

// swiftlint:disable comment_spacing

///// Affine.Point+Real Tests.swift
///// Tests for Affine.Point+Real.swift polar coordinates and rotation
////
//import Testing
//@testable import Affine_Primitives_Test_Support
////
//@Suite
//struct `Affine.Point+Real Tests` {
//   typealias A = Affine<Double, Void>
//   typealias L = Linear<Double, Void>
//   typealias Point2 = A.Point<2>
////
//   static func isApprox(_ a: A.X, _ b: A.X, tol: Double = 1e-10) -> Bool {
//       let diff = a - b
//       let tolerance = A.Dx(tol)
//       return diff > -tolerance && diff < tolerance
//   }
////
//   static func isApprox(_ a: A.Y, _ b: A.Y, tol: Double = 1e-10) -> Bool {
//       let diff = a - b
//       let tolerance = A.Dy(tol)
//       return diff > -tolerance && diff < tolerance
//   }
////
//   static func isApprox(_ a: A.Distance, _ b: A.Distance, tol: Double = 1e-10) -> Bool {
//       let diff = a - b
//       let tolerance = A.Distance(tol)
//       return diff > -tolerance && diff < tolerance
//   }
////
//   static func isApprox(_ a: Degree<Double>, _ b: Degree<Double>, tol: Double = 1e-10) -> Bool {
//       let diff = a - b
//       let tolerance = Degree<Double>(tol)
//       return diff > -tolerance && diff < tolerance
//   }
////
//   // MARK: - Polar Coordinate Tests
////
//   @Suite
//   struct `Polar Coordinates` {
//       @Test
//       func `Create point from polar coordinates (0 degrees)`() {
//           let p = Point2.polar(radius: .init(5.0), angle: Degree(0).radians)
//           #expect(isApprox(p.x, A.X(5)))
//           #expect(isApprox(p.y, A.Y(0)))
//       }
////
//       @Test
//       func `Create point from polar coordinates (90 degrees)`() {
//           let p = Point2.polar(radius: .init(5.0), angle: Degree(90).radians)
//           #expect(isApprox(p.x, A.X(0)))
//           #expect(isApprox(p.y, A.Y(5)))
//       }
////
//       @Test
//       func `Create point from polar coordinates (180 degrees)`() {
//           let p = Point2.polar(radius: .init(5.0), angle: Degree(180).radians)
//           #expect(isApprox(p.x, A.X(-5)))
//           #expect(isApprox(p.y, A.Y(0)))
//       }
////
//       @Test
//       func `Create point from polar coordinates (270 degrees)`() {
//           let p = Point2.polar(radius: .init(5.0), angle: Degree(270).radians)
//           #expect(isApprox(p.x, A.X(0)))
//           #expect(isApprox(p.y, A.Y(-5)))
//       }
////
//       @Test
//       func `Create point from polar coordinates (45 degrees)`() {
//           let p = Point2.polar(radius: .init(1.0), angle: Degree(45).radians)
//           let expected = A.X(1.0 / sqrt(2.0))
//           #expect(isApprox(p.x, expected))
//           #expect(isApprox(p.y, A.Y(expected.rawValue)))
//       }
////
//       @Test
//       func `Angle of point at (1, 0)`() {
//           let p = Point2(x: 1, y: 0)
//           let angle = p.angle
//           #expect(isApprox(angle.degrees, Degree(0)))
//       }
////
//       @Test
//       func `Angle of point at (0, 1)`() {
//           let p = Point2(x: 0, y: 1)
//           let angle = p.angle
//           #expect(isApprox(angle.degrees, Degree(90)))
//       }
////
//       @Test
//       func `Angle of point at (-1, 0)`() {
//           let p = Point2(x: -1, y: 0)
//           let angle = p.angle
//           // Angle could be +180 or -180, check absolute value
//           #expect(isApprox(abs(angle.degrees), Degree(180)))
//       }
////
//       @Test
//       func `Angle of point at (0, -1)`() {
//           let p = Point2(x: 0, y: -1)
//           let angle = p.angle
//           #expect(isApprox(angle.degrees, Degree(-90)))
//       }
////
//       @Test
//       func `Radius of point`() {
//           let p = Point2(x: 3, y: 4)
//           #expect(p.radius == 5)
//       }
////
//       @Test
//       func `Radius of origin`() {
//           let p = Point2.zero
//           #expect(p.radius == 0)
//       }
////
//       @Test(arguments: [
//           (5.0, 0.0),
//           (5.0, 45.0),
//           (5.0, 90.0),
//           (3.0, 135.0),
//           (7.0, 270.0)
//       ])
//       func polarRoundTrip(radius: Double, deg: Double) {
//           let angle = Degree(deg).radians
//           let p = Point2.polar(radius: .init(radius), angle: angle)
//           #expect(isApprox(p.radius, A.Distance(radius)))
////
//           // Normalize angles for comparison (need raw values for complex normalization logic)
//           let angleDiff = abs(p.angle.degrees.rawValue - deg)
//           let normalizedDiff = min(angleDiff, abs(angleDiff - 360), abs(angleDiff + 360))
//           #expect(normalizedDiff < 1e-8)
//       }
//   }
////
//   // MARK: - Rotation Tests
////
//   @Suite
//   struct `Rotation` {
//       @Test
//       func `Rotate by 90 degrees around origin (radians)`() {
//           let p = Point2(x: 1, y: 0)
//           let rotated = Point2.rotated(p, by: Degree(90))
//           #expect(isApprox(rotated.x, A.X(0)))
//           #expect(isApprox(rotated.y, A.Y(1)))
//       }
////
//       @Test
//       func `Rotate by 90 degrees around origin instance method (radians)`() {
//           let p = Point2(x: 1, y: 0)
//           let rotated = p.rotated(by: Degree(90))
//           #expect(isApprox(rotated.x, A.X(0)))
//           #expect(isApprox(rotated.y, A.Y(1)))
//       }
////
//       @Test
//       func `Rotate by 180 degrees around origin`() {
//           let p = Point2(x: 1, y: 0)
//           let rotated = Point2.rotated(p, by: Degree(180))
//           #expect(isApprox(rotated.x, A.X(-1)))
//           #expect(isApprox(rotated.y, A.Y(0)))
//       }
////
//       @Test
//       func `Rotate by 270 degrees around origin`() {
//           let p = Point2(x: 1, y: 0)
//           let rotated = Point2.rotated(p, by: Degree(270))
//           #expect(isApprox(rotated.x, A.X(0)))
//           #expect(isApprox(rotated.y, A.Y(-1)))
//       }
////
//       @Test
//       func `Rotate by 45 degrees around origin`() {
//           let p = Point2(x: 1, y: 0)
//           let rotated = Point2.rotated(p, by: Degree(45))
//           let expected = A.X(1.0 / sqrt(2.0))
//           #expect(isApprox(rotated.x, expected))
//           #expect(isApprox(rotated.y, A.Y(expected.rawValue)))
//       }
////
//       @Test
//       func `Rotate by degrees (90 degrees)`() {
//           let p = Point2(x: 1, y: 0)
//           let rotated = Point2.rotated(p, by: Degree(90))
//           #expect(isApprox(rotated.x, A.X(0)))
//           #expect(isApprox(rotated.y, A.Y(1)))
//       }
////
//       @Test
//       func `Rotate by degrees instance method`() {
//           let p = Point2(x: 1, y: 0)
//           let rotated = p.rotated(by: Degree(90))
//           #expect(isApprox(rotated.x, A.X(0)))
//           #expect(isApprox(rotated.y, A.Y(1)))
//       }
////
//       @Test(arguments: [
//           (Point2(x: 3, y: 4), 45.0),
//           (Point2(x: 1, y: 1), 90.0),
//           (Point2(x: 5, y: 0), 180.0),
//           (Point2(x: -2, y: 3), 270.0)
//       ])
//       func rotationPreservesDistance(p: Point2, degrees: Double) {
//           let rotated = Point2.rotated(p, by: Degree(degrees))
//           let originalDist = p.distance(to: .zero)
//           let rotatedDist = rotated.distance(to: .zero)
//           #expect(abs(originalDist - rotatedDist) < 1e-10)
//       }
////
//       @Test
//       func `Rotate around custom center (90 degrees)`() {
//           let center = Point2(x: 1, y: 1)
//           let p = Point2(x: 2, y: 1)
//           let rotated = Point2.rotated(p, by: Degree(90), around: center)
//           #expect(isApprox(rotated.x, A.X(1)))
//           #expect(isApprox(rotated.y, A.Y(2)))
//       }
////
//       @Test
//       func `Rotate around custom center instance method`() {
//           let center = Point2(x: 1, y: 1)
//           let p = Point2(x: 2, y: 1)
//           let rotated = p.rotated(by: Degree(90), around: center)
//           #expect(isApprox(rotated.x, A.X(1)))
//           #expect(isApprox(rotated.y, A.Y(2)))
//       }
////
//       @Test
//       func `Rotate around custom center (180 degrees)`() {
//           let center = Point2(x: 0, y: 0)
//           let p = Point2(x: 1, y: 1)
//           let rotated = Point2.rotated(p, by: Degree(180), around: center)
//           #expect(isApprox(rotated.x, A.X(-1)))
//           #expect(isApprox(rotated.y, A.Y(-1)))
//       }
////
//       @Test(arguments: [
//           (Point2(x: 5, y: 5), Point2(x: 8, y: 5), 45.0),
//           (Point2(x: 0, y: 0), Point2(x: 3, y: 4), 90.0),
//           (Point2(x: 1, y: 1), Point2(x: 1, y: 2), 180.0)
//       ])
//       func rotateAroundCenterPreservesDistance(center: Point2, p: Point2, degrees: Double) {
//           let rotated = Point2.rotated(p, by: Degree(degrees), around: center)
//           let originalDist = p.distance(to: center)
//           let rotatedDist = rotated.distance(to: center)
//           #expect(abs(originalDist - rotatedDist) < 1e-10)
//       }
////
//       @Test
//       func `Rotate around custom center by degrees (90 degrees)`() {
//           let center = Point2(x: 1, y: 1)
//           let p = Point2(x: 2, y: 1)
//           let rotated = Point2.rotated(p, by: Degree(90), around: center)
//           #expect(isApprox(rotated.x, A.X(1)))
//           #expect(isApprox(rotated.y, A.Y(2)))
//       }
////
//       @Test
//       func `Rotate around custom center by degrees instance method`() {
//           let center = Point2(x: 1, y: 1)
//           let p = Point2(x: 2, y: 1)
//           let rotated = p.rotated(by: Degree(90), around: center)
//           #expect(isApprox(rotated.x, A.X(1)))
//           #expect(isApprox(rotated.y, A.Y(2)))
//       }
////
//       @Test
//       func `Multiple rotations compose correctly`() {
//           let p = Point2(x: 1, y: 0)
//           let rotated1 = Point2.rotated(p, by: Degree(45))
//           let rotated2 = Point2.rotated(rotated1, by: Degree(45))
//           let rotatedDirect = Point2.rotated(p, by: Degree(90))
//           #expect(isApprox(rotated2.x, rotatedDirect.x))
//           #expect(isApprox(rotated2.y, rotatedDirect.y))
//       }
//   }
//}

// swiftlint:enable comment_spacing
