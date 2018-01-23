int strlen(const char *p) {
    int i = 0;
    while(p[i++] != '\0');
    return i;
}

void strcpy(char *dst, const char *src) {
    while (*src != '\0')
        *(dst++) = *(src++);
    *dst = '\0';
}

void strncpy(char *dst, const char *src, int n) {
    for (int i = 0; i < n && *src != '\0'; ++i, ++src, ++dst)
        *dst = *src;
}
