function draw_channels(source, x, y, w, h) {
    local xp = 10;
    local yp = 10;
    local w2 = floor((w - xp) / 2);
    local h2 = floor((h - yp) / 2);

    local r1 = ::fe.add_clone(source);
    r1.visible = true;
    r1.set_pos(x, y, w2, h2);

    local r2 = ::fe.add_clone(r1);
    r2.set_pos(x+xp+w2, y, w2, h2);
    r2.set_rgb(255, 0, 0);

    local r3 = ::fe.add_clone(r1);
    r3.set_pos(x, y+yp+h2, w2, h2);
    r3.set_rgb(0, 255, 0);

    local r4 = ::fe.add_clone(r1);
    r4.set_pos(x+xp+w2, y+yp+h2, w2, h2);
    r4.set_rgb(0, 0, 255);
}
