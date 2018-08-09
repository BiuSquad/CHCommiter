//
//  PushProgram.swift
//  CHCommiter
//
//  Created by 郭介騵 on 2018/8/8.
//  Copyright © 2018 james12345. All rights reserved.
//

import Foundation

class PushProgram {
    
    public class func main() {
        CheckPorgram.main()
        push()
    }
    
    private class func push() {
        let pushShell = Shell(launchPath: "git", arguments: ["push"], errorHandler: { (errMsg) in
            guard let err = errMsg else { return }
            console.writeMessage(err)
            exit(1)
        }).run()
        console.writeMessage(pushShell.outPipeMsg ?? "push done")
    }
    
}
