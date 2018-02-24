int strlen(const char *p) {
    int i = 0;
    while(p[i++] != '\0');
    return i;
}