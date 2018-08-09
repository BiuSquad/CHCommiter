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
                        (isEnglish ? "A new feature" : "版本任务/需求"))
            case .UI:
                return ((isEnglish ? "UI   " : "UI改动  "),
                        (isEnglish ? "UI Modify" : "UI调整 改动 或优化"))
            case .fix:
                return ((isEnglish ? "fix  " : "修复Bug "),
                        (isEnglish ? "A bug fix " : "bug / 逻辑修正"))
            case .docs:
                return ((isEnglish ? "docs " : "文档    "),
                        (isEnglish ? "Documentation changes or Comment:" : "额外文档 / 注释补充"))
            case .style:
                return ((isEnglish ? "style" : "代码格式  "),
                        (isEnglish ? "Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc) " : "调整代码以降低warning/deprecate...等"))
            case .refactor:
                return ((isEnglish ? "refactor" : "重构     "),
                        (isEnglish ? "A code change that neither fixes a bug nor adds a feature " : "OC/Swift重构, 模块重写, 改用其他工具,实现方法...等"))
            case .perf:
                return ((isEnglish ? "perf " : "效能优化  "),
                        (isEnglish ? "A code change that improves performance " : "效能优化, 逻辑优化, 代码优化"))
            case .test:
                return ((isEnglish ? "test " : "测试        "),
                        (isEnglish ? "Adding missing tests or correcting existing tests" : "测试"))
            case .pods:
                return ((isEnglish ? "pods " : "Pods改动    "),
                        (isEnglish ? "Changes include add/remove pod in 'Podfile', pod install, pod update" : "有任何会导致Pod文件改动之操作 (pod install, pod update)"))
            case .framework:
                return ("framework ",
                        isEnglish ? "Add/remove/rebuild  static/dynamic framework" : "新增/移除/改动 静态/动态 Framework")
            case .release:
                return ("release   ",
                        isEnglish ? "Add Tag , Relase configuration" : "release 参数, 标签...")
            case .revert:
                return ("revert    ",
                        isEnglish ? "Reverts a previous commit" : "revert 一个commit")
            case .project:
                return ((isEnglish ? "project  " : "project更动  "),
                        (isEnglish ? "Changes of xcodeproj, ex. (build Setting, build phase ..)" : "xcodeproj更动 包括 building Setting, build phase ...改动"))
            }
        }
    }
    
}
