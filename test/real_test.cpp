int mod(int x, int y) {
    while (x > y) x -= y;
    return x;
}

int sqrt(int x) {
    int i = 0;
    for (; i*i <= x; ++i) {}
    return i-1;
}

/*bool is_prime(int x) {
    int sq = sqrt(x);
    for (int i = 2; i <= sq; ++i)
        if (mod(x, i) == 0)
            return false;
    return true;
}*/

int isdigit(char c) {
    return c >= '0' && c <= '9';
}

int atoi(char* p) {
    int i = 0;
    while (isdigit(*p))
        i = i*10 + *(p++) - '0';
    return i;
}

int main(int argc, char* argv[]) {
    return sqrt(atoi(argv[1]));
}