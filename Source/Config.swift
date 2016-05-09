//
//  Config.swift
//  Pods
//
//  Created by Craig Pearlman on 2015-07-02.
//
//

import Foundation

// MARK: - Config Struct

struct Config<T> {
    var style: AlertActionStyle
    var state: AlertActionState
    var value: T
}

// MARK: - Config<T>: Equatable

extension Config: Equatable {}

func ==<T>(lhs: Config<T>, rhs: Config<T>) -> Bool {
    if lhs.style == rhs.style && lhs.state == rhs.state {
        return true
    }
    else {
        return false
    }
}

func ==<T>(lhs: Config<T>, rhs: (style: AlertActionStyle, state: AlertActionState)) -> Bool {
    if lhs.style == rhs.style && lhs.state == rhs.state {
        return true
    }
    else {
        return false
    }
}

// MARK: - Config Helper Static Methods
internal class ConfigHelper {
    class func findConfig<T>(inArray array: [Config<T>], withStyle style: AlertActionStyle, andState state: AlertActionState) -> (Config<T>, Int)? {
        for i in 0..<array.count {
            if array[i] == (style, state) {
                return (array[i], i)
            }
        }
        
        return nil
    }
    
    class func findConfigValue<T>(inArray array: [Config<T>], withStyle style: AlertActionStyle, andState state: AlertActionState) -> T? {
        if let (config, _) = ConfigHelper.findConfig(inArray: array, withStyle: style, andState: state) {
            return config.value
        }
        
        return nil
    }
    
    class func removeConfig<T>(inout inArray array: [Config<T>], withStyle style: AlertActionStyle, andState state: AlertActionState) {
        if let (_, index) = ConfigHelper.findConfig(inArray: array, withStyle: style, andState: state) {
            array.removeAtIndex(index)
        }
    }
    
    class func updateConfig<T>(inout inArray array: [Config<T>], withStyle style: AlertActionStyle, andState state: AlertActionState, value: T) {
        ConfigHelper.removeConfig(inArray: &array, withStyle: style, andState: state)
        array.append(Config<T>(style: style, state: state, value: value))
    }
    
    class func configValue<T>(from array: [Config<T>], forButtonStyle style: AlertActionStyle, state: AlertActionState) -> T? {
        if let color = ConfigHelper.findConfigValue(inArray: array, withStyle: style, andState: state) {
            return color
        }
        
        if let color = ConfigHelper.findConfigValue(inArray: array, withStyle: .`default`, andState: .normal){
            return color
        }
        
        return nil
    }
    
    class func setConfigValue<T>(value: T, inout inArray array: [Config<T>], forButtonStyle style: AlertActionStyle, state: AlertActionState) {
        ConfigHelper.updateConfig(inArray: &array, withStyle: style, andState: state, value: value)
    }
}
