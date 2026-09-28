#if Tagged
@_exported public import Tagged

extension Affine {

    public func tagged<Tag: ~Copyable & ~Escapable>(
        _ tag: Tag.Type = Tag.self
    ) -> Affine<Tagged<Tag, Point>, Displacement, Failure> {
        .init(
            translating: { (point, offset) throws(Failure) in
                Tagged(_unchecked: try self.translated(point.underlying, by: offset))
            },
            displacement: { (start, end) throws(Failure) in
                try self.displacement(from: start.underlying, to: end.underlying)
            }
        )
    }
}
#endif
