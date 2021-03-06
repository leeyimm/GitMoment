//
//  GTMConstantValue.swift
//  GitMoment
//
//  Created by liying on 14/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import Foundation
import UIKit

class GTMConstantValue {
    static let languageList = ["All Languages",
                        "ABAP",
                        "AGS Script",
                        "ANTLR",
                        "APL",
                        "ASP",
                        "ATS",
                        "ActionScript",
                        "Ada",
                        "Agda",
                        "Alloy",
                        "ApacheConf",
                        "Apex",
                        "AppleScript",
                        "Arc",
                        "Arduino",
                        "AspectJ",
                        "Assembly",
                        "Augeas",
                        "AutoHotkey",
                        "AutoIt",
                        "Awk",
                        "Batchfile",
                        "Bison",
                        "BitBake",
                        "BlitzBasic",
                        "BlitzMax",
                        "Bluespec",
                        "Boo",
                        "Brainfuck",
                        "Brightscript",
                        "Bro",
                        "C",
                        "C#",
                        "C++",
                        "CLIPS",
                        "CMake",
                        "COBOL",
                        "CSS",
                        "Ceylon",
                        "Chapel",
                        "Cirru",
                        "Clean",
                        "Clojure",
                        "CoffeeScript",
                        "ColdFusion",
                        "Common Lisp",
                        "Component Pascal",
                        "Cool",
                        "Coq",
                        "Crystal",
                        "Cuda",
                        "Cycript",
                        "D",
                        "DCPU-16 ASM",
                        "DM",
                        "DOT",
                        "Dart",
                        "Delphi",
                        "Dogescript",
                        "Dylan",
                        "E",
                        "Ecl",
                        "Eiffel",
                        "Elixir",
                        "Elm",
                        "Emacs Lisp",
                        "EmberScript",
                        "Erlang",
                        "F#",
                        "FLUX",
                        "FORTRAN",
                        "Factor",
                        "Fancy",
                        "Fantom",
                        "Forth",
                        "Frege",
                        "GAMS",
                        "GAP",
                        "GDScript",
                        "Game Maker Language",
                        "Glyph",
                        "Gnuplot",
                        "Go",
                        "Golo",
                        "Gosu",
                        "Grace",
                        "Grammatical Framework",
                        "Groovy",
                        "HTML",
                        "HaXe",
                        "Hack",
                        "Harbour",
                        "Haskell",
                        "Haxe",
                        "Hy",
                        "IDL",
                        "IGOR Pro",
                        "Idris",
                        "Inform 7",
                        "Io",
                        "Ioke",
                        "Isabelle",
                        "J",
                        "JSONiq",
                        "Jasmin",
                        "Java",
                        "JavaScript",
                        "Julia",
                        "KRL",
                        "Kotlin",
                        "LOLCODE",
                        "LSL",
                        "LabVIEW",
                        "Lasso",
                        "LiveScript",
                        "Logos",
                        "Logtalk",
                        "LookML",
                        "LoomScript",
                        "Lua",
                        "M",
                        "Makefile",
                        "Mathematica",
                        "Matlab",
                        "Max",
                        "Mercury",
                        "Mirah",
                        "Monkey",
                        "Moocode",
                        "MoonScript",
                        "Nemerle",
                        "NetLogo",
                        "Nimrod",
                        "Nit",
                        "Nix",
                        "Nu",
                        "OCaml",
                        "Objective-C",
                        "Objective-C++",
                        "Objective-J",
                        "Omgrofl",
                        "Opa",
                        "Opal",
                        "OpenEdge ABL",
                        "OpenSCAD",
                        "Ox",
                        "Oxygene",
                        "Oz",
                        "PAWN",
                        "PHP",
                        "PLSQL",
                        "Pan",
                        "Papyrus",
                        "Parrot",
                        "Pascal",
                        "Perl",
                        "Perl6",
                        "PigLatin",
                        "Pike",
                        "PogoScript",
                        "PowerShell",
                        "Powershell",
                        "Processing",
                        "Prolog",
                        "Propeller Spin",
                        "Protocol Buffer",
                        "Puppet",
                        "Pure Data",
                        "PureBasic",
                        "PureScript",
                        "Python",
                        "R",
                        "REALbasic",
                        "Racket",
                        "Ragel in Ruby Host",
                        "Rebol",
                        "Red",
                        "RobotFramework",
                        "Rouge",
                        "Ruby",
                        "Rust",
                        "SAS",
                        "SQF",
                        "SQL",
                        "Scala",
                        "Scheme",
                        "Scilab",
                        "Self",
                        "Shell",
                        "Shen",
                        "Slash",
                        "Smalltalk",
                        "SourcePawn",
                        "Squirrel",
                        "Standard ML",
                        "Stata",
                        "SuperCollider",
                        "Swift",
                        "SystemVerilog",
                        "TXL",
                        "Tcl",
                        "TeX",
                        "Thrift",
                        "Turing",
                        "TypeScript",
                        "UnrealScript",
                        "VCL",
                        "VHDL",
                        "Vala",
                        "Verilog",
                        "VimL",
                        "Visual Basic",
                        "Volt",
                        "WebIDL",
                        "XC",
                        "XML",
                        "XProc",
                        "XQuery",
                        "XSLT",
                        "Xojo",
                        "Xtend",
                        "Zephir",
                        "Zimpl"]
    
    static let periods = ["Daily", "Weekly", "Monthly"]
    static let locations = ["world", "country", "city"]
    enum GTMLocationType  {
        case GTMLocationWorld
        case GTMLocationCountry (String)
        case GTMLocationCity (String)
        
        func description () -> String {
            var string : String
            switch self {
            case .GTMLocationWorld:
                string = "world"
            case .GTMLocationCountry(let country):
                string = country
            case .GTMLocationCity(let city):
                string = city
            }
            return string
        }
    }
    
    static let userChosenLanguageKey = "userChosenLanguage"
    static let rankingPerpageCount = 25
    static let githubPerpageCount = 30
    
    static let GithubHTMLTemplateString = "<html><head><meta charset='utf-8'>" +
    "<meta name=\"viewport\" content=\"initial-scale=1.0,user-scalable=no,maximum-scale=1,width=device-width\">" +
    "<link crossorigin=\"anonymous\" href=\"mobile-github.css\" media=\"all\" rel=\"stylesheet\"/>" +
    "<script type=\"text/javascript\" src=\"main.js\"></script>" +
    "<title>%@</title></head><body onload=\"onLoaded()\">%@</body></html>"
    
    static let issueHeaderCellIdentifier = "issueHeaderCell"
    static let authorInfoCellIdentifier = "authorCell"
    static let attributedContentCellIdentifier = "attributedContentCell"
    static let baseCellIdentifier = "baseCell"
    static let updatedFileInfoCellIdentifier = "updatedFileInfoCell"
    

}

enum GTMFollowingType {
    case following
    case watching
    case starring
}

