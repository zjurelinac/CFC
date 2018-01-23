#ifndef __STD_CTYPE__
#define __STD_CTYPE__

int isalnum(char c) {
    return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9');
}

int isalpha(char c) {
    return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
}

int isblank(char c) {
    return (c == 0x09) || (c == 0x20);
}

int iscntrl(char c) {
    return c < 0x20;
}

int isdigit(char c) {
    return c >= '0' && c <= '9';
}

int isgraph(char c) {
    return c >= 0x21 && c <= 0x7E;
}

int islower(char c) {
    return c >= 'a' && c <= 'z';
}

int isprint(char c) {
    return c >= 0x20 && c <= 0x7E;
}

int ispunct(char c) {
    return (c >= 0x21 && c <= 0x2F) || (c >= 0x3A && c <= 0x40) ||
           (c >= 0x5B && c <= 0x60) || (c >= 0x7B && c <= 0x7E);
}

int isspace(char c) {
    return (c >= 0x09 && c <= 0x0D) || (c == 0x20);
}

int isupper(char c) {
    return c >= 'A' && c <= 'Z';
}

int isxdigit(char c) {
    return (c >= '0' && c <= '9') || (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f');
}

char tolower(char c) {
    return isupper(c) ? c - 'A' + 'a' : c;
}

char toupper(char c) {
    return islower(c) ? c - 'a' + 'A' : c;
}

#endif
