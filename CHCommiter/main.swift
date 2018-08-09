//
//  main.swift
//  CHCommiter
//
//  Created by 郭介騵 on 2018/8/6.
//  Copyright © 2018 james12345. All rights reserved.
//
import Foundation

let param = Parameter()
let console = ConsoleIO()

console.debug_Env()
//Welcome
console.printHelloMessage()

switch param.mode {
case .commit:
    CommiterProgram.main()
case .push:
    PushProgram.main()
case .check(let isInject):
    if isInject {
        
    } else {
        CheckPorgram.main(true)
    }
}
exit(0)
