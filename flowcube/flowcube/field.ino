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

#define FIELD_LEFT  0
#define FIELD_DOWN  1
#define FIELD_RIGHT 2
#define FIELD_UP    3

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
            field[idx].pixel[(cellrot+0)%4] = cell.left;   // left
            field[idx].pixel[(cellrot+1)%4] = cell.down;   // down
            field[idx].pixel[(cellrot+2)%4] = cell.left+1; // right
            field[idx].pixel[(cellrot+3)%4] = cell.down+1; // up
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

void draw_board()
{
    pixels.clear();
    for (int idx = 0; idx < 3*FSZ*FSZ; idx++) {
        int color = field[idx].color;
        if (color) {
            uint32_t colorval = colors[color];
            if (field[idx].flags | FIELD_ENDPOINT) {
                for (int i = 0; i < 4; i++) {
                    pixels.setPixelColor(field[idx].pixel[i], colorval);
                }
            }

            int right = field[idx].right;
            if (right && field[right].color == color) {
                int left = (field[idx].flags | FIELD_FOLD) ? FIELD_LEFT : FIELD_UP;
                pixels.setPixelColor(field[idx].pixel[FIELD_RIGHT], colorval);
                pixels.setPixelColor(field[right].pixel[left], colorval);
            }
            int down = field[idx].down;
            if (down && field[down].color == color) {
                pixels.setPixelColor(field[idx].pixel[FIELD_DOWN], colorval);
                pixels.setPixelColor(field[right].pixel[FIELD_UP], colorval);
            }
        }
    }
    pixels.show();
}
