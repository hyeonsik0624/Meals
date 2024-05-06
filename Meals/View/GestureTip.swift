//
//  GestureTip.swift
//  Meals
//
//  Created by 진현식 on 5/6/24.
//

import SwiftUI
import TipKit

struct GestureTip: Tip {
    var title: Text {
        Text("스와이프하여 변경하기")
    }
    
    var message: Text? {
        Text("화면을 스와이프하면\n날짜와 아침/점심/저녁을 변경할 수 있어요")
    }
    
    var image: Image? {
        Image(systemName: "hand.draw")
    }
}
