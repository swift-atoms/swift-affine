# Affine Primitives Insights

<!--
---
title: Affine Primitives Insights
version: 1.0.0
last_updated: 2026-01-28
applies_to: [swift-affine-primitives]
normative: false
---
-->

@Metadata {
    @TitleHeading("Affine Primitives")
}

Design decisions, implementation patterns, and lessons learned specific to this package.

## Overview

This document captures insights that emerged during development of swift-affine-primitives. These are not API requirements—they are recorded decisions and patterns that inform future work on this package.

**Document type**: Non-normative (recorded decisions, not requirements).

**Consolidation source**: Reflection entries tagged with `[Package: swift-affine-primitives]`.

---

## The ExpressibleByIntegerLiteral Guard

**Date**: 2026-01-27

**Context**: Diagnosing the Bit.Ratio compilation failure where `Self(8)` failed for `Ratio<UInt8, Bit>`.

The `ExpressibleByIntegerLiteral` conformance on `Affine.Discrete.Ratio` is deliberately restricted to `where From == To`. This prevents cross-domain ratios from being silently created through integer literals. When you write `let r: Ratio<A, B> = 8`, the meaning depends entirely on the domain pair—this context-dependence is exactly what integer literals obscure.

Same-domain ratios like `Ratio<Meters, Meters>(2)` have unambiguous semantics: "scale by 2." Cross-domain ratios like `Ratio<UInt8, Bit>(8)` require domain knowledge: "8 bits per byte." The restriction forces explicit initializers for cross-domain cases, making the domain transformation visible at the call site.

The fix is trivial: `Self.init(8)` instead of `Self(8)`. Both invoke the same initializer, but the former is explicit initialization while the latter would use `ExpressibleByIntegerLiteral`. The visual distinction is subtle—`.init` versus nothing—but the semantic distinction is significant. Cross-domain ratios should look different from same-domain ratios.

Auditing ratio usage reveals a pattern: all cross-domain ratios already use explicit initialization. `Ratio<Element, UInt8>(MemoryLayout<Element>.stride)` in heap and array primitives. The `bitsPerByte` case was the sole outlier attempting literal syntax. The fix brings it into alignment.

**Applies to**: `Affine.Discrete.Ratio` literal conformance, cross-domain ratio initialization, semantic type safety.

---

## Cross-Domain Ratios Live in Affine

**Date**: 2026-01-28

**Context**: Deciding where to define `Tagged<From, Cardinal> * Ratio<From, To> → Tagged<To, Cardinal>`.

Ratio scaling changes phantom types: `Index<UInt8>.Count * bitsPerByte` produces `Index<Bit>.Count`. The operation transforms the domain from `From` to `To`. Where does this belong?

Not in Cardinal Primitives—Cardinal knows nothing about ratios. Not in Index Primitives—we want no arithmetic there. The answer: Affine Primitives, which already owns `Affine.Discrete.Ratio`.

The generic Tagged pattern:

```swift
public func * <From: ~Copyable, To: ~Copyable>(
    lhs: Tagged<From, Cardinal>,
    rhs: Affine.Discrete.Ratio<From, To>
) -> Tagged<To, Cardinal>
```

This works for any Tagged cardinal, not just Index.Count. The `From` and `To` parameters are independent phantom types, constrained only by the ratio connecting them. The type system enforces that you can only scale a `Tagged<From, _>` by a `Ratio<From, _>`.

Mathematically, a ratio is a morphism between domains. The operator signature encodes this: the ratio carries domain information that transforms the operand's tag. Placing this in Affine Primitives aligns implementation with mathematics—ratios are affine geometry concepts.

**Applies to**: `Tagged<Tag, Cardinal> * Ratio` operators, domain transformation operators, ratio placement.

---

## The @_disfavoredOverload Pattern for Protocol Conformance Conflicts

**Date**: 2026-01-27

**Context**: Diagnosing why `Self(8)` failed for `Ratio<UInt8, Bit>` while `Self.init(8)` worked.

When a type has both an explicit initializer `init(_ factor: Int)` and an `ExpressibleByIntegerLiteral` conformance with a same-domain constraint `where From == To`, Swift's overload resolution can fail unexpectedly. The expression `Self(8)` in a cross-domain context attempts to use the literal conformance first, hits the constraint, and fails—even though the explicit initializer would work perfectly.

The fix is `@_disfavoredOverload` on `init(integerLiteral:)`. This tells Swift: "when both overloads apply, prefer the other one." The literal conformance becomes a fallback for actual literal contexts (`let r: Ratio<T, T> = 2`) while explicit calls go to the primary initializer.

`@_disfavoredOverload` is an underscored attribute—not officially stable. But it's widely used in the standard library and is the canonical solution for this exact problem. When the choice is between an underscored attribute and requiring special call-site syntax everywhere, the attribute wins. Infrastructure code can accept implementation-detail attributes that application code should avoid.

Without `@_disfavoredOverload`, every cross-domain ratio initialization would need `.init(8)` instead of `(8)`. The attribute eliminates this by making both syntaxes work, preserving the semantic distinction (literals only for same-domain) while removing the call-site ceremony.

**Applies to**: `Affine.Discrete.Ratio` initializers, `@_disfavoredOverload` usage, overload resolution control.

---

## Topics

### Related Documents

- <doc:Affine-Discrete-Ratio>
- <doc:Affine-Discrete-Vector>
