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

@Suite
struct AffineSLITests {
    enum Element {}

    typealias Offset = Tagged<Element, Ordinal>.Offset

    // MARK: - Int(bitPattern:) — bare Vector

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

    // MARK: - Int(bitPattern:) — Tagged offset

    @Test
    func `int bit pattern from tagged offset positive`() {
        let offset: Offset = 7
        #expect(Int(bitPattern: offset) == 7)
    }

    @Test
    func `int bit pattern from tagged offset negative`() {
        let offset: Offset = -7
        #expect(Int(bitPattern: offset) == -7)
    }

    // MARK: - RandomAccessCollection.index(_:offsetBy:)

    @Test
    func `random access collection index by typed offset`() {
        let array = [10, 20, 30, 40, 50]
        let offset: Offset = 2
        let index = array.index(array.startIndex, offsetBy: offset)
        #expect(array[index] == 30)
    }

    @Test
    func `random access collection index by zero offset`() {
        let array = [10, 20, 30]
        let offset: Offset = .zero
        let index = array.index(array.startIndex, offsetBy: offset)
        #expect(index == array.startIndex)
    }

    // MARK: - UnsafePointer arithmetic

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

    // MARK: - UnsafeMutablePointer arithmetic

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
}
