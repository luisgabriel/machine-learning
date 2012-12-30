function in_window = in_window(current, di, dj, w)
    s = (1 - w) / (1 + w);
    in_window = min(di/dj, dj/di) > s;
