public prefix func ! <T>(_ p: @escaping (T) -> Bool) -> (T) -> Bool { { !p($0) } }
public func && <T>(_ l: @escaping (T) -> Bool, _ r: @escaping (T) -> Bool) -> (T) -> Bool { { l($0) && r($0) } }
