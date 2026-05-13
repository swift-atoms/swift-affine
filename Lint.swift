// swift-linter-tools-version: 0.1
// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-affine-primitives open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-affine-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

// Shape-γ unified consumer manifest. swift-affine-primitives owns the
// `Affine.Discrete.Vector` brand-newtype, so the four consumer-side
// recognizer rules (`raw value access`, `chained rawvalue access`,
// `int public parameter`, `pointer advanced by`) fire on
// legitimate-by-construction same-package access. Excluding those four
// rules locally preserves cross-package strict-superset firing.
//
// See `swift-foundations/swift-linter-rules/Research/numerics-rule-recognizer-2026-05-12.md`
// for the architectural rationale (Option 7: rule decomposition via
// bundle composition).

import Linter
import Linter_Primitives_Rules

Lint.run(dependencies: [
    .package(
        path: "../swift-primitives-linter-rules",
        products: ["Linter Primitives Rules"]
    ),
]) {
    Lint.Rule.Bundle.primitives.excluding(rules: [
        "raw value access",
        "chained rawvalue access",
        "int public parameter",
        "pointer advanced by",
    ])
}
