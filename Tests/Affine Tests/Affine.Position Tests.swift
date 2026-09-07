import Affine_Test_Support
import Foundation
import Testing

private final class LocalCoordinateDomain {}
private struct EphemeralCoordinateDomain: ~Copyable, ~Escapable {}
private typealias Position = Affine.Position<LocalCoordinateDomain>
private typealias Translation = Affine.Translation<LocalCoordinateDomain>

private func requireSendable<Value: Sendable>(_ value: Value) {}

@Suite struct `Signed positions obey affine laws` {
    @Test func `Nested errors preserve domain ownership and checked conformances`() {
        typealias EphemeralPosition = Affine.Position<EphemeralCoordinateDomain>
        let error = EphemeralPosition.Error.overflow
        requireSendable(error)
        requireSendable(Position.Error.overflow)
        #expect(Set([error, error]).count == 1)
        let erased: any Swift.Error = error
        #expect(erased is EphemeralPosition.Error)
        #expect(!(erased is Position.Error))
    }

    @Test func `Complete coordinate range obeys displacement laws`() throws {
        let coordinates: [Int64] = [.min, .min + 1, -86_400, -1, 0, 1, 86_400, .max - 1, .max]
        for first in coordinates {
            let start = Position(rawValue: first)
            #expect(try start.advanced(by: .zero) == start)
            for last in coordinates {
                let end = Position(rawValue: last)
                let offset = start.distance(to: end)
                #expect(try start.advanced(by: offset) == end)
                #expect(try end.retreated(by: offset) == start)
                #expect((end - start).underlying == -(start - end).underlying)
                #expect((first < last) == (start < end))
            }
        }
        let fullRange = Position(rawValue: .min).distance(to: Position(rawValue: .max))
        #expect(fullRange.underlying.magnitude.value.rawValue == UInt.max)
        #expect(fullRange.underlying.polarity == .positive)
    }

    @Test func `Translation rejects coordinate overflow`() throws {
        let maximum = Position(rawValue: .max)
        let minimum = Position(rawValue: .min)
        #expect(throws: Position.Error.overflow) { try maximum + Position.Offset(1) }
        #expect(throws: Position.Error.overflow) { try minimum - Position.Offset(1) }
        let fullRange = minimum.distance(to: maximum)
        #expect(throws: Position.Error.overflow) { try Position(rawValue: 0) + fullRange }
        #expect(throws: Position.Error.overflow) { try Position(rawValue: 0) - fullRange }
    }

    @Test func `Position translation composition preserves its action`() throws {
        let position = Position(rawValue: -3_600)
        let first = Translation(offset: .init(5_400))
        let next = Translation(offset: .init(-900))
        let composed = try first.composed(with: next)
        #expect(try composed.applying(to: position) == next.applying(to: first.applying(to: position)))
        #expect(try first.composed(with: .identity) == first)
        #expect(try first.composed(with: first.inverted()) == .identity)
        #expect(first.inverted().inverted() == first)
        #expect(try first.inverted().applying(to: first.applying(to: position)) == position)
        #expect(try Position.Offset(5_400) + position == Position(rawValue: 1_800))
    }

    @Test func `Full range translation has an exact inverse`() throws {
        let minimum = Position(rawValue: .min)
        let maximum = Position(rawValue: .max)
        let translation = Translation(offset: minimum.distance(to: maximum))
        #expect(try translation.applying(to: minimum) == maximum)
        #expect(try translation.inverted().applying(to: maximum) == minimum)
        #expect(try translation.composed(with: translation.inverted()) == .identity)
        #expect(throws: Difference.Error.overflow) {
            try translation.composed(with: Translation(offset: .init(1)))
        }
        #expect(throws: Position.Error.overflow) {
            try translation.applying(to: Position(rawValue: 0))
        }
    }

    @Test func `Position and translation do not inherit phantom domain conformances`() throws {
        let position = Position(rawValue: -1)
        let translation = Translation(offset: .init(30))
        requireSendable(position)
        requireSendable(translation)
        #expect(Set([position, position]).count == 1)
        #expect(Set([translation, translation]).count == 1)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        #expect(try decoder.decode(Position.self, from: encoder.encode(position)) == position)
        #expect(try decoder.decode(Translation.self, from: encoder.encode(translation)) == translation)
    }
}
