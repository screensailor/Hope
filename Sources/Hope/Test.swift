public struct hope<T> {
    public let value: () throws -> T
    public let file: StaticString
    public let line: UInt
}

extension hope {
    
    public init(
        _ value: @escaping @autoclosure () throws -> T,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        self.value = value
        self.file = file
        self.line = line
    }
}

extension hope where T == Bool {
    
    public static func `true`(
        _ value: @escaping @autoclosure () throws -> Bool,
        file: StaticString = #filePath,
        line: UInt = #line
    ) rethrows {
        XCTAssertTrue(try value(), file: file, line: line)
    }
    
    public static func `false`(
        _ value: @escaping @autoclosure () throws -> Bool,
        file: StaticString = #filePath,
        line: UInt = #line
    ) rethrows {
        XCTAssertFalse(try value(), file: file, line: line)
    }
    
    public static func `throws`<Ignore>(
        _ value: @escaping @autoclosure () throws -> Ignore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(try value(), file: file, line: line)
    }
}

extension hope where T: Equatable {
    
    @inlinable
    public static func == (l: hope, r: @autoclosure () throws -> T) {
        XCTAssertEqual(try l.value(), try r(), file: l.file, line: l.line)
    }
    
    @inlinable
    public static func != (l: hope, r: @autoclosure () throws -> T) {
        XCTAssertNotEqual(try l.value(), try r(), file: l.file, line: l.line)
    }
}

extension hope where T: Comparable {
    
    @inlinable
    public static func > (l: hope, r: @autoclosure () throws -> T) {
        XCTAssertGreaterThan(try l.value(), try r(), file: l.file, line: l.line)
    }
    
    @inlinable
    public static func < (l: hope, r: @autoclosure () throws -> T) {
        XCTAssertLessThan(try l.value(), try r(), file: l.file, line: l.line)
    }
    
    @inlinable
    public static func >= (l: hope, r: @autoclosure () throws -> T) {
        XCTAssertGreaterThanOrEqual(try l.value(), try r(), file: l.file, line: l.line)
    }
    
    @inlinable
    public static func <= (l: hope, r: @autoclosure () throws -> T) {
        XCTAssertLessThanOrEqual(try l.value(), try r(), file: l.file, line: l.line)
    }
}

extension hope where T: FloatingPoint {
    
    @inlinable
    public static func ~= (l: hope<T>, r: ClosedRange<T>) {
        let e = (r.upperBound - r.lowerBound) / 2
        XCTAssertEqual(try l.value(), r.lowerBound + e, accuracy: e, file: l.file, line: l.line)
    }
}

extension FloatingPoint {
    
    @inlinable public static func ± (l: Self, r: Self) -> ClosedRange<Self> {
        (l - abs(r)) ... (l + abs(r))
    }
}
