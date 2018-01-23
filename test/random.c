static int holdrand = 0;

void srand(unsigned seed) {
    holdrand = seed;
}

int rand() {
    return ((holdrand = holdrand * 214013 + 2531011) >> 16) & 0x7fff;
}