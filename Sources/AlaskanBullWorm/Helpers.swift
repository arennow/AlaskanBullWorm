public prefix func ! <T>(_ p: @escaping (T) -> Bool) -> (T) -> Bool { { !p($0) } }
