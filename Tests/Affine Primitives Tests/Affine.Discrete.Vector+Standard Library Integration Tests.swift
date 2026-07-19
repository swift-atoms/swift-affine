import Affine_Primitives_Test_Support
import Testing

@testable import Affine_Primitives

private let isLinux: Bool = {
    #if os(Linux)
        true
    #else
        false
    #endif
}()

private enum Element {}

/// A class-bearing pointee used to observe `UnsafeMutablePointer.swap(_:_:)`'s
/// lifecycle behavior. Reports its deinitialization through a closure rather
/// than shared static state, so it stays safe under parallel test execution.
private final class DeinitProbe {
    private let onDeinit: () -> Void
    init(onDeinit: @escaping () -> Void) { self.onDeinit = onDeinit }
    deinit { onDeinit() }
}

extension Affine.Discrete.Vector {
    @Suite
    struct `Standard Library Integration` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

// MARK: - Integration
//
// Whole-file Integration scope: every test exercises an Affine primitive
// at a stdlib boundary (`Int(bitPattern:)`, `RandomAccessCollection.index`,
// pointer arithmetic). Unit / Edge Case / Performance sub-suites declared
// to satisfy the canonical 4-sub-suite shape; they are intentionally
// empty here per the file's stdlib-integration scope.

extension Affine.Discrete.Vector.`Standard Library Integration`.Integration {

    // MARK: Int(bitPattern:) — bare Vector

    @Test
    func `int bit pattern from vector positive`() {
        let v = Affine.Discrete.Vector(5)
        #expect(Int(bitPattern: v) == 5)
    }

    @Test
    func `int bit pattern from vector negative`() {
        let v = Affine.Discrete.Vector(-3)
        #expect(Int(bitPattern: v) == -3)
    }

    @Test
    func `int bit pattern from vector zero`() {
        let v = Affine.Discrete.Vector.zero
        #expect(Int(bitPattern: v) == 0)
    }

    // MARK: Int(bitPattern:) — Tagged offset

    @Test
    func `int bit pattern from tagged offset positive`() {
        let offset: Tagged<Element, Ordinal>.Offset = 7
        #expect(Int(bitPattern: offset) == 7)
    }

    @Test
    func `int bit pattern from tagged offset negative`() {
        let offset: Tagged<Element, Ordinal>.Offset = -7
        #expect(Int(bitPattern: offset) == -7)
    }

    // MARK: RandomAccessCollection.index(_:offsetBy:)

    @Test
    func `random access collection index by typed offset`() {
        let array = [10, 20, 30, 40, 50]
        let offset: Tagged<Element, Ordinal>.Offset = 2
        let index = array.index(array.startIndex, offsetBy: offset)
        #expect(array[index] == 30)
    }

    @Test
    func `random access collection index by zero offset`() {
        let array = [10, 20, 30]
        let offset: Tagged<Element, Ordinal>.Offset = .zero
        let index = array.index(array.startIndex, offsetBy: offset)
        #expect(index == array.startIndex)
    }

    // MARK: UnsafePointer arithmetic

    @Test
    func `unsafe pointer plus typed offset`() {
        let values: [Int] = [0, 10, 20, 30, 40]
        unsafe values.withUnsafeBufferPointer { buf in
            let base = buf.baseAddress!
            let offset: Tagged<Int, Ordinal>.Offset = 2
            let advanced = unsafe base + offset
            #expect(unsafe advanced.pointee == 20)
        }
    }

    @Test
    func `unsafe pointer minus unsafe pointer yields typed offset`() {
        let values: [Int] = [0, 1, 2, 3, 4]
        unsafe values.withUnsafeBufferPointer { buf in
            let start = buf.baseAddress!
            let end = unsafe start + Tagged<Int, Ordinal>.Offset(3)
            let distance: Tagged<Int, Ordinal>.Offset = unsafe end - start
            #expect(distance.underlying == Affine.Discrete.Vector(3))
        }
    }

    // MARK: UnsafeMutablePointer arithmetic

    @Test
    func `unsafe mutable pointer plus typed offset`() {
        var values: [Int] = [0, 10, 20, 30, 40]
        unsafe values.withUnsafeMutableBufferPointer { buf in
            let base = buf.baseAddress!
            let offset: Tagged<Int, Ordinal>.Offset = 3
            let advanced = unsafe base + offset
            #expect(unsafe advanced.pointee == 30)
        }
    }

    @Test(
        .disabled(if: isLinux, "Linux release-mode pointer arithmetic miscompile"),
        .bug(
            "https://github.com/swiftlang/swift/issues/77558",
            "swiftlang/swift#77558 — fixed on 6.4-dev nightly-main; confirmation comment: https://github.com/swiftlang/swift/issues/77558#issuecomment-4425028051"
        ),
        .bug(
            "https://github.com/swift-institute/Issues/tree/main/swift-issue-pointer-arithmetic-linux-miscompile",
            "In-tree harness + investigation arc"
        )
    )
    func `unsafe mutable pointer minus typed offset`() {
        var values: [Int] = [0, 10, 20, 30, 40]
        unsafe values.withUnsafeMutableBufferPointer { buf in
            let from = unsafe buf.baseAddress!.advanced(by: 4)
            let offset: Tagged<Int, Ordinal>.Offset = 2
            let backed = unsafe from - offset
            #expect(unsafe backed.pointee == 20)
        }
    }

    // MARK: UnsafeMutablePointer.swap(_:_:) — sanity (distinct indices)

    @Test
    func `swap with distinct typed indices exchanges trivial pointees`() {
        let buf = unsafe UnsafeMutablePointer<Int>.allocate(capacity: 2)
        defer {
            unsafe buf.deinitialize(count: 2)
            unsafe buf.deallocate()
        }
        unsafe buf.initialize(to: 1)
        unsafe (buf + 1).initialize(to: 2)
        let i: Tagged<Int, Ordinal> = .zero
        let j: Tagged<Int, Ordinal> = 1
        unsafe buf.swap(i, j)
        #expect(unsafe buf.pointee == 2)
        #expect(unsafe (buf + 1).pointee == 1)
    }
}

// MARK: - Edge Case

extension Affine.Discrete.Vector.`Standard Library Integration`.`Edge Case` {

    // MARK: UnsafeMutablePointer.swap(_:_:) — equal-index regression (F-001)
    //
    // `swap(i, i)` must be a no-op. Without an equal-address guard, the
    // move-based implementation reads back memory it just declared
    // "moved from" via `.move()`, then initializes it twice — a documented
    // undefined-behavior pattern (the same one `MutableCollection.swapAt(_:_:)`
    // guards against with its own `i != j` check).

    @Test
    func `swap with equal typed indices leaves trivial pointee unchanged`() {
        let buf = unsafe UnsafeMutablePointer<Int>.allocate(capacity: 1)
        defer {
            unsafe buf.deinitialize(count: 1)
            unsafe buf.deallocate()
        }
        unsafe buf.initialize(to: 42)
        let index: Tagged<Int, Ordinal> = .zero
        unsafe buf.swap(index, index)
        #expect(unsafe buf.pointee == 42)
    }

    @Test
    func `swap with equal typed indices deinitializes class pointee exactly once`() {
        var deinitCount = 0
        let buf = unsafe UnsafeMutablePointer<DeinitProbe>.allocate(capacity: 1)
        unsafe buf.initialize(to: DeinitProbe(onDeinit: { deinitCount += 1 }))
        let index: Tagged<DeinitProbe, Ordinal> = .zero
        unsafe buf.swap(index, index)
        unsafe buf.deinitialize(count: 1)
        unsafe buf.deallocate()
        #expect(deinitCount == 1)
    }
}
