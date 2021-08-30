//
//  StringsForLocale.swift
//  Navigation
//
//  Created by Dmitrii KRY on 17.07.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation

enum StringsForLocale: String {
    
    case tabFeed = "TAB_FEED"
    case tabProfile = "TAB_PROFILE"
    case tabFavorite = "TAB_FAVORITE"
    case jsonSer = "JSON_SER_EXP"
    case codable = "CODABLE_EXP"
    case decoder = "DECODER_EXP"
    case music = "MUSIC_EXP"
    case httpStatus = "HTTP_STATUS"
    case httpHeader = "HTTP_HEADER"
    case httpResp = "HTTP_RESP"
    case httpTitle = "HTTP_TITLE"
    case httpOrbital = "HTTP_ORBITAL"
    case httpResidents = "HTTP_RESIDENTS"
    case profileStatusButt = "PROFILE_STAT_BTT"
    case profilePhotos = "PROFILE_PHOTOS"
    case profileLikes = "LIKE"
    case profileViews = "PROFILE_VIEWS"
    case photoGal = "PHOTO_GAL"
    case deleteAll = "DELETE_ALL"
    case enterAuthor = "ENTER_AUTHOR"
    case apply = "APPLY"
    case emailOrPhone = "EMAIL_OR_PHONE"
    case password = "PASSWORD"
    case signIn = "SIGN_IN"
    case passwordSelection = "PASSWORD_SELECTION"
    case login = "LOGIN"
    case loginError = "LOGIN_ERROR"
    case loginErrorText = "LOGIN_ERROR_TEXT"
    case createAccount = "CREATE_ACCOUNT"
    case tryAgain = "TRY_AGAIN"
    case success = "SUCCESS"
    case accountIsCreated = "ACCOUNT_IS_CREATED"
    case signUp = "SIGN_UP"
    case auth = "AUTH"
    case authText = "AUTH_TEXT"
    case reg = "REG"
    case regText = "REG_TEXT"
    case cancel = "CANCEL"
    case author = "AUTHOR"
    case wait = "WAIT"
    case maps = "MAPS"
    
    var localaized: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
