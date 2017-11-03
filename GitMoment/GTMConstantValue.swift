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
    
    enum Styles {
        
        enum Sizes {
            static let gutter: CGFloat = 15
            static let eventGutter: CGFloat = 8
            static let icon = CGSize(width: 20, height: 20)
            static let buttonIcon = CGSize(width: 25, height: 25)
            static let avatarCornerRadius: CGFloat = 3
            static let columnSpacing: CGFloat = 8
            static let rowSpacing: CGFloat = 8
            static let cellSpacing: CGFloat = 15
            static let tableCellHeight: CGFloat = 44
            static let tableCellHeightLarge: CGFloat = 55
            static let tableSectionSpacing: CGFloat = 35
            static let avatar = CGSize(width: 30, height: 30)
            static let inlineSpacing: CGFloat = 4
            static let listInsetLarge = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            static let listInsetLargeHead = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
            static let listInsetLargeTail = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
            static let listInsetTight = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
            static let textCellInset = UIEdgeInsets(
                top: 0,
                left: Styles.Sizes.gutter,
                bottom: Styles.Sizes.rowSpacing,
                right: Styles.Sizes.gutter
            )
            static let textViewInset = UIEdgeInsets(
                top: Styles.Sizes.rowSpacing,
                left: Styles.Sizes.gutter,
                bottom: Styles.Sizes.rowSpacing,
                right: Styles.Sizes.gutter
            )
            static let labelEventHeight: CGFloat = 30
            
            enum Text {
                static let body: CGFloat = 16
                static let secondary: CGFloat = 13
                static let title: CGFloat = 14
                static let button: CGFloat = 16
                static let headline: CGFloat = 18
                static let smallTitle: CGFloat = 12
                static let h1: CGFloat = 24
                static let h2: CGFloat = 22
                static let h3: CGFloat = 20
                static let h4: CGFloat = 18
                static let h5: CGFloat = 16
                static let h6: CGFloat = 16
            }
            
            enum HTML {
                static let boldWeight = 600
                static let spacing = 16
            }
        }
        
        enum Fonts {
            static let body = UIFont.systemFont(ofSize: Styles.Sizes.Text.body)
            static let bodyBold = UIFont.boldSystemFont(ofSize: Styles.Sizes.Text.body)
            static let bodyItalic = UIFont.italicSystemFont(ofSize: Styles.Sizes.Text.body)
            static let secondary = UIFont.systemFont(ofSize: Styles.Sizes.Text.secondary)
            static let secondaryBold = UIFont.boldSystemFont(ofSize: Styles.Sizes.Text.secondary)
            static let title = UIFont.boldSystemFont(ofSize: Styles.Sizes.Text.title)
            static let button = UIFont.systemFont(ofSize: Styles.Sizes.Text.button)
            static let headline = UIFont.boldSystemFont(ofSize: Styles.Sizes.Text.headline)
            static let smallTitle = UIFont.boldSystemFont(ofSize: Styles.Sizes.Text.smallTitle)
            static let code = UIFont(name: "Courier", size: Styles.Sizes.Text.body)!
            static let secondaryCode = UIFont(name: "Courier", size: Styles.Sizes.Text.secondary)!
        }
        
        enum Colors {
            
            static let purple = "6f42c1"
            static let blueGray = "8697af"
            
            enum Red {
                static let medium = "cb2431"
                static let light = "ffeef0"
            }
            
            enum Green {
                static let medium = "28a745"
                static let light = "e6ffed"
            }
            
            enum Blue {
                static let medium = "0366d6"
                static let light = "f1f8ff"
            }
            
            enum Gray {
                static let dark = "24292e"
                static let medium = "586069"
                static let light = "a3aab1"
                static let lighter = "f6f8fa"
                static let border = "bcbbc1"
                
                static let alphaLighter = UIColor(white: 0, alpha: 0.10)
            }
            
            enum Yellow {
                static let medium = "f29d50"
                static let light = "fff5b1"
            }
            
        }
    }
    
    static let htmlHead = """
    <!DOCTYPE html><html><head>
    <style>
    body{
    // html whitelist: https://github.com/jch/html-pipeline/blob/master/lib/html/pipeline/sanitization_filter.rb#L45-L49
    // lint compiled style with http://csslint.net/
    font-family: -apple-system; font-size: \(Styles.Sizes.Text.body)px;
    color: #\(Styles.Colors.Gray.dark);
    padding: \(Styles.Sizes.columnSpacing)px \(Styles.Sizes.gutter)px 0;
    margin: 0;
    }
    b, strong{font-weight: \(Styles.Sizes.HTML.boldWeight);}
    i, em{font-style: italic;}
    a{color: #\(Styles.Colors.Blue.medium); text-decoration: none;}
    h1{font-size: \(Styles.Sizes.Text.h1);}
    h2{font-size: \(Styles.Sizes.Text.h2);}
    h3{font-size: \(Styles.Sizes.Text.h3);}
    h4{font-size: \(Styles.Sizes.Text.h4);}
    h5{font-size: \(Styles.Sizes.Text.h5);}
    h6, h7, h8{font-size: \(Styles.Sizes.Text.h6)px; color: #\(Styles.Colors.Gray.medium);}
    dl dt{margin-top: \(Styles.Sizes.HTML.spacing)px; font-style: italic; font-weight: \(Styles.Sizes.HTML.boldWeight);}
    dl dd{padding: 0 \(Styles.Sizes.HTML.spacing)px;}
    blockquote{font-style: italic; color: #\(Styles.Colors.Gray.medium);}
    pre, code{background-color: #\(Styles.Colors.Gray.lighter); font-family: Courier;}
    pre{padding: \(Styles.Sizes.columnSpacing)px \(Styles.Sizes.gutter)px;}
    sub{font-family: -apple-system;}
    table{border-spacing: 0; border-collapse: collapse;}
    th, td{border: 1px solid #\(Styles.Colors.Gray.border); padding: 6px 13px;}
    th{font-weight: \(Styles.Sizes.HTML.boldWeight); text-align: center;}
    img{max-width:100%; box-sizing: border-box;}
    </style>
    </head><body>
    """
    static let htmlTail = """
    <script>
        document.documentElement.style.webkitUserSelect='none';
        document.documentElement.style.webkitTouchCallout='none';
    </script>
    </body>
    </html>
    """
}
