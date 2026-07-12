syms x;
dy = diff(log((x + 2) /(1-x)), 3);
dy = simplify(dy);
pretty(dy);