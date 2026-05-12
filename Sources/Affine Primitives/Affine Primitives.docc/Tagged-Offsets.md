# Tagged Offsets

@Metadata {
    @TitleHeading("Affine Primitives")
}

Phantom-tagged offset types — `Tagged<Tag, Ordinal>.Offset` — and how they compose with `Affine.Discrete.Ratio<From, To>` for typed cross-domain scaling.

## Overview

A bare ``Affine_Primitives_Core/Affine/Discrete/Vector`` is a one-dimensional displacement. Often the displacement is more specific: *how far between which positions?* Mixing a step in elements with a step in bytes is usually a defect — adding an element-offset to a byte-offset is meaningless. The `Tagged` primitive supplies the phantom-tag mechanism; this package supplies the typealias that pairs Tagged with `Affine.Discrete.Vector`:

```swift
extension Tagged where Underlying == Ordinal, Tag: ~Copyable {
    public typealias Offset = Tagged<Tag, Affine.Discrete.Vector>
}
```

So `Tagged<Tag, Ordinal>` (a typed position) gains a paired `Tagged<Tag, Ordinal>.Offset` (a typed displacement), and the affine arithmetic is type-safe across domains:

```swift
extension Element {}
extension Byte {}

let position: Tagged<Element, Ordinal> = 5
let step: Tagged<Element, Ordinal>.Offset = 1
let next = try position + step                              // Tagged<Element, Ordinal>(6)

let bytePosition: Tagged<Byte, Ordinal> = 32
// position + bytePosition.offset    // ❌ compile error — different domains
```

The `Tagged<Tag, Ordinal>.Offset` typealias is the promised name across 0.x — downstream code may rely on it.

## Typed Magnitude

The magnitude of a typed offset is a *typed cardinal* — preserving the phantom tag:

```swift
let step: Tagged<Element, Ordinal>.Offset = -3
let magnitude: Tagged<Element, Cardinal> = step.magnitude   // |step| as a tagged element-count
```

The `Tag` propagates: an element-offset's magnitude is an element-count. Same-tag identity is enforced structurally by the type system.

## Construction

```swift
extension Tagged where Underlying == Affine.Discrete.Vector, Tag: ~Copyable {
    public init(_ underlying: Int)                                                     // From signed Int
    public init<T: ~Copyable>(_ count: Tagged<T, Cardinal>)                            // From any Tagged Cardinal
    public init(_ index: some Ordinal.\`Protocol\`) throws(Affine.Discrete.Vector.Error)  // Displacement from origin
    public init(fromZero position: some Ordinal.\`Protocol\`)                            // Same as init(_:) but explicit-from-zero
    public init(_unchecked: Void, _ ordinal: some Ordinal.\`Protocol\`)                  // No-validation; assert ordinal ≤ Int.max
}
```

The `init(_ index:)` (throwing) and `init(fromZero:)` initializers make explicit the assumption that an offset measured from the zero position is the same shape as the position's underlying value, lifted into the signed displacement type. The throwing variant is total over signed `Int.max`; the from-zero variant assumes the position is representable.

## Cross-Domain Ratio Scaling

`Affine.Discrete.Ratio<From, To>` is the typed cross-domain morphism — a multiplicative factor that maps a `Tagged<From, _>` quantity to a `Tagged<To, _>` quantity. The canonical use is dimensional analysis on phantom-tagged counts and offsets:

```swift
extension Byte {}
extension Bit {}

let bitsPerByte: Affine.Discrete.Ratio<Byte, Bit> = .init(8)

// Tagged<From, Cardinal> * Ratio<From, To> → Tagged<To, Cardinal>
let bytes: Tagged<Byte, Cardinal> = 4
let bits = bytes * bitsPerByte                              // Tagged<Bit, Cardinal>(32)

// Tagged<From, Vector> * Ratio<From, To> → Tagged<To, Vector>
let byteOffset: Tagged<Byte, Affine.Discrete.Vector> = -2
let bitOffset = byteOffset * bitsPerByte                    // Tagged<Bit, Affine.Discrete.Vector>(-16)
```

The type system enforces that the operation is meaningful: `Tagged<Byte, _> * Ratio<Element, Bit>` is a compile error (domain mismatch), as is `bytes * Ratio<Bit, Byte>(...)` (wrong direction). Same-domain ratios (`Ratio<Byte, Byte>`) act as identity-by-multiplication — useful when expressing "scale a count by a factor without changing tag."

## Composition

Ratios compose:

```swift
extension Word {}

let bytesPerWord: Affine.Discrete.Ratio<Word, Byte> = .init(8)
let bitsPerByte: Affine.Discrete.Ratio<Byte, Bit> = .init(8)
let bitsPerWord: Affine.Discrete.Ratio<Word, Bit> = bytesPerWord * bitsPerByte    // factor 64
```

The `Ratio<A, B> * Ratio<B, C> → Ratio<A, C>` rule is associative; ratio composition matches morphism composition in the discrete-affine category.

## Quotient and Remainder

The inverse direction is `quotientAndRemainder(dividing:)`, which decomposes a `Tagged<To, _>` quantity into a `Tagged<From, _>` quotient and a same-domain remainder:

```swift
let bitsPerByte: Affine.Discrete.Ratio<Byte, Bit> = .init(8)
let bitCount: Tagged<Bit, Cardinal> = 100
let (byteCount, remainingBits) = bitsPerByte.quotientAndRemainder(dividing: bitCount)
// byteCount: Tagged<Byte, Cardinal>(12)
// remainingBits: Tagged<Bit, Cardinal>(4)
```

Two overloads exist: one accepts a `Tagged<To, Cardinal>` (returns a count quotient + count remainder); one accepts a `Tagged<To, Ordinal>` (returns an *ordinal* quotient + a *vector* remainder, since the remainder is a within-unit offset, not a count).

## Cross-Type Comparisons

When the displacement and the count refer to the same domain, signed-vs-unsigned comparisons are well-defined and compile:

```swift
extension Element {}

let offset: Tagged<Element, Affine.Discrete.Vector> = 3
let count: Tagged<Element, Cardinal> = 5

let withinBound = offset < count                           // true (3 < 5)
```

The constraint `V.Domain == C.Domain` enforces that the comparison is only available when both operands carry the same phantom tag. The operators are `@_disfavoredOverload` so same-type comparisons (`Vector < Vector`, `Cardinal < Cardinal`) are preferred during type inference; the cross-type fire only when both operands are explicitly typed.

## Standard Library Integration

The Standard Library Integration target ships overloads accepting `Tagged<T, Ordinal>.Offset`:

```swift
// RandomAccessCollection.index(_:offsetBy:) accepting a typed offset
let array = [1, 2, 3, 4, 5]
let offset: Tagged<Element, Ordinal>.Offset = 2
let index = array.index(array.startIndex, offsetBy: offset)

// UnsafePointer ± Tagged<Pointee, Ordinal>.Offset
let buffer: UnsafePointer<Int> = ...
let advanced = buffer + offset                              // UnsafePointer<Int>
let distance: Tagged<Int, Ordinal>.Offset = advanced - buffer
```

The pointer arithmetic operators are `@_transparent` — at -O the typed wrapper has zero cost over raw `UnsafePointer.advanced(by:)`.

## Int Conversion

```swift
extension Int {
    public init(bitPattern vector: Affine.Discrete.Vector)
    public init<Tag: ~Copyable>(bitPattern offset: Tagged<Tag, Affine.Discrete.Vector>)
}
```

The `bitPattern` initializer is lossless — a Vector's underlying `Int` and an `Int` initialized from it bit-pattern-equal. The Tagged version unwraps the phantom tag and extracts the underlying signed value.
