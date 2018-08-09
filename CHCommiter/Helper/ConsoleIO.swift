//
//  ConsoleIO.swift
//  UDNCrawlerCmd
//
//  Created by 郭介騵 on 2018/5/10.
//  Copyright © 2018年 james12345. All rights reserved.
//

import Foundation

enum OutputType {
    case error
    case standard
}

class ConsoleIO {
    
    var isEnglish: Bool {
        return param.useEnglish
    }
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\(message)")
        case .error:
            fputs("Error: \(message)\n", stderr)
        }
    }
    
    func printUsage() {
        
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        writeMessage("usage:")
        writeMessage("\(executableName) [-e] push")
        writeMessage("or")
        writeMessage("\(executableName) [-e] commit [-a]")
        writeMessage("")
        writeMessage("(-a: Auto git add .)  (-e: english version)")
    }
    
    func getInput() -> String {
        // 1
        let keyboard = FileHandle.standardInput
        // 2
        let inputData = keyboard.availableData
        // 3
        let strData = String(data: inputData, encoding: String.Encoding.utf8) ?? ""
        // 4
        return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
}

extension ConsoleIO {
    
    public func printHelloMessage() {
        writeMessage(self.isEnglish ? "🙋🏻‍♂️Welecome to CHCommiter" : "🙋🏻‍♂️歡迎使用CHCommiter")
    }
    
    public func debug_Env() {
        let dir = Shell(launchPath: "pwd").run().outPipeMsg
        guard let dirs = dir else { fatalError("no dir") }
        writeMessage("Directory: \(dirs)")
    }
}


