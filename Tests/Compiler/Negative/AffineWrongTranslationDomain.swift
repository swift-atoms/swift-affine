// EXPECT-ERROR: cannot convert|conflicting arguments
import Affine
import Difference

enum Day {}
enum Second {}

func cannotApplySecondsToDays() throws {
    let day = Affine.Position<Day>(rawValue: 0)
    let translation = Affine.Translation<Second>(offset: .init(1))
    let _ = try translation.applying(to: day)
}
