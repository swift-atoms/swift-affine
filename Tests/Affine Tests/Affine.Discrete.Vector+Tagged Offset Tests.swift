import Affine_Test_Support
import Testing

@testable import Affine
internal import Cardinal_Error

private enum Element {}
private enum Other {}

extension Affine.Discrete.Vector {
    @Suite
    struct `Tagged Offset` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

extension Affine.Discrete.Vector.`Tagged Offset`.Unit {

    @Test
    func `offset is tagged vector`() {
        let offset: Tagged<Element, Ordinal>.Offset = 3

        let taggedVector: Tagged<Element, Affine.Discrete.Vector> = offset
        #expect(taggedVector.underlying == Affine.Discrete.Vector(3))
    }

    @Test
    func `construction from int`() {
        let offset = Tagged<Element, Ordinal>.Offset(5)
        #expect(offset.underlying == Affine.Discrete.Vector(5))
    }

    @Test
    func `construction from negative int`() {
        let offset = Tagged<Element, Ordinal>.Offset(-3)
        #expect(offset.underlying == Affine.Discrete.Vector(-3))
    }

    @Test
    func `construction from tagged cardinal`() {
        let count: Tagged<Element, Cardinal> = 7
        let offset = Tagged<Element, Affine.Discrete.Vector>(count)
        #expect(offset.underlying == Affine.Discrete.Vector(7))
    }

    @Test
    func `construction from ordinal protocol`() throws(Affine.Discrete.Vector.Error) {
        let position = Ordinal(UInt(5))
        let offset = try Tagged<Element, Affine.Discrete.Vector>(position)
        #expect(offset.underlying == Affine.Discrete.Vector(5))
    }

    @Test
    func `construction from zero`() {
        let position = Ordinal(UInt(5))
        let offset = Tagged<Element, Affine.Discrete.Vector>(fromZero: position)
        #expect(offset.underlying == Affine.Discrete.Vector(5))
    }

    @Test
    func `construction from integer literal`() {
        let offset: Tagged<Element, Ordinal>.Offset = 3
        #expect(offset.underlying == Affine.Discrete.Vector(3))
    }

    @Test
    func `zero constant`() {
        let offset: Tagged<Element, Ordinal>.Offset = .zero
        #expect(offset.underlying == Affine.Discrete.Vector(0))
    }

    @Test
    func `one constant`() {
        let offset: Tagged<Element, Ordinal>.Offset = .one
        #expect(offset.underlying == Affine.Discrete.Vector(1))
    }

    @Test
    func `addition on tagged`() {
        let a: Tagged<Element, Ordinal>.Offset = 3
        let b: Tagged<Element, Ordinal>.Offset = 4
        let sum = a + b
        #expect(sum.underlying == Affine.Discrete.Vector(7))
    }

    @Test
    func `subtraction on tagged`() {
        let a: Tagged<Element, Ordinal>.Offset = 5
        let b: Tagged<Element, Ordinal>.Offset = 2
        let diff = a - b
        #expect(diff.underlying == Affine.Discrete.Vector(3))
    }

    @Test
    func `compound addition on tagged`() {
        var a: Tagged<Element, Ordinal>.Offset = 5
        a += Tagged<Element, Ordinal>.Offset(3)
        #expect(a.underlying == Affine.Discrete.Vector(8))
    }

    @Test
    func `compound subtraction on tagged`() {
        var a: Tagged<Element, Ordinal>.Offset = 5
        a -= Tagged<Element, Ordinal>.Offset(3)
        #expect(a.underlying == Affine.Discrete.Vector(2))
    }

    @Test
    func `unary minus on tagged`() {
        let v: Tagged<Element, Ordinal>.Offset = 5
        let negated: Tagged<Element, Ordinal>.Offset = -v
        #expect(negated.underlying == Affine.Discrete.Vector(-5))
    }

    @Test
    func `magnitude of positive tagged offset`() {
        let offset: Tagged<Element, Ordinal>.Offset = 5
        let magnitude: Tagged<Element, Cardinal> = offset.magnitude
        #expect(magnitude.underlying == Cardinal(5))
    }

    @Test
    func `magnitude of negative tagged offset`() {
        let offset: Tagged<Element, Ordinal>.Offset = -5
        let magnitude: Tagged<Element, Cardinal> = offset.magnitude
        #expect(magnitude.underlying == Cardinal(5))
    }

    @Test
    func `tagged cardinal from non negative tagged vector`() throws(Cardinal.Error) {
        let offset: Tagged<Element, Ordinal>.Offset = 5
        let count: Tagged<Element, Cardinal> = try Tagged<Element, Cardinal>(offset)
        #expect(count.underlying == Cardinal(5))
    }

    @Test
    func `vector less than cardinal same domain`() {
        let offset: Tagged<Element, Ordinal>.Offset = 3
        let count: Tagged<Element, Cardinal> = 5
        #expect(offset < count)
    }

    @Test
    func `cardinal less than vector same domain`() {
        let count: Tagged<Element, Cardinal> = 3
        let offset: Tagged<Element, Ordinal>.Offset = 5
        #expect(count < offset)
    }

    @Test
    func `vector equal to cardinal at zero`() {
        let offset: Tagged<Element, Ordinal>.Offset = .zero
        let count: Tagged<Element, Cardinal> = .zero
        #expect(offset <= count)
        #expect(offset >= count)
    }

    @Test
    func `negative vector less than any cardinal`() {
        let offset: Tagged<Element, Ordinal>.Offset = -1
        let count: Tagged<Element, Cardinal> = .zero
        #expect(offset < count)
    }
}

extension Affine.Discrete.Vector.`Tagged Offset`.`Edge Case` {

    @Test
    func `tagged cardinal from negative tagged vector throws`() {
        let offset: Tagged<Element, Ordinal>.Offset = -5
        #expect(throws: Cardinal.Error.negativeSource(-5)) {
            try Tagged<Element, Cardinal>(offset)
        }
    }

    @Test
    func `vector at int max compares below cardinal at uint max`() {
        let offset = Tagged<Element, Ordinal>.Offset(Int.max)
        let count = Tagged<Element, Cardinal>(_unchecked: .max)
        #expect(offset < count)
        #expect(offset <= count)
        #expect(!(offset > count))
        #expect(!(offset >= count))
    }

    @Test
    func `vector at int min compares below cardinal at uint max`() {
        let offset = Tagged<Element, Ordinal>.Offset(Int.min)
        let count = Tagged<Element, Cardinal>(_unchecked: .max)
        #expect(offset < count)
        #expect(offset <= count)
        #expect(!(offset > count))
        #expect(!(offset >= count))
    }

    @Test
    func `cardinal at uint max compares above vector at int max`() {
        let count = Tagged<Element, Cardinal>(_unchecked: .max)
        let offset = Tagged<Element, Ordinal>.Offset(Int.max)
        #expect(count > offset)
        #expect(count >= offset)
        #expect(!(count < offset))
        #expect(!(count <= offset))
    }

    @Test
    func `cardinal at uint max compares above vector at int min`() {
        let count = Tagged<Element, Cardinal>(_unchecked: .max)
        let offset = Tagged<Element, Ordinal>.Offset(Int.min)
        #expect(count > offset)
        #expect(count >= offset)
        #expect(!(count < offset))
        #expect(!(count <= offset))
    }
}
