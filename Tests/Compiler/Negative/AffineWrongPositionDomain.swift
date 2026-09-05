// EXPECT-ERROR: cannot convert|binary operator|conflicting arguments
import Affine

enum Day {}
enum Second {}

func cannotSubtractDifferentUnits() {
    let day = Affine.Position<Day>(rawValue: 0)
    let second = Affine.Position<Second>(rawValue: 0)
    let _ = day - second
}
