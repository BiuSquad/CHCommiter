//
//  Parameter.swift
//  CHCommiter
//
//  Created by 郭介騵 on 2018/8/6.
//  Copyright © 2018 james12345. All rights reserved.
//

import Foundation

///Commit Mode
enum Mode {
    case commit
    case push
    case check(isInject: Bool)
}

///參數
enum OptionType {
 
    case help
    case addAll
    case useEnglish
    
    case pushMode
    
    case commitMode
    
    case check
    case checkInject
    
    case unknown
    
    init(value: String) {
        switch value {
        case "-h": self = .help
        case "-e": self = .useEnglish
        case "-a": self = .addAll
        case "push": self = .pushMode
        case "commit": self = .commitMode
        case "check": self = .check
        case "-i": self = .checkInject
        default: self = .unknown
        }
    }
}

class Parameter {
    
    let mode: Mode
    
    var gitAddAll: Bool = false
    var useEnglish: Bool = false
    
    init() {
        
        func exits() -> Never {
            ConsoleIO().printUsage()
            exit(0)
        }
        
        var nowMode: Mode?
        for (idx, arg) in CommandLine.arguments.enumerated() {
            if idx == 0 { continue }
            let option = OptionType(value: arg)
            switch option {
            case .help:
                exits()
            case .addAll:
                self.gitAddAll = true
            case .unknown:
                exits()
            case .useEnglish:
                self.useEnglish = true
            case .pushMode:
                nowMode = .push
            case .commitMode:
                nowMode = .commit
            case .check:
                nowMode = .check(isInject: false)
            case .checkInject:
                guard let mode = nowMode else { exits() }
                if case .check = mode {
                    nowMode = .check(isInject: true)
                } else { exits() }
            }
        }
        guard let modes = nowMode else {
            ConsoleIO().printUsage()
            exit(0)
        }
        mode = modes
    }

}

