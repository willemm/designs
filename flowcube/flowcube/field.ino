#include "settings.h"

// Status of playing field
int selected; // currently selected endpoint

unsigned long lastpress = 0;
int lastkey = 0; // Last key pressed
int curkey = 0; // Key currently being held down

#define DP_INIT 1
#define DP_DRAW 2
#define DP_KEY 4
#define DP_TEST 8

#define DEBUGPRINT 0

struct fieldcell_t {
    union {
        struct { int8_t none, up, left, down, right; };
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

// Translate from 6 directions to four, depending on cube side
// This way a straight line across a fold always has the same direction number
static const int8_t step_dirs[3][6] = {
    { 3, 4, 0, 1, 2, 0 },
    { 3, 0, 4, 1, 0, 2 },
    { 0, 3, 4, 0, 1, 2 }
};

// Find the field index in the given (one of six) direction
static inline int step_dir(fieldcell_t field, int dir)
{
    int8_t sdir = step_dirs[field.side][dir];
    return field.neighbour[sdir];
}

// Find the index of the led in the given (one of six) direction
static inline int pixel_dir(fieldcell_t field, int dir)
{
    int8_t sdir = step_dirs[field.side][dir];
    if (sdir <= 0) {
        serprintf("ERROR CANTHAPPEN: Wants to get direction %d on side %d", dir, field.side);
        return field.pixel[0];
    }
    return ((int)field.side)*LEDSZ + (int)field.pixel[(sdir+3)%4];
}

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
            field[idx].prev = -1;
            field[idx].next = -1;
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
#if (DEBUGPRINT & DP_INIT)
        serprintf("Key %2d: right=%2d down=%2d pixels=[%3d,%3d,%3d,%3d]",
            idx, field[idx].right, field[idx].down,
            field[idx].pixel[0], field[idx].pixel[1],
            field[idx].pixel[2], field[idx].pixel[3]);
#endif
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

void field_clear()
{
    serprintf("Clearing game field");
    for (int idx = 0; idx < NUMKEYS; idx++) {
        field[idx].color = 0;
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
    selected = 0;
    draw_field();
    serprintf("Inited game field");
}

void set_endpoints(int8_t endpoints[])
{
    for (int c = 0; endpoints[c*2] >= 0; c++) {
        serprintf("Set endpoint %d: (%d,%d)", c, endpoints[c*2], endpoints[c*2+1]);
        int idx = field_idx(endpoints[c*2], endpoints[c*2+1]);
        field[idx].color = c+1;
        field[idx].is_endpoint = 1;
    }
}

static void draw_field()
{
    pixels.clear();
    for (int idx = 0; idx < NUMKEYS; idx++) {
        int side = ((int)field[idx].side)*LEDSZ;
        int color = field[idx].color;
        if (color) {
            uint32_t colorval = colors[(color-1)/2];
#if (DEBUGPRINT & DP_DRAW)
            serprintf("color = %d, idx=%d, colorval = 0x%06x", color, (color-1)/2, colorval);
#endif
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
#if (DEBUGPRINT & DP_DRAW)
                    serprintf("Set pixels between %2d and %2d: (%3d,%3d) = 0x%06x",
                        idx, dir,
                        pixel_dir(field[idx], i), pixel_dir(field[dir], i+3),
                        colorval);
#endif
                    }
            }

#if 0
            int right = field[idx].right;
            if ((right >= 0) && (field[right].color == color)) {
                int left = (field[idx].is_fold) ? FIELD_UP : FIELD_LEFT;
                int rside = (int)field[right].side * LEDSZ;
                pixels.setPixelColor(side+field[idx].pixel[FIELD_RIGHT], colorval);
                pixels.setPixelColor(rside+field[right].pixel[left], colorval);
#if (DEBUGPRINT & DP_DRAW)
                serprintf("Set right between %2d and %2d: (%3d,%3d) = 0x%06x",
                    idx, right,
                    side+field[idx].pixel[FIELD_RIGHT], rside+field[right].pixel[left],
                    colorval);
#endif
            }
            int down = field[idx].down;
            if ((down >= 0) && (field[down].color == color)) {
                int dside = (int)field[down].side * LEDSZ;
                pixels.setPixelColor(side+field[idx].pixel[FIELD_DOWN], colorval);
                pixels.setPixelColor(dside+field[down].pixel[FIELD_UP], colorval);
#if (DEBUGPRINT & DP_DRAW)
                serprintf("Set down  between %2d and %2d: (%3d,%3d) = 0x%06x",
                    idx, down,
                    side+field[idx].pixel[FIELD_DOWN], dside+field[down].pixel[FIELD_UP],
                    colorval);
#endif
#endif
            }
        }
        if (idx == (curkey-1)) {
            uint32_t colorval = pixels.Color(255,255,255);
            for (int i = 0; i < 4; i++) {
                pixels.setPixelColor(side+field[idx].pixel[i], colorval);
            }
        }
    }
    if (selected > 0) {
        long now = millis();
        int idx = field_idx(field_endpoints[selected*2-2], field_endpoints[selected*2-1]);
        int len = 0;
        int nxt = idx;
        while (nxt >= 0) {
            len++;
            nxt = field.neighbours[field[idx].next];
        }
        int anpos = (now % 2000);
        anpos = anpos * (len+1) / 2000;
        nxt = idx;
        uint32_t colorval = colors[selected/2];
        while (nxt >= 0) {
            int8_t nd = field[idx].next;
            if (anpos <= 1 && anpos >= -1) {
                if (anpos == 0) {
                    colorval = colorval * 2;
                } else {
                    colorval = colorval * 2;
                }
                pixels.setPixelColor(((int)field[idx].side)*LEDSZ+field[idx].pixel[nd]);
            }
            nxt = field.neighbours[nd];
            anpos--;
        }
    }
    pixels.show();
}

int field_test_lines[5][8] = {
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
        field[idx].color = 0;
        field[idx].is_endpoint = 0;
    }
#if (DEBUGPRINT & DP_TEST)
    serprintf("Init field test (field size = %d)", sizeof(fieldcell_t));
#endif
    draw_field();
    for (int ln = 0; ln < 5; ln++) {
        testdelay(500);
#if (DEBUGPRINT & DP_TEST)
        serprintf("Field test line %d, color 0x%06x, from %2d to %2d (%d,%d)",
            ln, colors[ln+1], field_test_lines[ln][0], field_test_lines[ln][7],
            (ln+1)*2, (ln+1)*2+1);
#endif
        selected = ln*2+1;
        field[field_test_lines[ln][0]].color = ln*2+1;
        field[field_test_lines[ln][0]].is_endpoint = 1;
        field[field_test_lines[ln][7]].color = ln*2+2;
        field[field_test_lines[ln][7]].is_endpoint = 1;
        draw_field();
        for (int p = 1; p < 7; p++) {
            testdelay(500);
            field[field_test_lines[ln][p]].color = ln*2+1;
            draw_field();
        }
        testdelay(500);
        field[field_test_lines[ln][7]].color = ln*2+1;
        draw_field();
    }
    selected = 0;
    testdelay(500);
    draw_field();

    testdelay(2000);
}

static void press_key(int key)
{
    if (selected) {
        if (field[key].color) {
            serprintf("TODO: Press %d coloured %d while selected %d", key, field[key].color, selected);
            selected = 0;
        } else {
            // Expand the selected line.
            // Look for the selected line orthogannly through uncolored cells
#if (DEBUGPRINT & DP_KEY)
            serprintf("Expand selected line %d to key %d", selected, key);
#endif
            int max_dist = -1;
            int fnd = -1;
            int fdir = 0;
            for (int dr = 0; dr < 4; dr++) {
                int dir = dr;
                int idx = key;
                // Walk into direction dir
#if (DEBUGPRINT & DP_KEY)
                serprintf("Looking in direction %d", dir);
#endif
                int next;
                while ((next = field[idx].neighbour[dir]) >= 0) {
                    if (field[next].color) {
                        if (field[next].color == selected) {
                            if (field[next].dist > max_dist) {
                                max_dist = field[next].dist;
                                fnd = next;
                                fdir = (dir+2)%4;
                            }
                        }
#if (DEBUGPRINT & DP_KEY)
                        serprintf("Found color %d at %d, fnd = %d, dist = %d, dir = %d",
                            field[next].color, next, fnd, max_dist, fdir);
#endif
                        break;
                    }
                    // Cross the fold from quadrant 1 to 3 or vv, rotate direction 
                    if (dir == FIELD_UP) {
                        if (field[idx].is_upfold) { dir = FIELD_LEFT; }
                    } else if (dir == FIELD_RIGHT) {
                        if (field[idx].is_fold) { dir = FIELD_DOWN; }
                    }
                    idx = next;
                }
            }
            if (fnd >= 0) {
                // Found a selected cell, walk back to key cell
                int dist = field[fnd].dist;
                int idx = fnd;
                int next;
#if (DEBUGPRINT & DP_KEY)
                serprintf("Disconnecting further from %d", fnd);
#endif
                while ((next = field[idx].next) >= 0) {
                    next = field[idx].neighbours[next];
                    field[next].color = 0;
                    field[next].dist = 0;
                    field[next].prev = -1;
                    field[idx].next = -1;
                    idx = next;
                }
#if (DEBUGPRINT & DP_KEY)
                serprintf("Connecting back from %d to %d", fnd, key);
#endif
                while (fnd != key) {
                    int next = field[fnd].neighbour[fdir];
                    if (next < 0) {
                        // Assertion, can't happen
                        serprintf("ERROR: Walk back didn't find field %d", key);
                        break;
                    }
                    dist++;
                    field[next].dist = dist;
                    field[next].prev = (fdir+2)%4;
                    field[next].color = selected;
                    field[fnd].next = fdir;
                    if (fdir == FIELD_UP) {
                        if (field[fnd].is_upfold) { fdir = FIELD_LEFT; }
                    } else if (fdir == FIELD_RIGHT) {
                        if (field[fnd].is_fold) { fdir = FIELD_DOWN; }
                    }
                    fnd = next;
                }
            }
        }
    } else {
        if (field[key].color) {
            // Select this color
            selected = field[key].color;
#if (DEBUGPRINT & DP_KEY)
            serprintf("Press %d selects %d", key, selected);
#endif
        } else {
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
                serprintf("Press %d selects neighbouring %d", key, selected);
            }
            */
            // TODO: Connect two lines ?
        }
    }
    draw_field();
}

void field_update()
{
    int key = keys_scan();
    if (key < 0) {
        serprintf("ERROR: Key scan error");
        delay(100);
        return;
    }
    unsigned long tick = millis();
    if (key != curkey) {
#if (DEBUGPRINT & DP_KEY)
        serprintf("Field scan, key=%d, curkey=%d, lastkey=%d, tick=%d", key, curkey, lastkey, tick);
#endif
        curkey = key;
        if (key > 0) {
            if ((key != lastkey) || (lastpress+50 < tick)) {
                lastkey = key;
                press_key(key-1);
            }
        } else {
            draw_field(); // Uncolor pressed key
        }
    }
}
