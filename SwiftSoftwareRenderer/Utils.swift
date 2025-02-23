//
//  Utils.swift
//  SwiftSoftwareRenderer
//
//  Created by Nishchai Chawla on 2/23/25.
//


import Foundation

struct Utils { }
public func PrintLogs(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let className = file.components(separatedBy: "/").last ?? ""
    let classNameArr = className.components(separatedBy: ".")
    NSLog("\n\n--> Class Name:  \(classNameArr[0]) \n--> Function Name: \(function) \n--> Line: \(line)")
    print("--> Log Message: \(message)")
    #endif
}
