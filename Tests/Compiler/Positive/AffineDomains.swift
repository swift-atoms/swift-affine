import Affine
import Difference

enum Day {}
enum Second {}

func usePositions() throws {
    let first = Affine.Position<Day>(rawValue: -1)
    let last = Affine.Position<Day>(rawValue: 1)
    let days: Affine.Position<Day>.Offset = last - first
    let _: Affine.Position<Day> = try first + days
    let translation = Affine.Translation<Day>(offset: days)
    let _: Affine.Position<Day> = try translation.applying(to: first)
    let _: Affine.Translation<Day> = try translation.composed(with: translation.inverted())
    let _: Affine.Position<Second> = .init(rawValue: 0)
}
