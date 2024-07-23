//
//  StepStepObject.swift
//  YapePrueba
//
//  Created by iMac on 19/07/24.
//

import Foundation
struct StepStepObject: Identifiable {
    var id: String
    var step: String
    init(
        id: String,
        step: String){
            self.id = id
            self.step = step
        }
}
