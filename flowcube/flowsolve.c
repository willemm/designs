#include <stdio.h>
#include <stdlib.h>

typedef struct cell {
    int right, down;
    int conns[2];
    int nc, color;
} cell_t;

typedef struct board {
    cell_t *cells;
    int size;
} board_t;

static inline int xyindex(int y, int x, int s)
{
    return y*s*2+x;
}

void init_board(board_t board)
{
    int sz = board.size;
    for (int y = 0; y < 2*sz; y++) {
        int xe = sz;
        if (y >= sz) xe = sz*2;  // Wider bit on lower half.  Upper right quad is not used.
        for (int x = 0; x < xe; x++) {
            int idx = xyindex(y, x, sz);
            int ri = idx + 1;
            if (x == xe-1) {
                if (y < sz) { // Right side of upper bit folds to lower right quadrant
                    ri = xyindex(sz*2 - 1 - x, sz*2 - 1 - y, sz);
                } else {
                    ri = 0;
                }
            }
            int di = idx + sz*2;
            if (y == 2*sz - 1) {
                di = 0;
            }
            board.cells[idx].right = ri;
            board.cells[idx].down = di;
        }
    }
}

board_t read_board(char *filename)
{
    FILE *infile = fopen(filename, "rb");
    if (!infile) {
        perror("Failed to open input");
        exit(1);
    }
    int size;
    if (fscanf(infile, " %d ", &size) < 0) {
        perror("Failed to scan input");
        exit(1);
    }
    board_t board;
    board.size = size;
    board.cells = calloc(size*size*4, sizeof(cell_t));

    init_board(board);

    int color = 0;
    while (1) {
        int ey, ex;
        int r = fscanf(infile, " %d , %d ", &ey, &ex);
        if (r <= 0) {
            if (r != EOF) {
                perror("Scanning infile");
                exit(1);
            }
            break;
        }
        int idx = xyindex(ey, ex, size);
        board.cells[idx].nc = 1;
        board.cells[idx].conns[0] = -((color/2)+1);
        color++;
    }

    fclose(infile);
    return board;
}

void copy_file(FILE *in, FILE *out)
{
    char c;
    while ( (c = fgetc(in)) != EOF) {
        if (c < 0) {
            perror("Error copying stream");
            exit(1);
        }
        putc(c, out);
    }
}

void html_connector(FILE *out, char *direction, char c1, int c1y, int c1x, char c2, int c2y, int c2x)
{
    fprintf(out, "<div class=\"connector %s %c%d%d %c%d%d\" data-c1=\"%c%d%d\" data-c2=\"%c%d%d\"></div>",
        direction,
        c1,c1y,c1x,
        c2,c2y,c2x,
        c1,c1y,c1x,
        c2,c2y,c2x
    );
}

void html_button(FILE *out, char face, int y, int x)
{
    fprintf(out, "<div class=\"button\" id=\"%c%d%d\"></div>\n", face, y, x);
}

void html_blank(FILE *out)
{
    fprintf(out, "<div class=\"nothing\"></div>\n");
}

void html_face(FILE *out, board_t board, char face, char *id)
{
    fprintf(out, "<div class=\"face\" id=\"%s\">\n", id);
    html_blank(out);
    for (int x = 0; x < board.size; x++) {
        // Top row of non-buttons (connectors or nothing if it's the tp face)
        if (face != 't') {
            int ty, tx;
            if (face == 'f') {
                ty = board.size-1;
                tx = x;
            } else {
                ty = board.size-1-x;
                tx = board.size-1;
            }
            html_connector(out, "vertical", face, 0, x, 't', ty, tx);
        } else {
            html_blank(out);
        }
        html_blank(out);
    }
    for (int y = 0; y < board.size; y++) {
        if (y > 0 && y < board.size) {
            // Row of non-buttons (connectors) between buttons
            for (int x = 0; x < board.size; x++) {
                html_blank(out);
                html_connector(out, "vertical", face, y-1, x, face, y, x);
            }
            html_blank(out);
        }
        if (face == 'r') {
            // Left edge connectors
            html_connector(out, "horizontal", face, y, 0, 'f', y, (board.size-1));
        } else {
            html_blank(out);
        }
        for (int x = 0; x < board.size; x++) {
            if (x > 0) {
                html_connector(out, "horizontal", face, y, x-1, face, y, x);
            }
            html_button(out, face, y, x);
        }
        if (face != 'r') {
            // Right edge connectors
            int ty, tx;
            if (face == 't') {
                ty = 0;
                tx = board.size-1-y;
            } else {
                ty = y;
                tx = 0;
            }
            html_connector(out, "horizontal", face, y, board.size-1, 'r', ty, tx);
        } else {
            html_blank(out);
        }
    }
    html_blank(out);
    for (int x = 0; x < board.size; x++) {
        if (face == 't') {
            html_connector(out, "vertical", face, board.size-1, x, 'f', 0, x);
        } else {
            html_blank(out);
        }
        html_blank(out);
    }
    fprintf(out, "</div>\n");
}

void html_board(FILE *out, board_t board)
{
    FILE *pre = fopen("pre.html", "r");
    if (!pre) {
        perror("Error opening pre.html");
        exit(1);
    }
    copy_file(pre, out);
    fclose(pre);

    html_face(out, board, 't', "top");
    html_face(out, board, 'f', "front");
    html_face(out, board, 'r', "right");

    FILE *post = fopen("post.html", "r");
    if (!post) {
        perror("Error opening post.html");
        exit(1);
    }
    copy_file(post, out);
    fclose(post);
}

/*

 O--O--O--
 |  |  |
 O--O--O--
 |  |  |
 O--O--O--
 |  |  |  |  |  |
 O--O--O--O--O--O
 |  |  |  |  |  |
 O--O--O--O--O--O
 |  |  |  |  |  |
 O--O--O--O--O--O

*/

int colors[] = {
    7,1,2,3,4,5,6
};

void draw_button(FILE *out, int color)
{
    fprintf(out, "\x1b[3%dmO\x1b[0m", colors[color]);
}

void draw_horizontal(FILE *out, int color)
{
    fprintf(out, "\x1b[3%dm--\x1b[0m", colors[color]);
}

void draw_horizontal_blank(FILE *out)
{
    fprintf(out, "  ");
}

void draw_vertical(FILE *out, int color)
{
    fprintf(out, "\x1b[3%dm|\x1b[0m  ", colors[color]);
}

void draw_vertical_blank(FILE *out)
{
    fprintf(out, "   ");
}

void draw_board(FILE *out, board_t board)
{
    int sz = board.size;
    for (int y = 0; y < sz*2; y++) {
        int xe = (y >= sz) ? sz * 2 : sz;
        // Draw button row and right connectors
        for (int x = 0; x < xe; x++) {
            int idx = xyindex(y, x, sz);
            cell_t *cell = &board.cells[idx];
            draw_button(out, cell->color);
            if (x < sz*2-1) {
                int ison = 0;
                for (int n = 0; n < cell->nc; n++) {
                    if (cell->conns[n] == cell->right) ison = 1;
                }
                if (ison) {
                    draw_horizontal(out, board.cells[idx].color);
                } else {
                    draw_horizontal_blank(out);
                }
            }
        }
        fprintf(out, "\n");
        if (y < sz*2-1) {
            for (int x = 0; x < xe; x++) {
                int idx = xyindex(y, x, sz);
                cell_t *cell = &board.cells[idx];
                int ison = 0;
                for (int n = 0; n < cell->nc; n++) {
                    if (cell->conns[n] == cell->down) ison = 1;
                }
                if (ison) {
                    draw_vertical(out, board.cells[idx].color);
                } else {
                    draw_vertical_blank(out);
                }
            }
        }
        if (y == sz-1) {
            for (int x = sz; x < sz*2; x++) {
                // Connected cell over fold, so look at cell below (y+1,x) and calc foldover cell
                int idx = xyindex(sz*2-1-x, sz*2-1-(y+1), sz);
                cell_t *cell = &board.cells[idx];
                int ison = 0;
                for (int n = 0; n < cell->nc; n++) {
                    if (cell->conns[n] == cell->right) ison = 1;
                }
                if (ison) {
                    draw_vertical(out, board.cells[idx].color);
                } else {
                    draw_vertical_blank(out);
                }
            }
        }
        fprintf(out, "\n");
    }
}

void color_traverse_cell(board_t board, int idx, int color)
{
    int prv = -color;
    for (int stp = 0; stp < 1000; stp++) { // Prevent infiite loop
        cell_t *cell = &board.cells[idx];
        cell->color = color;
        int n = cell->nc;
        while (n-- > 0) {
            if (cell->conns[n] != prv) break;
        }
        prv = idx;
        if (n < 0) break;
        idx = cell->conns[n];
        if (idx <= 0) break;
    }
}

void color_board(board_t board)
{
    for (int i = 0; i < board.size*board.size*4; i++) {
        board.cells[i].color = 0;
    }
    for (int i = 0; i < board.size*board.size*4; i++) {
        cell_t *cell = &board.cells[i];
        for (int c = 0; c < cell->nc; c++) {
            if (cell->conns[c] < 0) {
                color_traverse_cell(board, i, -(cell->conns[c]));
            }
        }
    }
}

#define CAN_CONNECT(cell) ((cell) && ((cell)->nc < 2))
#define CONNECT_CELLS(cell,idx,cell2,idx2) (cell)->conns[(cell)->nc++] = (idx2); (cell2)->conns[(cell2)->nc++] = (idx)

#define DISCONNECT_CELLS(cell,idx,cell2,idx2) (cell)->nc--; (cell2)->nc--

int check_partial_solution(board_t board, int sidx)
{
    int sz = board.size*board.size*4;
    char lineset[sz];
    for (int i = 0; i < sz; i++) { lineset[i] = 0; }
    char touchline[sz];
    for (int i = 0; i < sz; i++) { touchline[i] = 0; }
    int queue[sz];
    int qidx = 0;
    int qend = 1;
    int color = 0;
    queue[0] = sidx;
    while (qidx < qend) {
        int idx = queue[qidx++];
        if (touchline[idx]) {
            // Line is touching itself
            return 0;
        }
        cell_t *cell = &board.cells[idx];
        // Indexes of touchhing but not connected cells (only right and down)
        int touch[] = { cell->right, cell->down };
        for (int n = 0; n < cell->nc; n++) {
            int next = cell->conns[n];
            if (next < 0) {
                // This is an endpoint
                if (!color) {
                    // First endpoint: Set color
                    color = cell->conns[n];
                } else if (color != cell->conns[n]) {
                    // Second endpoint, color clash
                    return 0;
                }
            } else {
                if (next == touch[0]) { touch[0] = 0; }
                if (next == touch[1]) { touch[1] = 0; }
                if (!lineset[next]) {
                    // Only do each one once
                    lineset[next] = 1;
                    queue[qend++] = next;
                    if (qend >= sz) {
                        fprintf(stderr, "Queue got full, should not happen");
                        exit(1);
                    }
                }
            }
        }
        for (int i = 0; i < 2; i++) {
            if (touch[i]) {
                if (lineset[touch[i]]) {
                    // Line is touching itself
                    return 0;
                }
                touchline[touch[i]] = 1;
            }
        }
    }
    return 1;
}

void check_solution(board_t board)
{
    color_board(board);
    // draw_board(stdout, board);
}

void solve_board(board_t board)
{
    int sz = board.size;
    int diagonals[sz*sz*4];
    int dmax = 0;
    for (int r = 0; r < sz*4-1; r++) {
        for (int y = 0; y <= r; y++) {
            int x = r-y;
            if ((y < sz) && (x >= sz)) { continue; }
            if ((y >= sz*2) || (x >= sz*2)) { continue; }
            diagonals[dmax++] = xyindex(y, x, sz);
        }
    }
    int reverse = 0;
    int didx = 0;
    while (didx >= 0) {
        int idx = diagonals[didx];
        // printf("Process %d (%d,%d)\n", didx, (idx/sz*2), (idx % (sz*2)));
        cell_t *cell = &board.cells[idx];
        cell_t *cellright = cell->right ? &board.cells[cell->right] : NULL;
        cell_t *celldown = cell->down ? &board.cells[cell->down] : NULL;
        if (!reverse) {
            reverse = 0;
            if (cell->nc == 0) {
                // If possible make a right to down corner
                if (CAN_CONNECT(cellright) && CAN_CONNECT(celldown)) {
                    CONNECT_CELLS(cell,idx,cellright,cell->right);
                    CONNECT_CELLS(cell,idx,celldown,cell->down);
                }
                // Else connect nothing and go on with this cell blank
            } else if (cell->nc == 1) {
                // If possible, conect right
                if (CAN_CONNECT(cellright)) {
                    CONNECT_CELLS(cell,idx,cellright,cell->right);
                } else if (CAN_CONNECT(celldown)) {
                    // Otherwise if possible connect down
                    CONNECT_CELLS(cell,idx,celldown,cell->down);
                } else {
                    // No way to connect, this branch is failed
                    // TODO: Near miss checking ?
                    reverse = 1;
                }
            }
            // Else do nothing and go on
        } else {
            reverse = 0;
            if (cell->nc == 1) {
                fprintf(stderr, "One cell connected on reverse, should not happen: %d", idx);
                exit(1);
            } else if (cell->nc == 2) {
                // If it was a down-right corner, now try blank cell
                if ((cell->conns[0] == cell->right) && (cell->conns[1] == cell->down)) {
                    DISCONNECT_CELLS(cell,idx,cellright,cell->right);
                    DISCONNECT_CELLS(cell,idx,celldown,cell->down);
                } else if (cell->conns[1] == cell->right) {
                    DISCONNECT_CELLS(cell,idx,cellright,cell->right);
                    if (CAN_CONNECT(celldown)) {
                        // If it was a connection to the right, try connection down
                        CONNECT_CELLS(cell,idx,celldown,cell->down);
                    } else {
                        // Otherwise branch has failed
                        reverse = 1;
                    }
                } else if (cell->conns[1] == cell->down) {
                    // If it was a down connection, 
                    DISCONNECT_CELLS(cell,idx,celldown,cell->down);
                    // TODO: Near miss checking ?
                    reverse = 1;
                } else {
                    // This is an up-right corner that has been tested, so fail this
                    reverse = 1;
                }
            } else {
                // This was tested as a blank cell, so fail this branch
                reverse = 1;
            }
        }
        if (reverse) {
            // Do a step back
            didx--;
        } else {
            if (check_partial_solution(board, idx)) {
                if (didx == dmax-1) {
                    // Board is full, check this and reverse
                    check_solution(board);
                    reverse = 1;
                    didx--;
                } else {
                    // Go on with next step
                    didx++;
                }
            } else {
                // Don't step back yet, just fail this step and try the next one on this index
                reverse = 1;
            }
        }
    }
}

int main(int argc, char *argv[])
{
    if (argc < 2) {
        fprintf(stderr, "Usage: flowsolve <board>\n");
        return 1;
    }
    board_t board = read_board(argv[1]);
    solve_board(board);
    color_board(board);
    draw_board(stdout, board);
    free(board.cells);
    return 0;
}
