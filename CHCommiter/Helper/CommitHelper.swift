//
//  GitHelper.swift
//  CHCommiter
//
//  Created by 郭介騵 on 2018/8/6.
//  Copyright © 2018 james12345. All rights reserved.
//

import Foundation

class CommitStyle {
    
    var finalCommitMsg: String
    
    init(_ type: CommitType, module: String, description: String, longDescri: String, isEnglish: Bool) {
        var title = type.getInfo(isEnglish: isEnglish).0
        title.removeAll { $0 == " " }
        finalCommitMsg = title + "(\(module)): " + description + (longDescri.count > 0 ? " \n\n \(longDescri)" : "")
    }
    
    enum CommitType: Int, CaseIterable {
        
        init?(_ selection: String) {
            if let rawInt = Int(selection), let type = CommitType(rawValue: rawInt) {
                self = type
            } else {
                return nil
            }
        }
        
        typealias RawValue = Int
        
        case feat       = 0
        case UI         = 1
        case fix        = 2
        case docs       = 3
        case style      = 4
        case refactor   = 5
        case perf       = 6
        case test       = 7
        case pods       = 8
        case framework  = 9
        case release    = 10
        case project    = 11
        case revert     = 12
        
        func getInfo(isEnglish: Bool) -> (String, String) {
            switch self {
            case .feat:
                return ((isEnglish ? "feat " : "版本需求  "),
                        (isEnglish ? "A new feature" : "版本任務/需求"))
            case .UI:
                return ((isEnglish ? "UI   " : "UI改動  "),
                        (isEnglish ? "UI Modify" : "UI調整 改動 或優化"))
            case .fix:
                return ((isEnglish ? "fix  " : "修復Bug "),
                        (isEnglish ? "A bug fix " : "bug / 邏輯修正"))
            case .docs:
                return ((isEnglish ? "docs " : "文檔    "),
                        (isEnglish ? "Documentation changes or Comment:" : "額外文檔 / 註釋補充"))
            case .style:
                return ((isEnglish ? "style" : "代碼格式  "),
                        (isEnglish ? "Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc) " : "調整代碼以降低warning/deprecate...等"))
            case .refactor:
                return ((isEnglish ? "refactor" : "重構     "),
                        (isEnglish ? "A code change that neither fixes a bug nor adds a feature " : "OC/Swift重構, 模塊重寫, 改用其他工具,實現方法...等"))
            case .perf:
                return ((isEnglish ? "perf " : "效能優化  "),
                        (isEnglish ? "A code change that improves performance " : "效能優化, 邏輯優化, 代碼優化"))
            case .test:
                return ((isEnglish ? "test " : "測試        "),
                        (isEnglish ? "Adding missing tests or correcting existing tests" : "測試"))
            case .pods:
                return ((isEnglish ? "pods " : "Pods改動    "),
                        (isEnglish ? "Changes include add/remove pod in 'Podfile', pod install, pod update" : "有任何會導致Pod文件改動之操作 (pod install, pod update)"))
            case .framework:
                return ("framework ",
                        isEnglish ? "Add/remove/rebuild  static/dynamic framework" : "新增/移除/改動 靜態/動態 Framework")
            case .release:
                return ("release   ",
                        isEnglish ? "Add Tag , Relase configuration" : "release 參數, 標籤...")
            case .revert:
                return ("revert    ",
                        isEnglish ? "Reverts a previous commit" : "revert 一個commit")
            case .project:
                return ((isEnglish ? "project  " : "project更動  "),
                        (isEnglish ? "Changes of xcodeproj, ex. (build Setting, build phase ..)" : "xcodeproj更動 包括 building Setting, build phase ...改動"))
            }
        }
    }
    
}
