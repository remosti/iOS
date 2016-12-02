//
//  MusicChartsParser.swift
//  Music Cover Quiz
//
//  Created by Valentin Schuler on 28.11.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import Foundation


func loadQuizData() {
    do {
        if let url = URL(string: "https://docs.google.com/spreadsheets/d/e/2PACX-1vRQPm1zu6hsYP1GPjKaxmSeEGV75EcANvo7ktl963vNt-ozLmWKopkRHMp2EIl-eOKP9UzDUj6v4wmM/pub?gid=0&single=true&output=csv") {
            
            let content = try String(contentsOf: url)
            print(content)
            
            let csv = CSwiftV(with: content)
            
            let rows = csv.rows
            let keyedRows = csv.keyedRows
        }
    } catch {
        // handle error
    }
}

