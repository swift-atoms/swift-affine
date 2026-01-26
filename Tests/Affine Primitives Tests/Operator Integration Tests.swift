///// Operator Integration Tests.swift
///// Tests verifying type-safe operator interactions across coordinate systems.
////
//import Testing
//@testable import Affine_Primitives_Test_Support
////
///// MARK: - Type Aliases for Brevity
////
//private typealias A = Affine<Double, Void>
//private typealias L = Linear<Double, Void>
//private typealias Point2 = A.Point<2>
//private typealias Vector2 = L.Vector<2>
//private typealias Matrix2x2 = L.Matrix<2, 2>
//private typealias Transform = A.Transform
////
//// MARK: - Approximate Equality Helpers
////
//private func isApprox(_ a: A.X, _ b: A.X, tol: Double = 1e-10) -> Bool {
//    let diff = a - b
//    let tolerance = A.Dx(tol)
//    return diff > -tolerance && diff < tolerance
//}
////
//private func isApprox(_ a: A.Y, _ b: A.Y, tol: Double = 1e-10) -> Bool {
//    let diff = a - b
//    let tolerance = A.Dy(tol)
//    return diff > -tolerance && diff < tolerance
//}
////
//private func isApprox(_ a: L.Dx, _ b: L.Dx, tol: Double = 1e-10) -> Bool {
//    let diff = a - b
//    let tolerance = L.Dx(tol)
//    return diff > -tolerance && diff < tolerance
//}
////
//private func isApprox(_ a: L.Dy, _ b: L.Dy, tol: Double = 1e-10) -> Bool {
//    let diff = a - b
//    let tolerance = L.Dy(tol)
//    return diff > -tolerance && diff < tolerance
//}
////
///// MARK: - Affine Geometry Operators
////
//@Suite
//struct `Affine Geometry - Point/Vector Arithmetic` {
////
//   @Test
//   func `Point - Point yields Vector displacement`() {
//       let p1 = Point2(x: 10, y: 20)
//       let p2 = Point2(x: 3, y: 8)
////
//       let displacement: Vector2 = p1 - p2
////
//       #expect(displacement.dx == 7)
//       #expect(displacement.dy == 12)
//   }
////
//   @Test
//   func `Point + Vector yields translated Point`() {
//       let p = Point2(x: 10, y: 20)
//       let v = Vector2(dx: 5, dy: -3)
////
//       let result: Point2 = p + v
////
//       #expect(result.x == 15)
//       #expect(result.y == 17)
//   }
////
//   @Test
//   func `Point - Vector yields translated Point`() {
//       let p = Point2(x: 10, y: 20)
//       let v = Vector2(dx: 3, dy: 5)
////
//       let result: Point2 = p - v
////
//       #expect(result.x == 7)
//       #expect(result.y == 15)
//   }
////
//   @Test
//   func `Point arithmetic round-trip: (p1 - p2) + p2 == p1`() {
//       let p1 = Point2(x: 100, y: 200)
//       let p2 = Point2(x: 30, y: 50)
////
//       let displacement = p1 - p2
//       let recovered = p2 + displacement
////
//       #expect(recovered.x == p1.x)
//       #expect(recovered.y == p1.y)
//   }
//}
////
///// MARK: - Tagged Coordinate/Displacement Operators
////
//@Suite
//struct `Tagged - Coordinate/Displacement Arithmetic` {
////
//   // X-axis tests
//   @Test
//   func `X + Dx yields X coordinate`() {
//       let x: A.X = 10
//       let dx: A.Dx = 5
////
//       let result: A.X = x + dx
////
//       #expect(result == 15)
//   }
////
//   @Test
//   func `X - X yields Dx displacement`() {
//       let x1: A.X = 10
//       let x2: A.X = 3
////
//       let result: A.Dx = x1 - x2
////
//       #expect(result == 7)
//   }
////
//   @Test
//   func `X - Dx yields X coordinate`() {
//       let x: A.X = 10
//       let dx: A.Dx = 3
////
//       let result: A.X = x - dx
////
//       #expect(result == 7)
//   }
////
//   @Test
//   func `Dx + X yields X coordinate (commutative)`() {
//       let dx: A.Dx = 5
//       let x: A.X = 10
////
//       let result: A.X = dx + x
////
//       #expect(result == 15)
//   }
////
//   // Y-axis tests
//   @Test
//   func `Y + Dy yields Y coordinate`() {
//       let y: A.Y = 20
//       let dy: A.Dy = 8
////
//       let result: A.Y = y + dy
////
//       #expect(result == 28)
//   }
////
//   @Test
//   func `Y - Y yields Dy displacement`() {
//       let y1: A.Y = 20
//       let y2: A.Y = 8
////
//       let result: A.Dy = y1 - y2
////
//       #expect(result == 12)
//   }
////
//   // Displacement + Displacement
//   @Test
//   func `Dx + Dx yields Dx`() {
//       let dx1: A.Dx = 5
//       let dx2: A.Dx = 3
////
//       let result: A.Dx = dx1 + dx2
////
//       #expect(result == 8)
//   }
////
//   @Test
//   func `Dy + Dy yields Dy`() {
//       let dy1: A.Dy = 10
//       let dy2: A.Dy = 7
////
//       let result: A.Dy = dy1 + dy2
////
//       #expect(result == 17)
//   }
//}
////
///// MARK: - Tagged Scalar Operations
////
//@Suite
//struct `Tagged - Scalar Multiplication/Division` {
////
//   @Test
//   func `Dx * Scalar yields Dx`() {
//       let dx: A.Dx = 5
////
//       let result: A.Dx = dx * 3.0
////
//       #expect(result == 15)
//   }
////
//   @Test
//   func `Scalar * Dx yields Dx (commutative)`() {
//       let dx: A.Dx = 5
////
//       let result: A.Dx = 3.0 * dx
////
//       #expect(result == 15)
//   }
////
//   @Test
//   func `Dx / Scalar yields Dx`() {
//       let dx: A.Dx = 15
////
//       let result: A.Dx = dx / 3.0
////
//       #expect(result == 5)
//   }
////
//   @Test
//   func `Dx / Dx yields Scale (ratio)`() {
//       let dx1: A.Dx = 15
//       let dx2: A.Dx = 3
////
//       let ratio = dx1 / dx2
////
//       #expect(ratio.value == 5)
//   }
////
//   @Test
//   func `Dx * Dx yields Area (squared)`() {
//       let dx: A.Dx = 4
////
//       let squared = dx * dx
////
//       #expect(squared == 16)
//   }
//}
////
///// MARK: - Cross-Axis Multiplication
////
//@Suite
//struct `Tagged - Cross-Axis Multiplication` {
////
//   @Test
//   func `Dx * Dy yields Area`() {
//       let width: L.Dx = 10
//       let height: L.Dy = 5
////
//       let area = width * height
////
//       #expect(area == 50)
//   }
////
//   @Test
//   func `Dy * Dx yields Area (commutative)`() {
//       let width: L.Dx = 10
//       let height: L.Dy = 5
////
//       let area = height * width
////
//       #expect(area == 50)
//   }
//}
////
///// MARK: - Magnitude/Coordinate Arithmetic
////
//@Suite
//struct `Tagged - Magnitude/Coordinate Arithmetic` {
////
//   @Test
//   func `X + Magnitude yields X (center + radius pattern)`() {
//       let centerX: A.X = 100
//       let radius: A.Distance = 25
////
//       let right: A.X = centerX + radius
////
//       #expect(right == 125)
//   }
////
//   @Test
//   func `X - Magnitude yields X (center - radius pattern)`() {
//       let centerX: A.X = 100
//       let radius: A.Distance = 25
////
//       let left: A.X = centerX - radius
////
//       #expect(left == 75)
//   }
////
//   @Test
//   func `Magnitude + X yields X (commutative)`() {
//       let radius: A.Distance = 25
//       let centerX: A.X = 100
////
//       let right: A.X = radius + centerX
////
//       #expect(right == 125)
//   }
//}
////
///// MARK: - Linear Vector Operators
////
//@Suite
//struct `Linear Vector - Arithmetic Operations` {
////
//   @Test
//   func `Vector + Vector yields Vector`() {
//       let v1 = Vector2(dx: 3, dy: 4)
//       let v2 = Vector2(dx: 1, dy: 2)
////
//       let result: Vector2 = v1 + v2
////
//       #expect(result.dx == 4)
//       #expect(result.dy == 6)
//   }
////
//   @Test
//   func `Vector - Vector yields Vector`() {
//       let v1 = Vector2(dx: 5, dy: 7)
//       let v2 = Vector2(dx: 2, dy: 3)
////
//       let result: Vector2 = v1 - v2
////
//       #expect(result.dx == 3)
//       #expect(result.dy == 4)
//   }
////
//   @Test
//   func `Vector * Scalar yields Vector`() {
//       let v = Vector2(dx: 3, dy: 4)
////
//       let result: Vector2 = v * 2.0
////
//       #expect(result.dx == 6)
//       #expect(result.dy == 8)
//   }
////
//   @Test
//   func `Scalar * Vector yields Vector (commutative)`() {
//       let v = Vector2(dx: 3, dy: 4)
////
//       let result: Vector2 = 2.0 * v
////
//       #expect(result.dx == 6)
//       #expect(result.dy == 8)
//   }
////
//   @Test
//   func `Vector / Scalar yields Vector`() {
//       let v = Vector2(dx: 6, dy: 8)
////
//       let result: Vector2 = v / 2.0
////
//       #expect(result.dx == 3)
//       #expect(result.dy == 4)
//   }
////
//   @Test
//   func `-Vector yields negated Vector`() {
//       let v = Vector2(dx: 3, dy: -4)
////
//       let result: Vector2 = -v
////
//       #expect(result.dx == -3)
//       #expect(result.dy == 4)
//   }
//}
////
///// MARK: - Linear Matrix Operators
////
//@Suite
//struct `Linear Matrix - Arithmetic Operations` {
////
//   @Test
//   func `Matrix + Matrix yields Matrix`() {
//       let m1 = Matrix2x2(a: 1, b: 2, c: 3, d: 4)
//       let m2 = Matrix2x2(a: 5, b: 6, c: 7, d: 8)
////
//       let result: Matrix2x2 = m1 + m2
////
//       #expect(result.a == 6)
//       #expect(result.b == 8)
//       #expect(result.c == 10)
//       #expect(result.d == 12)
//   }
////
//   @Test
//   func `Matrix - Matrix yields Matrix`() {
//       let m1 = Matrix2x2(a: 5, b: 6, c: 7, d: 8)
//       let m2 = Matrix2x2(a: 1, b: 2, c: 3, d: 4)
////
//       let result: Matrix2x2 = m1 - m2
////
//       #expect(result.a == 4)
//       #expect(result.b == 4)
//       #expect(result.c == 4)
//       #expect(result.d == 4)
//   }
////
//   // Note: Matrix * Scalar and Scalar * Matrix operators are not implemented
////
//   @Test
//   func `Matrix * Vector yields Vector (typed)`() {
//       // Rotation by 90 degrees: [[0, -1], [1, 0]]
//       let rotation = Matrix2x2(a: 0, b: -1, c: 1, d: 0)
//       let v = Vector2(dx: 1, dy: 0)
////
//       let result: Vector2 = rotation * v
////
//       // (1, 0) rotated 90° CCW = (0, 1)
//       #expect(abs(result.dx - 0) < 1e-10)
//       #expect(abs(result.dy - 1) < 1e-10)
//   }
////
//   @Test
//   func `Matrix * Matrix yields Matrix (composition)`() {
//       // Scale by 2
//       let scale = Matrix2x2(a: 2, b: 0, c: 0, d: 2)
//       // Rotation by 90 degrees
//       let rotation = Matrix2x2(a: 0, b: -1, c: 1, d: 0)
////
//       // scale * rotation: first rotate, then scale
//       let composed = scale.multiplied(by: rotation)
////
//       // Apply to (1, 0): rotate to (0, 1), scale to (0, 2)
//       let v = Vector2(dx: 1, dy: 0)
//       let result = composed * v
////
//       #expect(abs(result.dx - 0) < 1e-10)
//       #expect(abs(result.dy - 2) < 1e-10)
//   }
//}
////
///// MARK: - Translation Operators
////
//@Suite
//struct `Affine Translation - Arithmetic Operations` {
////
//   @Test
//   func `Translation + Translation yields Translation`() {
//       let t1 = A.Translation(dx: 10, dy: 20)
//       let t2 = A.Translation(dx: 5, dy: 8)
////
//       let result: A.Translation = t1 + t2
////
//       #expect(result.dx == 15)
//       #expect(result.dy == 28)
//   }
////
//   @Test
//   func `Translation - Translation yields Translation`() {
//       let t1 = A.Translation(dx: 10, dy: 20)
//       let t2 = A.Translation(dx: 3, dy: 5)
////
//       let result: A.Translation = t1 - t2
////
//       #expect(result.dx == 7)
//       #expect(result.dy == 15)
//   }
////
//   @Test
//   func `Translation.vector returns typed Vector2`() {
//       let t = A.Translation(dx: 10, dy: 20)
////
//       let v: Vector2 = t.vector
////
//       #expect(v.dx == 10)
//       #expect(v.dy == 20)
//   }
//}
////
///// MARK: - Transform Composition
////
//@Suite
//struct `Affine Transform - Composition Operators` {
////
//   @Test
//   func `Transform composition follows right-to-left execution order`() {
//       // scale ∘ translate: translate first, then scale
//       let translate = Transform.translation(dx: 10, dy: 0)
//       let scale = Transform.scale(2)
////
//       let composed = Transform.concatenating(scale, translate)
//       let p = Point2(x: 1, y: 0)
//       let result = Transform.apply(composed, to: p)
////
//       // translate: (1, 0) -> (11, 0)
//       // scale: (11, 0) -> (22, 0)
//       #expect(isApprox(result.x, A.X(22)))
//       #expect(isApprox(result.y, A.Y(0)))
//   }
////
//   @Test
//   func `Transform inverse undoes transformation`() {
//       let t = Transform.rotation(Degree(45)).scaled(by: 2).translated(dx: 100, dy: 50)
//       guard let inv = Transform.inverted(t) else {
//           Issue.record("Transform should be invertible")
//           return
//       }
////
//       let p = Point2(x: 10, y: 20)
//       let transformed = Transform.apply(t, to: p)
//       let recovered = Transform.apply(inv, to: transformed)
////
//       #expect(abs(recovered.x - p.x) < 1e-10)
//       #expect(abs(recovered.y - p.y) < 1e-10)
//   }
////
//   @Test
//   func `Transform.apply to Vector ignores translation`() {
//       let t = Transform.translation(dx: 100, dy: 100).scaled(by: 2)
//       let v = Vector2(dx: 3, dy: 4)
////
//       let result = Transform.apply(t, to: v)
////
//       // Vectors are only affected by linear transformation, not translation
//       #expect(abs(result.dx - 6) < 1e-10)
//       #expect(abs(result.dy - 8) < 1e-10)
//   }
//}
////
//// Note: Compound assignment operators (+=, -=, *=, /=) are not implemented for Tagged types
////
///// MARK: - Algebraic Properties
////
//@Suite
//struct `Algebraic Properties` {
////
//   @Test
//   func `Vector addition is commutative`() {
//       let v1 = Vector2(dx: 3, dy: 4)
//       let v2 = Vector2(dx: 1, dy: 2)
////
//       let r1 = v1 + v2
//       let r2 = v2 + v1
////
//       #expect(r1 == r2)
//   }
////
//   @Test
//   func `Vector addition is associative`() {
//       let v1 = Vector2(dx: 1, dy: 2)
//       let v2 = Vector2(dx: 3, dy: 4)
//       let v3 = Vector2(dx: 5, dy: 6)
////
//       let r1 = (v1 + v2) + v3
//       let r2 = v1 + (v2 + v3)
////
//       #expect(r1 == r2)
//   }
////
//   @Test
//   func `Vector zero is identity for addition`() {
//       let v = Vector2(dx: 3, dy: 4)
////
//       let r1 = v + .zero
//       let r2 = Vector2.zero + v
////
//       #expect(r1 == v)
//       #expect(r2 == v)
//   }
////
//   @Test
//   func `Scalar multiplication distributes over vector addition`() {
//       let v1 = Vector2(dx: 3, dy: 4)
//       let v2 = Vector2(dx: 1, dy: 2)
//       let s = Scale<1, Double>(2)
////
//       // Use Vector * Scale (not Scalar * Vector)
//       let r1 = (v1 + v2) * s
//       let r2 = (v1 * s) + (v2 * s)
////
//       #expect(r1 == r2)
//   }
////
//   @Test
//   func `Transform identity leaves points unchanged`() {
//       let p = Point2(x: 42, y: 17)
////
//       let result = Transform.apply(.identity, to: p)
////
//       #expect(result == p)
//   }
////
//   @Test
//   func `Transform composition is associative`() {
//       let t1 = Transform.translation(dx: 10, dy: 20)
//       let t2 = Transform.scale(2)
//       let t3 = Transform.rotation(Degree(30))
////
//       let r1 = Transform.concatenating(Transform.concatenating(t1, t2), t3)
//       let r2 = Transform.concatenating(t1, Transform.concatenating(t2, t3))
////
//       let p = Point2(x: 1, y: 1)
//       let p1 = Transform.apply(r1, to: p)
//       let p2 = Transform.apply(r2, to: p)
////
//       #expect(abs(p1.x - p2.x) < 1e-10)
//       #expect(abs(p1.y - p2.y) < 1e-10)
//   }
//}
////
///// MARK: - Type Safety Verification
////
//@Suite
//struct `Type Safety - Operator Return Types` {
////
//   @Test
//   func `All coordinate/displacement operators preserve types correctly`() {
//       // These assignments verify compile-time type correctness
//       let x: A.X = 10
//       let dx: A.Dx = 5
////
//       // Coordinate + Displacement = Coordinate
//       let _: A.X = x + dx
//       let _: A.X = dx + x
////
//       // Coordinate - Displacement = Coordinate
//       let _: A.X = x - dx
////
//       // Coordinate - Coordinate = Displacement
//       let x2: A.X = 3
//       let _: A.Dx = x - x2
////
//       // Displacement + Displacement = Displacement
//       let _: A.Dx = dx + dx
////
//       // Displacement * Scalar = Displacement
//       let _: A.Dx = dx * 2.0
//       let _: A.Dx = 2.0 * dx
////
//       // Displacement / Scalar = Displacement
//       let _: A.Dx = dx / 2.0
////
//       // Displacement / Displacement = Scale (ratio)
//       let _: Scale<1, Double> = dx / dx
////
//       // Displacement * Displacement = Area (squared)
//       let _: A.Area = dx * dx
////
//       // Point - Point = Vector
//       let p1 = Point2(x: 10, y: 20)
//       let p2 = Point2(x: 5, y: 10)
//       let _: Vector2 = p1 - p2
////
//       // Point + Vector = Point
//       let v = Vector2(dx: 1, dy: 2)
//       let _: Point2 = p1 + v
////
//       // Point - Vector = Point
//       let _: Point2 = p1 - v
////
//       // If we got here, all type assignments compiled correctly
//       // (this test is primarily about compile-time type checking)
//       #expect(Bool(true), "All type assignments compiled correctly")
//   }
//}
