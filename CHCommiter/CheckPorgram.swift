//
//  CheckPorgram.swift
//  CHCommiter
//
//  Created by 郭介騵 on 2018/8/9.
//  Copyright © 2018 james12345. All rights reserved.
//

import Foundation

class CheckPorgram {
    
    public class func main() {
        let commits = cherry()
        if commits.count > 0 {
            check(commits)
        }
    }
    
    private class func cherry() -> [String] {
        let cherryMessage = Shell(launchPath: "git",
                                  arguments: ["cherry", "-v"],
                                  errorHandler: { (errMsg) in
                                    guard let msg = errMsg else { return }
                                    console.writeMessage(msg, to: .error)
                                    exit(1)
        }).run().outPipeMsg
        if let cherryMsg = cherryMessage {
            let commits = cherryMsg.split(separator: "\n")
            return commits.map({ String($0) })
        } else {
            console.printEmptyCherryMessage()
            let pushInput = console.getInput()
            if pushInput == "y" || pushInput == "Y" {
                return []
            }
        }
        exit(1)
    }
    
    private class func check(_ commits: [String]) {
        let pattern = "\\+ [a-zA-Z0-9]+ .+\\(.*\\): .+"
        let rex: NSRegularExpression
        do {
            rex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            console.writeMessage(error.localizedDescription, to: .error)
            exit(1)
        }
        for commit in commits {
            if let _ = rex.firstMatch(in: commit, options: [], range: NSRange(location: 0, length: commit.count)) {
                
            } else {
                console.printNotPassCommitPrompt(commit)
                let skip = console.getInput()
                if skip != "s" { exit(0) }
            }
        }
        console.printAllPassedPrompt()
    }
    
}

fileprivate extension ConsoleIO {
    
    func printEmptyCherryMessage() {
        writeMessage(self.isEnglish ? "❌Cannot found any commits (compare to HEAD) should be check." : "❌無任何新增的Commit可被檢查格式")
        writeMessage(self.isEnglish ? "Continue git push anyway? (y/n)" : "仍要 git push嗎？ (y/n)")
    }
    
    func printNotPassCommitPrompt(_ commit: String) {
        writeMessage(self.isEnglish ? "❌Below commits subject didn't pass the regx check." : "❌以下Commits並未通過正則檢查")
        console.writeMessage(commit)
        writeMessage(self.isEnglish ? "Input 's' to skip, other to close proces." : "輸入 's' 忽略, 輸入其他的結束")
    }
    
    func printPassedCommit(_ commit: String) {
        writeMessage(commit + (self.isEnglish ? "........Passed⭕️" : ".........通過⭕️"))
    }
    
    func printAllPassedPrompt() {
        writeMessage(self.isEnglish ? "All commits passed the checked🎉" : "Commits皆通過正則檢查🎉")
    }
    
}
