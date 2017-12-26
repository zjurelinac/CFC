int f(int x) {
    return (x < 0) ? -x : x;
}

int g(int x, int y) {
    return f(x) + f(y);
}