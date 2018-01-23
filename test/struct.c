struct pair {
    int x, y;
};

int same(struct pair *p) {
    return p->x == p->y;
}

void inc_fst(struct pair *p) {
    ++(p->x);
}

void inc_snd(struct pair *p) {
    ++(p->y);
}

struct pair do_stuff(int x, int y) {
    struct pair p = {x, y};
    if (same(&p))
        inc_fst(&p);
    else
        inc_snd(&p);
    return p;
}