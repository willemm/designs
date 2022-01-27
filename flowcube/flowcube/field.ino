#include "settings.h"

// Status of playing field
int selected; // currently selected key

struct fieldcell_t {
    char right;
    char down;
    char color;
    char flags;
    int pixel[4];
};

#define FIELD_ENDPOINT 0x01
#define FIELD_FOLD 0x02

#define FIELD_UP    0
#define FIELD_LEFT  1
#define FIELD_DOWN  2
#define FIELD_RIGHT 3

#define FSZ 5
#define DSZ (FSZ*2)

fieldcell_t field[3*FSZ*FSZ];

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
            field[idx].pixel[(cellrot+0)%4] = cell.left;   // up
            field[idx].pixel[(cellrot+1)%4] = cell.down;   // right
            field[idx].pixel[(cellrot+2)%4] = cell.left^1; // down
            field[idx].pixel[(cellrot+3)%4] = cell.down^1; // left
            field[idx].flags = 0;
            if ((x == FSZ-1) && (y < FSZ)) {
                // Right edge of upper left folds to top of lower right
                field[idx].right = field_idx(DSZ-1-x, DSZ-1-y);
                field[idx].flags = FIELD_FOLD;
            } else if (x == DSZ-1) {
                // Sentinel value for no right neighbour
                // Real right or down neighbours are never 0 (0 is top left)
                field[idx].right = 0;
            } else {
                field[idx].right = field_idx(y,x+1);
            }
            // Down never folds
            if (y == DSZ-1) {
                field[idx].down = 0;
            } else {
                field[idx].down = field_idx(y+1,x);
            }
        }
    }
    /*
    for (int idx = 0; idx < 3*FSZ*FSZ; idx++) {
        serprintf("Key %2d: right=%2d down=%2d pixels=[%3d,%3d,%3d,%3d]",
            idx, field[idx].right, field[idx].down,
            field[idx].pixel[0], field[idx].pixel[1],
            field[idx].pixel[2], field[idx].pixel[3]);
    }
    */
    int endpoints[][2] = {
        {3,1}, {5,5},
        {1,2}, {7,2},
        {6,5}, {5,6},
        {5,9}, {9,9},
        {1,1}, {6,6},
        {-1,-1}
    };
    set_endpoints(endpoints);
}

void set_endpoints(int endpoints[][2])
{
    for (int c = 0; endpoints[c*2][0] >= 0; c++) {
        int idx = field_idx(endpoints[c*2][0], endpoints[c*2][1]);
        field[idx].color = idx+1;
        field[idx].flags |= FIELD_ENDPOINT;
    }
}

static void draw_field()
{
    pixels.clear();
    for (int idx = 0; idx < 3*FSZ*FSZ; idx++) {
        int color = field[idx].color;
        if (color) {
            uint32_t colorval = colors[color-1];
            if (field[idx].flags & FIELD_ENDPOINT) {
                for (int i = 0; i < 4; i++) {
                    pixels.setPixelColor(field[idx].pixel[i], colorval);
                }
                /*
                serprintf("Set endpoint %2d: (%3d,%3d,%3d,%3d) = 0x%06x",
                    idx,
                    field[idx].pixel[0], field[idx].pixel[1],
                    field[idx].pixel[2], field[idx].pixel[3],
                    colorval);
                */
            }

            int right = field[idx].right;
            if ((right > 0) && (field[right].color == color)) {
                int left = (field[idx].flags & FIELD_FOLD) ? FIELD_UP : FIELD_LEFT;
                pixels.setPixelColor(field[idx].pixel[FIELD_RIGHT], colorval);
                pixels.setPixelColor(field[right].pixel[left], colorval);
                /*
                serprintf("Set right between %2d and %2d: (%3d,%3d) = 0x%06x",
                    idx, right,
                    field[idx].pixel[FIELD_RIGHT], field[right].pixel[left],
                    colorval);
                */
            }
            int down = field[idx].down;
            if ((down > 0) && (field[down].color == color)) {
                pixels.setPixelColor(field[idx].pixel[FIELD_DOWN], colorval);
                pixels.setPixelColor(field[down].pixel[FIELD_UP], colorval);
                /*
                serprintf("Set down  between %2d and %2d: (%3d,%3d) = 0x%06x",
                    idx, down,
                    field[idx].pixel[FIELD_DOWN], field[down].pixel[FIELD_UP],
                    colorval);
                */
            }
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
    for (int idx = 0; idx < 3*FSZ*FSZ; idx++) {
        field[idx].color = 0;
        field[idx].flags &= ~FIELD_ENDPOINT;
    }
    serprintf("Init field test");
    draw_field();
    for (int ln = 0; ln < 5; ln++) {
        testdelay(500);
        serprintf("Field test line %d, color 0x%06x, from %2d to %2d",
            ln, colors[ln+1], field_test_lines[ln][0], field_test_lines[ln][7]);
        field[field_test_lines[ln][0]].color = ln+1;
        field[field_test_lines[ln][0]].flags |= FIELD_ENDPOINT;
        field[field_test_lines[ln][7]].color = ln+1;
        field[field_test_lines[ln][7]].flags |= FIELD_ENDPOINT;
        draw_field();
        for (int p = 1; p < 7; p++) {
            testdelay(500);
            field[field_test_lines[ln][p]].color = ln+1;
            serprintf("Field test set %d = %2d (0x%x)",
                p, field_test_lines[ln][p],
                field[field_test_lines[ln][p]].flags);
            draw_field();
        }
    }
    testdelay(2000);
}
