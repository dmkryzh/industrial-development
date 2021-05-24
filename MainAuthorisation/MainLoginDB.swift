//
//  MainLoginDB.swift
//  Navigation
//
//  Created by Dmitrii KRY on 24.05.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import RealmSwift


class Account: Object {
    @objc dynamic var password = ""
    @objc dynamic var login = ""
    static func create(login log: String ,password pas: String) -> Account {
        let account = Account()
        account.password = pas
        account.login = log
        return account
    }
}

class Status: Object {
    @objc dynamic var isLogged = false
    static func create(_ status: Bool) -> Status {
        let checkStatus = Status()
        checkStatus.isLogged = status
        return checkStatus
    }
}
