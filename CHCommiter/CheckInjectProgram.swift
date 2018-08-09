//
//  CheckInjectProgram.swift
//  CHCommiter
//
//  Created by 郭介騵 on 2018/8/9.
//  Copyright © 2018 james12345. All rights reserved.
//

import Foundation

class CheckInjectProgram {
    
    static var mePath: String {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        return Shell(launchPath: "which", arguments: [executableName]).run().outPipeMsg ?? CommandLine.arguments[0]
    }
    
    static var script: String {
        return "#!/bin/sh \n\n" +
                mePath + " check"
    }
    
    public class func main() {
        let injectShell = Shell(launchPath: "sh",
                                arguments: ["-c",
                                            "echo '\(script)' > .git/hooks/pre-push"],
                                errorHandler: { (errMsg) in
                                    guard let msg = errMsg else { return }
                                    console.writeMessage(msg)
                                    exit(1)
        }).run()
        guard let msg = injectShell.outPipeMsg else {
            exit(0)
        }
        console.writeMessage(msg)
        console.injectDone()
    }
}

fileprivate extension ConsoleIO {
    
    func injectDone() {
        console.writeMessage(self.isEnglish ? "🎉Have relpaced .git/hooks/pre-push" : "🎉已替换 .git/hooks/pre-push")
    }
    
}
