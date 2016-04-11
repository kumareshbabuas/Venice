// Poller.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import CLibvenice

public typealias FileDescriptor = Int32

public enum PollError: ErrorProtocol {
    case timeout
    case fail
}

public struct PollEvent: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let reading  = PollEvent(rawValue: Int(FDW_IN))
    public static let writing = PollEvent(rawValue: Int(FDW_OUT))
}

/// Polls file descriptor for events
public func poll(fileDescriptor: FileDescriptor, for events: PollEvent, timingOut deadline: Deadline = never) throws -> PollEvent {
    let event = mill_fdwait(fileDescriptor, Int32(events.rawValue), deadline, "pollFileDescriptor")

    if event == 0 {
        throw PollError.timeout
    }

    if event == FDW_ERR {
        throw PollError.fail
    }

    return PollEvent(rawValue: Int(event))
}