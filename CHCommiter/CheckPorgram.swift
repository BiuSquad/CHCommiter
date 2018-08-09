//
//  CheckPorgram.swift
//  CHCommiter
//
//  Created by 郭介騵 on 2018/8/9.
//  Copyright © 2018 james12345. All rights reserved.
//

import Foundation

class CheckPorgram {
    
    @discardableResult
    public class func main(_ shouldClose: Bool = false) -> Bool {
        let commits = cherry()
        if commits.count > 0 {
            check(commits)
        } else {
            console.printEmptyCherryMessage()
        }
        if shouldClose {
            exit(0)
        }
        return commits.count > 0
    }
    
    private class func cherry() -> [String] {
        let cherryShell = Shell(launchPath: "git",
                                  arguments: ["cherry", "-v"]).run()
        if let err = cherryShell.errPipeMsg {
            console.writeMessage(err, to: .error)
            return log()
        } else if let cherryMsg = cherryShell.outPipeMsg {
            let commits = cherryMsg.split(separator: "\n")
            return commits.map({ String($0) })
        } else {
            return []
        }
    }
    
    private class func log() -> [String] {
        console.printTryLog()
        let logMessage = Shell(launchPath: "git",
                                  arguments: ["log", "master..", "--pretty=format:%s"],
                                  errorHandler: { (errMsg) in
                                    guard let msg = errMsg else { return }
                                    console.writeMessage(msg, to: .error)
                                    exit(0)
        }).run().outPipeMsg
        if let logMsg = logMessage {
            let commits = logMsg.split(separator: "\n")
            return commits.map({ String($0)})
        }
        exit(0)
    }
    
    static var tty: String {
        return Shell(launchPath: "tty").run().outPipeMsg ?? "/dev/ttys001"
    }
    
    private class func check(_ commits: [String]) {
        
        for commit in commits {
            if !regx(commit, pattern: "(\\+ [a-zA-Z0-9]+ )*.+\\(.*\\): .+") {
                if !regx(commit, pattern: "Merge branch '.+' into '.+'") { //maybe is merge
                    console.printNotPassCommitPrompt(commit)
                    exit(1)
                }
            }
        }
        console.printAllPassedPrompt()
        exit(0)
    }
    
    private class func regx(_ commit: String,
                            pattern: String) -> Bool {
        let rex: NSRegularExpression
        do {
            rex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            console.writeMessage(error.localizedDescription, to: .error)
            exit(1)
        }
        if let _ = rex.firstMatch(in: commit, options: [], range: NSRange(location: 0, length: commit.count)) {
            return true
        } else {
            return false
        }
    }
}

fileprivate extension ConsoleIO {
    
    func printEmptyCherryMessage() {
        writeMessage(self.isEnglish ? "❌Cannot found any commits (compare to HEAD) should be check." : "❌无任何新增的Commit可被检查格式")
    }
    
    func printTryLog() {
        writeMessage("git cherry fail❗️")
        writeMessage("try git log⛔️")
    }
    
    func printNotPassCommitPrompt(_ commit: String) {
        writeMessage(self.isEnglish ? "❌Below commits subject didn't pass the regx check." : "❌以下Commits并未通过正则检查")
        console.writeMessage(commit)
        //writeMessage(self.isEnglish ? "Input 's' to skip, other to close proces." : "输入 's' 忽略, 输入其他的结束")
    }
    
    func printPassedCommit(_ commit: String) {
        writeMessage(commit + (self.isEnglish ? "........Passed⭕️" : ".........通过⭕️"))
    }
    
    func printAllPassedPrompt() {
        writeMessage(self.isEnglish ? "All commits passed the checked🎉" : "Commits皆通过正则检查🎉")
    }
    
}
