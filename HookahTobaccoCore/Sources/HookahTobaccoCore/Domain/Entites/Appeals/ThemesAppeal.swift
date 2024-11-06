//
//  ThemesAppeal.swift
//
//
//  Created by Anton Kochetkov on 17.09.2023.
//

public struct ThemesAppeal {
    public let themes: [ThemeAppeal]
    public let user: ThemeAppealUser?
    
    init(dto: ThemesAppealDTO) {
        self.themes = dto.themes.map { .init(dto: $0) }
        self.user = ThemeAppealUser(dto: dto.user)
    }
}

public struct ThemeAppeal {
    public let id: Int
    public let name: String
    public let isContent: Bool
    
    internal init(dto: ThemeAppealDTO) {
        self.id = dto.id
        self.name = dto.name
        self.isContent = dto.is_content
    }
}

public struct ThemeAppealUser {
    public let id: Int
    public let name: String
    public let email: String
    
    internal init?(dto: ThemeAppealUserDTO?) {
        guard let dto else { return nil }
        self.id = dto.id
        self.name = dto.name
        self.email = dto.email
    }
}
