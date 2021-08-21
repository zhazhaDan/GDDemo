//
//  PropertyWrapperVC.swift
//  GDDemo
//
//  Created by GDD on 2020/11/18.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

class PropertyWrapperVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var bar = Bar(x: 0)
        bar.x = 10
        let value = bar.x
        bar.$x.foo()
        // Do any additional setup after loading the view.
        print(UserDefaultsConfig.guide)
        UserDefaultsConfig.guide = true
        print(UserDefaultsConfig.guide)
        print(UserDefaultsConfig.$guide.key)
    }

}

@propertyWrapper
struct ConsoleLogged<Value> {
    private var value: Value
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    var wrappedValue: Value {
        get {
            print("Value is \(value)")
            return value
        }
        set {
            print("Old value is \(value)")
            value = newValue
            print("New value is \(newValue)")
        }
    }

    var projectedValue: ConsoleLogged<Value> { return self }

    func foo() {
        print("foo")
    }
}

struct Bar {
//    private var _x = ConsoleLogged<Int>.init(wrappedValue: 0)
//    var x: Int {
//        get { _x.wrappedValue }
//        set { _x.wrappedValue = newValue }
//    }
    @ConsoleLogged var x: Int

    func foo() {
        print(_x.foo())
        print($x.foo())
    }
}




@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, _ defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }

    var projectedValue: UserDefault<T> { return self }
}


struct UserDefaultsConfig {
    @UserDefault("first", false)
    static var guide: Bool
}
