#include <conio.h>
#include <string.h>

void init_irq(void);
void init_sprites(void);
void clear_scr(char fg_color);

void set_screen_idx(char addr);
#define set_screen(x) (set_screen_idx((int)x/256))

extern volatile unsigned char chart_line[];
extern volatile unsigned char chart_shift;

#include "backgrounds.h"

struct position {
    char x;
    char y;
};

#define UP_LEFT 0
#define FILLED_UP_LEFT 1
#define DOWN_LEFT 2
#define FILLED_DOWN_LEFT 3
#define UP_RIGHT 4
#define FILLED_UP_RIGHT 5
#define DOWN_RIGHT 6
#define FILLED_DOWN_RIGHT 7
#define CENTER 8
#define FILLED_CENTER 9

#define SPRITE_POS ((volatile struct position *)0xd000)
#define SPRITE0_X (*(volatile char *)0xd000)
#define SPRITE0_Y (*(volatile char *)0xd001)
#define SPRITE1_X (*(volatile char *)0xd002)
#define SPRITE1_Y (*(volatile char *)0xd003)
#define SPRITE2_X (*(volatile char *)0xd004)
#define SPRITE2_Y (*(volatile char *)0xd005)
#define SPRITE3_X (*(volatile char *)0xd006)
#define SPRITE3_Y (*(volatile char *)0xd007)
#define SPRITE4_X (*(volatile char *)0xd008)
#define SPRITE4_Y (*(volatile char *)0xd009)
#define SPRITE_X9 (*(volatile char *)0xd010)

#define SPRITE_COLOR ((volatile char *)0xd027)
#define SPRITE0_COLOR (*(volatile char *)0xd027)
#define SPRITE1_COLOR (*(volatile char *)0xd028)
#define SPRITE2_COLOR (*(volatile char *)0xd029)
#define SPRITE3_COLOR (*(volatile char *)0xd02a)
#define SPRITE4_COLOR (*(volatile char *)0xd02b)

#define SPRITE_MASK (*(volatile char *)0xd015)

#define SPRITE_PTR ((volatile char *)0x07f8)

#define SPRITE_BASE 192

#define SCREEN ((char *)(0x0400))

#define IRQ_LINE (*(volatile char *)0xd012)
#define BG_COLOR  (*(volatile char *)0xd021)
#define SCREEN_COLOR ((char *) 0xd800)


#define SCREEN1_BEGIN_TIME 240
#define SCREEN2_BEGIN_TIME 480
#define SCREEN3_BEGIN_TIME 720
#define FRAME_STEP 48
volatile unsigned char irq_flag = 0;
volatile short time_counter = 8;
volatile char arrows_visible = 1;

short curr_view = 0;

void init_arrows(void) {
    SPRITE0_X = 0x1f; //3
    SPRITE1_X = 0x5f; //6
    SPRITE2_X = 0x9f; //9
    SPRITE3_X = 0xdf;
    SPRITE4_X = 0x1f;
    SPRITE_X9 |= 1 << 4;

    SPRITE0_Y = 128;
    SPRITE1_Y = 128;
    SPRITE2_Y = 128;
    SPRITE3_Y = 128;
    SPRITE4_Y = 128;

    SPRITE0_COLOR = COLOR_BLUE;
    SPRITE1_COLOR = COLOR_RED;
    SPRITE2_COLOR = COLOR_YELLOW;
    SPRITE3_COLOR = COLOR_RED;
    SPRITE4_COLOR = COLOR_BLUE;

    SPRITE_PTR[0] = SPRITE_BASE + 2;
    SPRITE_PTR[1] = SPRITE_BASE + 0;
    SPRITE_PTR[2] = SPRITE_BASE + 8;
    SPRITE_PTR[3] = SPRITE_BASE + 4;
    SPRITE_PTR[4] = SPRITE_BASE + 6;
}

unsigned char
main(void)
{

    clear_scr(COLOR_BLACK);
    init_sprites();

    init_irq();

    BG_COLOR = COLOR_PURPLE;

    init_arrows();

    while (1) {
        static char disco_color = 0;
        short local_time;
        local_time = time_counter;
        while (!irq_flag); irq_flag = 0;

        if (curr_view == 0 || curr_view == 1 || curr_view == 2 || curr_view == 3)
        {

            if (local_time == 1) {
                set_screen(disco_str1);
                arrows_visible = 1;
                switch (disco_color)
                {
                case 0:
                    BG_COLOR = COLOR_PURPLE;
                    break;
                case 1:
                    BG_COLOR = COLOR_LIGHTGREEN;
                    break;
                case 2:
                    BG_COLOR = COLOR_ORANGE;
                    break;
                case 3:
                    BG_COLOR = COLOR_CYAN;
                    break;
                case 4:
                    BG_COLOR = COLOR_LIGHTRED;
                    break;
                case 5:
                    BG_COLOR = COLOR_LIGHTBLUE;
                    break;
                case 6:
                    BG_COLOR = COLOR_YELLOW;
                    break;
                case 7:
                    BG_COLOR = COLOR_GRAY3;
                    break;
                }
            } else if (local_time == FRAME_STEP/2) {
                set_screen(disco_str2);
            } else if (local_time == FRAME_STEP) {
                time_counter = 0;
                if (++disco_color == 8) {
                    disco_color = 0;
                    curr_view++;
                }
            }
        }
        else if (curr_view == 0)
        {
            // 2: Dancing people
            if (local_time == 1)
            {
                arrows_visible = 0;
                set_screen(dancer_str);
            } else if (local_time == FRAME_STEP * 5) {
                // Back to disco
                time_counter = 0;
                curr_view++;
            } else {
                if ((local_time & 31) == 0) {
                    BG_COLOR = COLOR_WHITE;
                } else {
                    BG_COLOR = COLOR_LIGHTBLUE;
                }
            }

        } else if (curr_view == 4) {
            // 4: Hey!
            if (local_time == 9)
            {
                BG_COLOR = COLOR_LIGHTBLUE;
                arrows_visible = 0;
                set_screen(hey_str);
            }
        }
    }

    return 0;
}

const char hextbl[16] = { 
    0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
    0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
};

#define S_____ 0
#define SX____ 1
#define S_X___ 2
#define S__X__ 4
#define S___X_ 8
#define S____X 16
#define SX___X 17
#define S_X_X_ 10
#define SX__X_ 9
#define S_X__X 18
#define SXXX__ 7
#define S__XXX 28
#define SX_X_X 21

#define CHART_MASK 31
char chart[] = {
    S_____,
    SX____,
    SX____,
    S___X_,
    S_____,
    S____X,
    S____X,
    S_X___,

    S_____,
    SX____,
    S_X___,
    S__X__,
    S___X_,
    S_X___,
    S____X,
    SX____,

    S_____,
    SX___X,
    S_X_X_,
    SX___X,
    S_____,
    S_X_X_,
    S_X_X_,
    SX___X,

    S__X__,
    S_____,
    SX__X_,
    S_X__X,
    S_____,
    S__XXX,
    SXXX__,
    SX_X_X,
};

void irq_handler(void) {
    static char shift = 64;
    static char step = 0;

    // prints current y position in top left
    // SCREEN[0] = hextbl[shift >> 4];
    // SCREEN[1] = hextbl[shift & 15];

    irq_flag = 1;


    if (arrows_visible)
    {
        // update_arrows();

        // arrow[0]--;
        // arrow[1]--;
        // arrow[2]--;
        // arrow[3]--;
        // arrow[4]--;

        if (!shift) {
            chart_line[0] = chart[(step + 0)&CHART_MASK];
            chart_line[1] = chart[(step + 1)&CHART_MASK];
            chart_line[2] = chart[(step + 2)&CHART_MASK];
            chart_line[3] = chart[(step + 3)&CHART_MASK];
            chart_line[4] = chart[(step + 4)&CHART_MASK];
            step++;
            shift = 48;
        }
        if ((time_counter & 0) == 0) {
            shift -= 1;
        }

        chart_shift = shift;

    } else {
        chart_line[0] = chart[0];
        chart_line[1] = chart[0];
        chart_line[2] = chart[0];
        chart_line[3] = chart[0];
        chart_line[4] = chart[0];
    }

    time_counter++;

    return;
}

