@_exported import XCTest

infix operator ± : RangeFormationPrecedence

public typealias Hopes = XCTestCase

extension Hopes {
    
    public func expectation(function: String = #function) -> XCTestExpectation {
        expectation(description: function)
    }
    
    @inlinable public func wait(
        for first: XCTestExpectation,
        _ rest: XCTestExpectation...,
        timeout seconds: TimeInterval
    ) {
        wait(for: [first] + rest, timeout: seconds)
    }
}

extension Optional {
    
    public func hopefully(
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) throws -> Wrapped {
        try XCTUnwrap(self, file: file, line: line)
    }
}

/// TODO: create own ``XCTIssue``s
public struct hope<T> {
    public let value: () throws -> T
    public let file: StaticString
    public let line: UInt
}

extension hope {
    
    public init(
        _ value: @escaping @autoclosure () throws -> T,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) {
        self.value = value
        self.file = file
        self.line = line
    }
    
    public init(
        that value: T,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) {
        self.value = { value }
        self.file = file
        self.line = line
    }

    public init<E: Error>(
        _ value: @autoclosure () -> Result<T, E>,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) {
        let result = Result{ try value().get() }
        self.init(try result.get(), file, line)
    }

    public init<E: Error>(
        that value: Result<T, E>,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) {
        let result = Result{ try value.get() }
        self.init(try result.get(), file, line)
    }
}

extension hope where T == Any {
    
    public static func `none`<T>(
        _ value: @autoclosure () throws -> T?,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) rethrows {
        XCTAssertNil(try value())
    }
    
    public static func `some`<T>(
        _ value: @autoclosure () throws -> T?,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) rethrows {
        XCTAssertNotNil(try value())
    }
}

extension hope where T == Bool {
    
    public static func `for`(_ seconds: TimeInterval) {
        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: seconds)
    }

    public static func `true`(
        _ value: @autoclosure () throws -> Bool,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) rethrows {
        XCTAssertTrue(try value(), file: file, line: line)
    }
    
    public static func `false`(
        _ value: @autoclosure () throws -> Bool,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) rethrows {
        XCTAssertFalse(try value(), file: file, line: line)
    }
    
    public static func `throws`<Ignore>(
        _ value: @autoclosure () throws -> Ignore,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) {
        XCTAssertThrowsError(try value(), file: file, line: line)
    }
    
    public static func less(
        _ message: @autoclosure () -> String,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) {
        XCTFail(message(), file: file, line: line)
    }
    
    public static func less(
        _ error: @autoclosure () -> Error,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) {
        XCTFail(String(describing: error()), file: file, line: line)
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
