//
//  BFGAlertConfig.swift
//  Pods
//
//  Created by Craig Pearlman on 2015-07-02.
//
//

import Foundation

// MARK: - Config Struct

struct BFGAlertConfig<T> {
    var style: BFGAlertActionStyle
    var state: BFGAlertActionState
    var value: T
}

// MARK: - BFGAlertConfig<T>: Equatable

extension BFGAlertConfig: Equatable {}

func ==<T>(lhs: BFGAlertConfig<T>, rhs: BFGAlertConfig<T>) -> Bool {
    if lhs.style == rhs.style && lhs.state == rhs.state {
        return true
    }
    else {
        return false
    }
}

func ==<T>(lhs: BFGAlertConfig<T>, rhs: (style: BFGAlertActionStyle, state: BFGAlertActionState)) -> Bool {
    if lhs.style == rhs.style && lhs.state == rhs.state {
        return true
    }
    else {
        return false
    }
}

// MARK: - Config Helper Static Methods
class BFGAlertConfigHelper {
    class func findConfig<T>(inArray array: [BFGAlertConfig<T>], withStyle style: BFGAlertActionStyle, andState state: BFGAlertActionState) -> (BFGAlertConfig<T>, Int)? {
        for i in 0..<array.count {
            if array[i] == (style, state) {
                return (array[i], i)
            }
        }
        
        return nil
    }
    
    class func findConfigValue<T>(inArray array: [BFGAlertConfig<T>], withStyle style: BFGAlertActionStyle, andState state: BFGAlertActionState) -> T? {
        if let (config, _) = BFGAlertConfigHelper.findConfig(inArray: array, withStyle: style, andState: state) {
            return config.value
        }
        
        return nil
    }
    
    class func removeConfig<T>(inout inArray array: [BFGAlertConfig<T>], withStyle style: BFGAlertActionStyle, andState state: BFGAlertActionState) {
        if let (_, index) = BFGAlertConfigHelper.findConfig(inArray: array, withStyle: style, andState: state) {
            array.removeAtIndex(index)
        }
    }
    
    class func updateConfig<T>(inout inArray array: [BFGAlertConfig<T>], withStyle style: BFGAlertActionStyle, andState state: BFGAlertActionState, value: T) {
        BFGAlertConfigHelper.removeConfig(inArray: &array, withStyle: style, andState: state)
        array.append(BFGAlertConfig<T>(style: style, state: state, value: value))
    }
    
    class func configValue<T>(from array: [BFGAlertConfig<T>], forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> T? {
        if let color = BFGAlertConfigHelper.findConfigValue(inArray: array, withStyle: style, andState: state) {
            return color
        }
        
        if let color = BFGAlertConfigHelper.findConfigValue(inArray: array, withStyle: .Default, andState: .Normal){
            return color
        }
        
        return nil
    }
    
    class func setConfigValue<T>(value: T, inout inArray array: [BFGAlertConfig<T>], forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        BFGAlertConfigHelper.updateConfig(inArray: &array, withStyle: style, andState: state, value: value)
    }
}
