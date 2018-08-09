//
//  CommiterProgram.swift
//  CHCommiter
//
//  Created by 郭介騵 on 2018/8/8.
//  Copyright © 2018 james12345. All rights reserved.
//

import Foundation

class CommiterProgram {
    
    public class func main() {
        //Git add
        if param.gitAddAll {
            Shell(launchPath: "git", arguments: ["add", "."], errorHandler: { (errMsg) in
                guard let msg = errMsg else { return }
                console.writeMessage(msg, to: .error)
                exit(1)
            }).run()
            console.printAddAllPrompt()
        }
        //Commit Msg
        ///type
        console.printCategoryPrompt()
        var type: CommitStyle.CommitType? = nil
        while type == nil {
            let selection = console.getInput()
            type = CommitStyle.CommitType(selection)
            if type == nil { console.printCategoryFail() }
        }
        guard let commitType = type else { fatalError("err type") }
        
        ///module
        var moduleContinue: Bool = true
        var commitModule: String = ""
        while moduleContinue {
            let moduleArr = console.printModulePrompt()
            commitModule = console.getInput()
            if let index = Int(commitModule), index <= moduleArr.count {
                if index == moduleArr.count {   //Check out
                    let checkoutShell = Shell(launchPath: "git", arguments: ["checkout"], errorHandler: { err in
                        guard let msg = err else { return }
                        console.writeMessage(msg, to: .error)
                    }).run()
                    console.writeMessage(checkoutShell.outPipeMsg ?? "checkout Fail")
                } else if index < moduleArr.count {
                    commitModule = moduleArr[index]
                    moduleContinue = false
                }
            } else {
                moduleContinue = false
            }
        }
        
        ///Description
        console.printDescriptionPrompt()
        var commitDescription: String = ""
        while commitDescription.count < 1 {
            commitDescription = console.getInput()
            var checkEmptyStr = commitDescription
            checkEmptyStr.removeAll { (c) -> Bool in
                return c == " "
            }
            if checkEmptyStr.count == 0 { console.writeMessage("此处必填"); commitDescription = "" }
        }
        
        ///long Description
        console.printLongDescriptionPrompt()
        let longDescription = console.getInput()
        
        ///final
        let finalCommitMsg = CommitStyle(commitType,
                                         module: commitModule,
                                         description: commitDescription,
                                         longDescri: longDescription,
                                         isEnglish: param.useEnglish).finalCommitMsg
        
        //Git commit
        let commitShell = Shell(launchPath: "git", arguments: ["commit", "-m", finalCommitMsg], errorHandler: { (errMsg) in
            guard let msg = errMsg else { return }
            console.writeMessage(msg, to: .error)
            exit(1)
        }).run()
        console.writeMessage(commitShell.outPipeMsg ?? "none")
    }
}

fileprivate extension ConsoleIO {
    
    func printAddAllPrompt() {
        writeMessage(self.isEnglish ? "automatically git add ." : "已自动 git add .")
    }
    
    func printCategoryPrompt() {
        writeMessage(self.isEnglish ? "📝Select the type of change that you're commiting" : "📝请选择你本次Commit的类别")
        for (idx, type) in CommitStyle.CommitType.allCases.enumerated() {
            let info = type.getInfo(isEnglish: self.isEnglish)
            writeMessage("\(idx):\(info.0)  \(info.1)")
        }
    }
    
    func printCategoryFail() {
        writeMessage(self.isEnglish ? "❗️Please input an avaliable option" : "❗️请输入指定选项", to: .error)
    }
    
    @discardableResult
    func printModulePrompt() -> [String] {
        writeMessage(self.isEnglish ? "What is the scope of this change (e.g. component or file name)? (press enter to skip)" :  "请选择或直接输入负责的业务线/模块/主要改动档案名称 (空白跳过)")
        //read plist
        guard let base = Shell(launchPath: "pwd").run().outPipeMsg else { writeMessage("Cannot get Url", to: .error); exit(1) }
        let path = URL(fileURLWithPath: base).appendingPathComponent("moduleList.plist")
        var nsDict: NSDictionary?
        do {
            try nsDict = NSDictionary(contentsOf: path, error: ())
        } catch {
            writeMessage(error.localizedDescription)
        }
        if let nsDict = nsDict {
            writeMessage("📙----------------------Found plist----------------------📙")
            var plistDicArr: [String] = []
            for (idx, config) in nsDict.enumerated() {
                let title = (config.key as? String) ?? "error"
                let descri = (config.value as? String) ?? "error"
                writeMessage("\(idx): \(title) - \(descri)")
                plistDicArr.append(title)
            }
            writeMessage("\(plistDicArr.count):" + "\(self.isEnglish ? "Show files changed" : "展示档案更动") - git checkout")
            return plistDicArr
        } else {
            writeMessage("Not Found plist📙")
            writeMessage("0:" + "\(self.isEnglish ? "Show files changed" : "展示档案更动") - git checkout")
            return []
        }
    }
    
    func printDescriptionPrompt() {
        writeMessage(self.isEnglish ? "😺Write a short, imperative tense description of the change:" : "😺重点描述本次改动(必填)")
    }
    
    func printLongDescriptionPrompt() {
        writeMessage(self.isEnglish ? "😺Provide a longer description of the change: (press enter to skip):" : "😺详细描述本次改动(空白略过)")
    }
}
