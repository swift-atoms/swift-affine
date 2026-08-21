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

extension Affine.Discrete.Vector.`Standard Library Integration`.Integration {

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

    @Test
    func `unsafe pointer plus typed offset`() {
        let values: [Int] = [0, 10, 20, 30, 40]
        values.withUnsafeBufferPointer { buf in
            let base = buf.baseAddress!
            let offset: Tagged<Int, Ordinal>.Offset = 2
            let advanced = unsafe base + offset
            #expect(unsafe advanced.pointee == 20)
        }
    }

    @Test
    func `unsafe pointer minus unsafe pointer yields typed offset`() {
        let values: [Int] = [0, 1, 2, 3, 4]
        values.withUnsafeBufferPointer { buf in
            let start = buf.baseAddress!
            let end = unsafe start + Tagged<Int, Ordinal>.Offset(3)
            let distance: Tagged<Int, Ordinal>.Offset = unsafe end - start
            #expect(distance.underlying == Affine.Discrete.Vector(3))
        }
    }

    @Test
    func `unsafe mutable pointer plus typed offset`() {
        var values: [Int] = [0, 10, 20, 30, 40]
        values.withUnsafeMutableBufferPointer { buf in
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
        values.withUnsafeMutableBufferPointer { buf in
            let from = unsafe buf.baseAddress!.advanced(by: 4)
            let offset: Tagged<Int, Ordinal>.Offset = 2
            let backed = unsafe from - offset
            #expect(unsafe backed.pointee == 20)
        }
    }

    @Test
    func `swap with distinct typed indices exchanges trivial pointees`() {
        let buf = UnsafeMutablePointer<Int>.allocate(capacity: 2)
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

extension Affine.Discrete.Vector.`Standard Library Integration`.`Edge Case` {

    @Test
    func `swap with equal typed indices leaves trivial pointee unchanged`() {
        let buf = UnsafeMutablePointer<Int>.allocate(capacity: 1)
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
        let buf = UnsafeMutablePointer<DeinitProbe>.allocate(capacity: 1)
        unsafe buf.initialize(to: DeinitProbe(onDeinit: { deinitCount += 1 }))
        let index: Tagged<DeinitProbe, Ordinal> = .zero
        unsafe buf.swap(index, index)
        unsafe buf.deinitialize(count: 1)
        unsafe buf.deallocate()
        #expect(deinitCount == 1)
    }
}
