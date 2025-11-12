package com.EmotiCare.Entities;

public enum Role {
    USER(new Permission[]{Permission.READ_PRIVILEGES}),
    ADMIN(new Permission[]{Permission.READ_PRIVILEGES, Permission.WRITE_PRIVILEGES});

    private final Permission[] permissions;

    Role(Permission[] permissions) {
        this.permissions = permissions;
    }

    public Permission[] getPermissions() { return permissions; }
}

