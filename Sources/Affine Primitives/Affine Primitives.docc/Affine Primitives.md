# ``Affine_Primitives``

@Metadata {
    @DisplayName("Affine Primitives")
    @TitleHeading("Swift Institute — Primitives Layer")
}

A typed affine-displacement primitive — `Affine.Discrete.Vector`, a signed offset between positions, plus a typed cross-domain ratio and the typed-offset surface paired with phantom-tagged ordinals.

## Overview

`Affine Primitives` ships ``Affine_Primitives_Core/Affine/Discrete/Vector``, a value type backed by `Int` that answers the question *"how far between?"* — the directed distance between two positions. Vectors form an additive group; positions do not. The three load-bearing operations connect them:

- `position − position → vector` — the displacement between two positions
- `position + vector  → position` — translate a position by a displacement
- `position − vector  → position` — translate the other direction

Each operation is typed: `Position ± Vector` is generic over `Ordinal.\`Protocol\`` and `Carrier.\`Protocol\`<Affine.Discrete.Vector>`, throwing `Ordinal.Error` for over/underflow on the position side; `Position − Position` returns `Affine.Discrete.Vector`, throwing `Affine.Discrete.Vector.Error.unrepresentable` for `Int`-representation overflow.

Affine is the third of three packages in **Story 1 of the data-structures cohort**: cardinal (count), ordinal (position), affine (offset) — three things stdlib calls `Int`. Where `Cardinal` answers *"how many?"* and `Ordinal` answers *"which position?"*, ``Affine_Primitives_Core/Affine/Discrete/Vector`` answers *"how far between?"*.

The package also ships the `Tagged<Tag, Ordinal>.Offset` typealias (defined as `Tagged<Tag, Affine.Discrete.Vector>`) so per-domain ordinal types compose with a paired typed-offset type, and `Affine.Discrete.Ratio<From, To>` for typed cross-domain scaling between phantom-tagged quantities.

## Topics

### Essentials

- <doc:Affine-Discrete-Vector>
- <doc:Tagged-Offsets>

### Core Types

- ``Affine_Primitives_Core/Affine``
- ``Affine_Primitives_Core/Affine/Discrete``
- ``Affine_Primitives_Core/Affine/Discrete/Vector``
- ``Affine_Primitives_Core/Affine/Discrete/Vector/Error``
- ``Affine_Primitives_Core/Affine/Discrete/Ratio``

### Standard-Library Integration

- ``Swift/Int/init(bitPattern:)-affine``
