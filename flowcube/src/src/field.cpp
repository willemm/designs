#include "settings.h"

// Status of playing field
int selected; // currently selected endpoint

unsigned long lastpress = 0;
int lastkey = 0; // Last key pressed
int curkey = 0; // Key currently being held down

struct fieldcell_t {
    union {
        struct { int8_t up, left, down, right, none; };
        int8_t neighbour[5];
    };
    uint8_t pixel[4];
    uint8_t side;
    int8_t next, prev;
    uint8_t dist;
    int8_t color;
    unsigned is_endpoint:1;
    unsigned is_fold:1;
    unsigned is_upfold:1;
};

static_assert(sizeof(fieldcell_t) <= 16, "Size of fieldcell_t is bigger than 16");
static_assert(offsetof(fieldcell_t, up   ) == offsetof(fieldcell_t, neighbour)+0, "Neighbour doesn't match up");
static_assert(offsetof(fieldcell_t, left ) == offsetof(fieldcell_t, neighbour)+1, "Neighbour doesn't match left");
static_assert(offsetof(fieldcell_t, down ) == offsetof(fieldcell_t, neighbour)+2, "Neighbour doesn't match down");
static_assert(offsetof(fieldcell_t, right) == offsetof(fieldcell_t, neighbour)+3, "Neighbour doesn't match right");

#define FIELD_ENDPOINT 0x01
#define FIELD_FOLD 0x02

#define FIELD_UP    0
#define FIELD_LEFT  1
#define FIELD_DOWN  2
#define FIELD_RIGHT 3

#define FSZ 5
#define DSZ (FSZ*2)
#define LEDSZ ((int)(DSZ*DSZ))

#define NUMKEYS (3*FSZ*FSZ)

fieldcell_t field[NUMKEYS];

// Translate from 6 directions to four, depending on cube side
// This way a straight line across a fold always has the same direction number
static const uint8_t step_dirs[3][6] = {
    { 2, 3, 4, 0, 1, 4 },
    { 2, 4, 3, 0, 4, 1 },
    { 4, 2, 3, 4, 0, 1 }
};

static inline uint8_t step_nb(fieldcell_t field, int dir)
{
    return step_dirs[field.side][dir%6];
}

// Find the field index in the given (one of six) direction
static inline int step_dir(fieldcell_t field, int dir)
{
    return field.neighbour[step_nb(field, dir)];
}

// Find the index of the led in the given (one of six) direction
static inline int pixel_dir(fieldcell_t field, int dir)
{
    uint8_t sdir = step_dirs[field.side][dir];
    if (sdir >= 4) {
        debugE("ERROR CANTHAPPEN: Wants to get direction %d on side %d", dir, field.side);
    }
    return ((int)field.side)*LEDSZ + (int)field.pixel[sdir%4];
}


/*
   Field layout:
  
   +-----+      
   |     |      
   | top |      
   | +0  |      
   +-----+-----+
   |     |     |
   |front|right|
   | +25 | +50 |
   +-----+-----+

   +-----------+
   |20 ..  5 0 |
   |21     6 1 |
   |22     7 2 |
   |23     8 3 |
   |24 ..  9 4 |
   +-----------+-----------+
   | 0 1 2 3 4 | 4 9 ..  24|
   | 5 6 7 8 9 | 3 8     23|
   |10         | 2 7     22|
   |15         | 1 6     21|
   |20 ..    24| 0 5 ..  20|
   +-----------+-----------+
 */

static inline int field_idx(int y, int x)
{
    if (y < FSZ) {
        // top
        return (FSZ-1-x)*FSZ + y;
        //return (FSZ-1)*FSZ - x*FSZ + y;
    } else if (x < FSZ) {
        // front
        return FSZ*FSZ + (y-FSZ)*FSZ + x;
        //return y*FSZ + x;
    } else {
        // right
        return FSZ*FSZ*2 + (x-FSZ)*FSZ + (FSZ-1-(y-FSZ));
        //return FSZ*FSZ + 2*FSZ - 1 + x*FSZ - y;
    }
}

void field_init()
{
    for (int y = 0; y < DSZ; y++) {
        // Upper right quadrand is not used
        int xsz = ((y >= FSZ) ? DSZ : FSZ);
        for (int x = 0; x < xsz; x++) {
            int idx = field_idx(y,x);
            ledset_t cell = leds_keyidx(idx);
            int cellrot = (idx/(FSZ*FSZ)); // Rotate by 1 or 2 steps depending on face
            field[idx].side = cell.side;
            field[idx].pixel[(cellrot+0)%4] = cell.left;   // up
            field[idx].pixel[(cellrot+1)%4] = cell.down;   // right
            field[idx].pixel[(cellrot+2)%4] = cell.left^1; // down
            field[idx].pixel[(cellrot+3)%4] = cell.down^1; // left
            field[idx].none = -1;
            field[idx].up = -1;
            field[idx].left = -1;
            field[idx].prev = 4;
            field[idx].next = 4;
            field[idx].is_fold = 0;
            field[idx].is_endpoint = 0;
            if ((x == FSZ-1) && (y < FSZ)) {
                // Right edge of upper left folds to top of lower right
                field[idx].right = field_idx(DSZ-1-x, DSZ-1-y);
                field[idx].is_fold = 1;
            } else if (x == DSZ-1) {
                // Sentinel value for no right neighbour
                field[idx].right = -1;
            } else {
                field[idx].right = field_idx(y,x+1);
            }
            // Down never folds
            if (y == DSZ-1) {
                field[idx].down = -1;
            } else {
                field[idx].down = field_idx(y+1,x);
            }
        }
    }
    for (int idx = 0; idx < NUMKEYS; idx++) {
        // Back connections
        int right = field[idx].right;
        if (right >= 0) {
            if (field[idx].is_fold) {
                field[right].is_upfold = 1;
                field[right].up = idx;
            } else {
                field[right].left = idx;
            }
        }
        int down = field[idx].down;
        if (down >= 0) {
            field[down].up = idx;
        }
        debugD("Key %2d: right=%2d down=%2d pixels=[%3d,%3d,%3d,%3d]",
            idx, field[idx].right, field[idx].down,
            field[idx].pixel[0], field[idx].pixel[1],
            field[idx].pixel[2], field[idx].pixel[3]);
    }
}

int8_t field_endpoints[] = {
    3,1, 5,5,
    1,2, 7,2,
    6,5, 5,6,
    5,9, 9,9,
    1,1, 6,6,
    -1
};

static void set_endpoints(int8_t endpoints[])
{
    for (int c = 0; endpoints[c*2] >= 0; c++) {
        debugD("Set endpoint %d: (%d,%d)", c, endpoints[c*2], endpoints[c*2+1]);
        int idx = field_idx(endpoints[c*2], endpoints[c*2+1]);
        field[idx].color = c;
        field[idx].is_endpoint = 1;
    }
}

static inline uint32_t colorscale(uint32_t color, uint32_t brightness)
{
    uint32_t r = (color >> 16) & 0xff;
    r = (r * brightness) / 1000;
    if (r > 255) r = 255;
    uint32_t g = (color >> 8) & 0xff;
    g = (g * brightness) / 1000;
    if (g > 255) g = 255;
    uint32_t b = (color >> 0) & 0xff;
    b = (b * brightness) / 1000;
    if (b > 255) b = 255;
    return (uint32_t)((r << 16) | (g << 8) | (b << 0));
}

static void draw_field(bool debug=false)
{
    pixels.clear();
    for (int idx = 0; idx < NUMKEYS; idx++) {
        int side = ((int)field[idx].side)*LEDSZ;
        int color = field[idx].color;
        if (color >= 0) {
            uint32_t colorval = colors[color/2];
            if (debug) debugV("color = %d, idx=%d, colorval = 0x%06x", color, color/2, colorval);
            // if (color == selected) colorval = colorval*2; // brighten (TODO: do this better)
            if (field[idx].is_endpoint) {
                for (int i = 0; i < 4; i++) {
                    pixels.setPixelColor(side+field[idx].pixel[i], colorval);
                }
            }

            for (int i = 0; i < 3; i++) {
                int dir = step_dir(field[idx], i);
                if ((dir >= 0) && (field[dir].color == color)) {
                    pixels.setPixelColor(pixel_dir(field[idx], i), colorval);
                    pixels.setPixelColor(pixel_dir(field[dir], i+3), colorval);
                    if (debug) debugV("Set pixels between %2d and %2d: (%3d,%3d) = 0x%06x",
                        idx, dir,
                        pixel_dir(field[idx], i), pixel_dir(field[dir], i+3),
                        colorval);
                    }
            }

#if 0
            int right = field[idx].right;
            if ((right >= 0) && (field[right].color == color)) {
                int left = (field[idx].is_fold) ? FIELD_UP : FIELD_LEFT;
                int rside = (int)field[right].side * LEDSZ;
                pixels.setPixelColor(side+field[idx].pixel[FIELD_RIGHT], colorval);
                pixels.setPixelColor(rside+field[right].pixel[left], colorval);
                if (debug) debugV("Set right between %2d and %2d: (%3d,%3d) = 0x%06x",
                    idx, right,
                    side+field[idx].pixel[FIELD_RIGHT], rside+field[right].pixel[left],
                    colorval);
            }
            int down = field[idx].down;
            if ((down >= 0) && (field[down].color == color)) {
                int dside = (int)field[down].side * LEDSZ;
                pixels.setPixelColor(side+field[idx].pixel[FIELD_DOWN], colorval);
                pixels.setPixelColor(dside+field[down].pixel[FIELD_UP], colorval);
                if (debug) debugV("Set down  between %2d and %2d: (%3d,%3d) = 0x%06x",
                    idx, down,
                    side+field[idx].pixel[FIELD_DOWN], dside+field[down].pixel[FIELD_UP],
                    colorval);
            }
#endif
        }
        if (idx == (curkey-1)) {
            uint32_t colorval = pixels.Color(255,255,255);
            for (int i = 0; i < 4; i++) {
                pixels.setPixelColor(side+field[idx].pixel[i], colorval);
            }
        }
    }
    if (selected >= 0) {
        long now = millis();
        int idx = field_idx(field_endpoints[selected*2], field_endpoints[selected*2+1]);
        int len = 0;
        int nxt = idx;
        while (nxt >= 0) {
            len++;
            nxt = field[nxt].neighbour[field[nxt].next];
        }
        int32_t anpos = (now % 2000);
        anpos = anpos * (len+3) / 2 - 2000;
        nxt = idx;
        if (debug) debugV("position %d", anpos);
        while (nxt >= 0) {
            uint32_t colorval = colors[selected/2];
            int32_t aps = anpos;
            if (aps < 0) aps = -aps;
            if (aps <= 2000) {
                if (aps <= 1000) {
                    if (debug) debugV("key %d, brighten", nxt);
                    colorval = colorscale(colorval, 500+(3*(1000-aps)/2));
                } else {
                    if (debug) debugV("key %d, dim", nxt);
                    colorval = colorscale(colorval, aps/2);
                }
            }
            int8_t pd = field[nxt].prev;
            if (pd < 4) {
                if (debug) debugV("Set key %d prev color to 0x%06x", nxt, colorval);
                pixels.setPixelColor(((int)field[nxt].side)*LEDSZ+field[nxt].pixel[pd], colorval);
            } else {
                if (debug) debugV("Set key %d start color to 0x%06x", nxt, colorval);
                for (int pi = 0; pi < 4; pi++) {
                    pixels.setPixelColor(((int)field[nxt].side)*LEDSZ+field[nxt].pixel[pi], colorval);
                }
            }
            int8_t nd = field[nxt].next;
            if (nd < 4) {
                if (debug) debugV("Set key %d next color to 0x%06x", nxt, colorval);
                pixels.setPixelColor(((int)field[nxt].side)*LEDSZ+field[nxt].pixel[nd], colorval);
            }
            nxt = field[nxt].neighbour[nd];
            anpos -= 1000;
        }
    }
    pixels.show();
}

void field_clear()
{
    debugI("Clearing game field");
    for (int idx = 0; idx < NUMKEYS; idx++) {
        field[idx].color = -1;
        field[idx].is_endpoint = 0;
    }
    /*
    int8_t endpoints[] = {
        3,1, 5,5,
        1,2, 7,2,
        6,5, 5,6,
        5,9, 9,9,
        1,1, 6,6,
        -1
    };
    */
    set_endpoints(field_endpoints);
    selected = -1;
    draw_field(true);
    debugI("Inited game field");
}

static const int field_test_lines[5][8] = {
    { 1,2,3,8,9,28,33,32 },
    { 0,5,6,7,12,13,14,27 },
    { 15,20,21,22,23,24,25,30 },
    { 18,19,26,31,36,37,38,43 },
    { 40,45,46,47,48,49,44,39 }
};

static void testdelay(int dly)
{
    for (int d = 0; d < dly; d += 100) {
        delay(100);
        keys_scan();
    }
}

void field_test()
{
    for (int idx = 0; idx < NUMKEYS; idx++) {
        field[idx].color = -1;
        field[idx].is_endpoint = 0;
    }
    debugI("Init field test (field size = %d)", sizeof(fieldcell_t));
    draw_field();
    for (int ln = 0; ln < 5; ln++) {
        testdelay(500);
        debugD("Field test line %d, color 0x%06x, from %2d to %2d (%d,%d)",
            ln, colors[ln+1], field_test_lines[ln][0], field_test_lines[ln][7],
            (ln+1)*2, (ln+1)*2+1);
        selected = ln*2;
        field[field_test_lines[ln][0]].color = ln*2;
        field[field_test_lines[ln][0]].is_endpoint = 1;
        field[field_test_lines[ln][7]].color = ln*2+1;
        field[field_test_lines[ln][7]].is_endpoint = 1;
        draw_field();
        for (int p = 1; p < 7; p++) {
            testdelay(500);
            field[field_test_lines[ln][p]].color = ln*2;
            draw_field();
        }
        testdelay(500);
        field[field_test_lines[ln][7]].color = ln*2;
        draw_field();
    }
    selected = -1;
    testdelay(500);
    draw_field(true);

    testdelay(2000);
}

static void disconnect_chain(int idx)
{
    int nxt = idx;
    // Disconnect last link
    field[idx].prev = 4;
    // First reverse, see if his leads to an endpoint
    while (nxt >= 0) {
        debugD("Reverse %d->%d->%d", field[nxt].prev, nxt, field[nxt].next);
        int nn = field[nxt].next;
        field[nxt].next = field[nxt].prev;
        field[nxt].prev = nn;
        field[nxt].color = field[nxt].color ^ 1;
        if (field[nxt].is_endpoint) {
            // Found an endpoint, so don't turn off
            return;
        }
        nxt = field[nxt].neighbour[nn];
    }
    // There was no endpoint so turn the chain off
    nxt = idx;
    while (nxt >= 0) {
        debugD("Disconnect %d->%d->%d", field[nxt].prev, nxt, field[nxt].next);
        int nn = field[nxt].prev;
        field[nxt].next = 4;
        field[nxt].prev = 4;
        field[nxt].color = -1;
        nxt = field[nxt].neighbour[nn];
    }
}

static void press_key(int key)
{
    int color = field[key].color;
    if (selected >= 0) {
        debugI("Press key %d, check for neighbour with selected color %d", key, selected);
        int fnd = -1;
        int mindist = 1000;
        for (int n = 0; n < 6; n++) {
            int nb = step_dir(field[key], n);
            if (nb >= 0) {
                debugD("Check field #%d = %d, color %d, dist %d", n, nb, field[nb].color, field[nb].dist);
            }
            if ((nb >= 0) && (field[nb].color == selected) && (field[nb].dist < mindist)) {
                debugD("Got field #%d = %d, color %d, dist %d < %d", n, nb, field[nb].color, field[nb].dist, mindist);
                fnd = n;
                mindist = field[nb].dist;
            }
        }
        if (fnd < 0) {
            // Pressed key was not next to selected chain, so deselect
            // TODO: Some kind of distance/straight line stuff maybe?
            debugI("Press key %d, different chain, deselect", key);
            selected = -1;
            // Fall through to no color selected code
        } else {
            if (color == selected) {
                debugI("Press key %d, same colour %d, do nothing", key, color);
                // Nothing, maybe deselect further bit of chain?
            } else if (color == (selected ^ 1)) {
                debugI("Press key %d, matching colour %d, connect", key, color);
                // TODO: Connect chains
                // Disconnect pressed chain end
                int nxt = field[key].neighbour[field[key].next];
                debugD("Connect to chain at %d, disconnect %d", key, nxt);
                disconnect_chain(nxt);
                int idx = step_dir(field[key], fnd);
                // Connect pressed chain
                field[key].next = step_nb(field[key], fnd);
                field[idx].next = step_nb(field[idx], fnd+3);
                debugD("Connect %d to %d and %d to %d", key, field[key].next, idx, field[idx].next);
                // Reverse other chain to beginning
                nxt = key;
                int dist = field[idx].dist;
                while (nxt >= 0) {
                    debugD("Reverse %d<-%d<-%d", field[nxt].prev, nxt, field[nxt].next);
                    field[nxt].color = selected;
                    field[nxt].dist = ++dist;

                    int nn = field[nxt].prev;
                    field[nxt].prev = field[nxt].next;
                    field[nxt].next = nn;
                    nxt = field[nxt].neighbour[nn];
                }
            } else if (color >= 0) {
                debugI("Press key %d, different colour %d, todo", key, color);
                // TODO: Overwrite chain
            } else {
                // Extend chain
                debugI("Press key %d, no colour %d, extend chain", key, color);
                int idx = step_dir(field[key], fnd);
                int nxt = field[idx].neighbour[field[idx].next];
                debugD("Connect to chain at %d, disconnect %d", idx, nxt);
                // Disconnect other chain
                disconnect_chain(nxt);
                field[key].color = field[idx].color;
                field[key].dist = field[idx].dist + 1;
                field[key].prev = step_nb(field[key], fnd);
                field[idx].next = step_nb(field[idx], fnd+3);
            }
        }
    }
    // Don't use else to enable above block to deselect and then fall into this block
    if (selected < 0) {
        if (color >= 0) {
            // Select this color
            selected = color;
            debugI("Press %d selects %d", key, selected);
        } else {
            debugI("Press %d does nothing (todo)", key);
            /*
            int color = 0;
            int cnt = 0;
            for (int n = 0; n < 4; n++) {
                int nb = field[key].neighbour[n];
                if ((nb >= 0) && (field[nb].color)) {
                    cnt++;
                    color = field[nb].color;
                }
            }
            if (cnt == 1) {
                field[key].color = color;
                selected = color;
                debugI("Press %d selects neighbouring %d", key, selected);
            }
            */
            // TODO: Connect two lines ?
        }
    }
    draw_field(true);
}

unsigned long lasttick = 0;

void field_update()
{
    int key = keys_scan();
    if (key < 0) {
        debugE("ERROR: Key scan error");
        delay(100);
        return;
    }
    unsigned long tick = millis();
    if (key != curkey) {
        debugD("Field scan, key=%d, curkey=%d, lastkey=%d, tick=%ld", key, curkey, lastkey, tick);
        curkey = key;
        if (key > 0) {
            if ((key != lastkey) || (lastpress+50 < tick)) {
                lastkey = key;
                press_key(key-1);
            }
        }
        lasttick = 0;
    }
    if (lasttick < tick) {
        lasttick = tick + 20; // Draw 50 times per second
        draw_field();
    }
}
