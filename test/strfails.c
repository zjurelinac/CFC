int strcmp(char *fst, char *snd) {
    while (*fst != '\0' && *snd != '\0' && *fst == *snd) {
        ++fst; ++snd;
    }

    if (*fst == *snd) return 0;
    else if (*fst < *snd) return -1;
    else return 1;

    return 0;
}

int atoi(char *p) {
    int i = 0;
    while (isdigit(*p)) {
        char c = *p;
        int d = c - '0';
        i = (i << 3) + (i << 1) + d;
    }
    return i;
}

void memcpy(void *dst, const void* src, int n) {
    char *cdst = (char*) dst, *csrc = (char*) src;
    for (int i = 0; i < n; ++i, ++csrc, ++cdst)
        *cdst = *csrc;
}
