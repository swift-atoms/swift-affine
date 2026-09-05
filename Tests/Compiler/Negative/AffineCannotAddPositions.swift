// EXPECT-ERROR: cannot convert|binary operator|conflicting arguments
import Affine

enum Day {}

func cannotAddCoordinates() throws {
    let day = Affine.Position<Day>(rawValue: 0)
    let _ = try day + day
}
