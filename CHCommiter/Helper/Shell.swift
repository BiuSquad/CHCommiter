//
//  Shell.swift
//  CHCommiter
//
//  Created by 郭介騵 on 2018/8/6.
//  Copyright © 2018 james12345. All rights reserved.
//

import Foundation

class Shell {
    
    public var outPipeMsg: String?
    public var errPipeMsg: String?
    
    fileprivate let errorHandler: ((String?) -> Void)?
    fileprivate let errPipe = Pipe()
    fileprivate let outPipe = Pipe()
    fileprivate let process = Process()

    init (launchPath: String, arguments: [String] = [],
          termianlHandler: ((Process)-> Void)? = nil,
          errorHandler: ((String?) -> Void)? = nil,
          checkPath: Bool = true)
    {
        self.errorHandler = errorHandler
        let absoulutePath = checkPath ? self.checkScriptPath(launchPath) : launchPath
        process.launchPath = absoulutePath
        process.arguments = arguments
        process.standardOutput = outPipe
        process.standardError = errPipe
        process.terminationHandler = { (process) in
            termianlHandler?(process)
        }
    }
    
    @discardableResult
    public func run() -> Shell {
        do {
            try process.run()
        } catch {
            if process.isRunning { process.terminate() }
            errorHandler?(error.localizedDescription)
        }
        process.waitUntilExit()
        //
        self.errPipeMsg = errPipe.getPipeMessage()
        self.errorHandler?(errPipeMsg)
        self.outPipeMsg = outPipe.getPipeMessage()
        return self
    }
}

extension Shell {
    
    fileprivate func checkScriptPath(_ program: String) -> String? {
        let checkShell = Shell(launchPath: "/usr/bin/which",
                               arguments: [program],
                               checkPath: false).run()
        guard let absolutePath = checkShell.outPipeMsg, absolutePath.count > 0 else { fatalError("Cannot find command \(program)") }
        return absolutePath
    }
}

private extension Pipe {
    
    func getPipeMessage() -> String? {
        let data = self.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)!
        if output.count > 0 {
            //remove newline character.
            let lastIndex = output.index(before: output.endIndex)
            return (String(output[output.startIndex ..< lastIndex]))
        }
        return nil
    }
}
