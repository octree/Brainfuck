//
//  Interpreter.swift
//  Brainfuck
//
//  Created by Octree on 2019/7/5.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

class Interpreter {
    var stack: [Int] = [0]
    var index: Int = 0
    let program: Brainfuck
    init(program: Brainfuck) {
        self.program = program
    }
    
    func exec() {
        exec(statements: program.statements)
    }
    
    func exec(statements: [Statement]) {
        statements.forEach(exec(statement:))
    }
    
    func exec(statement: Statement) {
        switch statement {
        case let .single(op):
            exec(opcode: op)
        case let .loop(stms):
            exec(loop: stms)
        }
    }
    
    func exec(opcode: Opcode) {
        switch opcode {
        case .gt:
            index += 1
            if index >= stack.count {
                stack.append(0)
            }
        case .lt:
            index -= 1
        case .plus:
            stack[index] += 1
        case .minus:
            stack[index] -= 1
        case .dot:
            print(Character(UnicodeScalar(stack[index])!), terminator: "")
        case .comma:
            stack[index] = Int(getchar())
        }
    }
    
    func exec(loop statements: [Statement]) {
        while stack[index] != 0 {
            exec(statements: statements)
        }
    }
}
