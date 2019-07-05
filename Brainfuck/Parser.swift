//
//  Parser.swift
//  Brainfuck
//
//  Created by Octree on 2019/7/5.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

enum ParseError: Error {
    case notMatch
}

/// 操作符
///
/// - gt: >
/// - lt: <
/// - plus: +
/// - minus: -
/// - dot: .
/// - comma: ,
enum Opcode {
    case gt
    case lt
    case plus
    case minus
    case dot
    case comma
}

indirect enum Statement {
    case single(Opcode)
    case loop([Statement])
}

struct Brainfuck {
    var statements: [Statement]
}

public class Parser {
    
    /// current position
    var pos: Int = 0
    /// source code
    var input: String
    ///
    var startIndex: String.Index {
        return input.index(input.startIndex, offsetBy: self.pos)
    }
    /// is current position end of file
    var eof: Bool {
        return pos >= input.count
    }
    
    public init(input: String) {
        self.input = input
    }
    
}

public extension Parser {
    
    func startWith(_ str: String) -> Bool {
        
        return input[startIndex...].hasPrefix(str)
    }
    
    func nextChar() -> Character {
        
        return input[self.pos]
    }
    
    @discardableResult
    func consumeChar() -> Character {
        defer {
            pos += 1
        }
        return input[pos]
    }
    
    func consumeWhiteSpace() {
        consumeWhile { $0.isWhitespace }
    }
    
    @discardableResult
    func consumeWhile(_ test: (Character) -> Bool) -> String {
        
        var chars = [Character]()
        while !eof && test(nextChar()) {
            chars.append(consumeChar())
        }
        return String(chars)
    }
    
    func eat(_ text: String) throws {
        guard startWith(text) else {
            throw ParseError.notMatch
        }
        (0..<text.count).forEach { _ in consumeChar() }
    }
}


extension Parser {
    
    func parse() throws -> Brainfuck {
        let program = try Brainfuck(statements: statements())
        if !eof {
            throw ParseError.notMatch
        }
        return program
    }
    
    func statements() throws -> [Statement] {
        consumeWhiteSpace()
        var stms = [Statement]()
        while !eof && nextChar() != "]" {
            try stms.append(statemenet())
            consumeWhiteSpace()
        }
        return stms
    }
    
    func statemenet() throws -> Statement {
        switch nextChar() {
        case "[":
            consumeChar()
            let stms = try statements()
            try eat("]")
            return .loop(stms)
        default:
            return try .single(parseOpCode())
        }
    }
    
    func parseOpCode() throws -> Opcode {
        switch nextChar() {
        case ">":
            consumeChar()
            return .gt
        case "<":
            consumeChar()
            return .lt
        case "+":
            consumeChar()
            return .plus
        case "-":
            consumeChar()
            return .minus
        case ".":
            consumeChar()
            return .dot
        case ",":
            consumeChar()
            return .comma
        default:
            throw ParseError.notMatch
        }
    }
}
