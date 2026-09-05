// EXPECT-ERROR: cannot convert|conflicting arguments
import Affine
import Difference

enum Day {}
enum Second {}

func cannotMixUnits() throws {
    let day = Affine.Position<Day>(rawValue: 0)
    let seconds = Affine.Position<Second>.Offset(1)
    let _ = try day + seconds
}
