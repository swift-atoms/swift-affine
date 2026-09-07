internal import Addition
internal import Cardinal
internal import Magnitude
internal import Polarity
public import Difference
internal import Subtraction
public import Tagged

extension Affine.Position: Swift.Comparable where Domain: ~Copyable & ~Escapable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
