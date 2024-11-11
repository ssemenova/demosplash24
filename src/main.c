#include <conio.h>
#include <string.h>

void init_irq(void);
void init_sprites(void);
void clear_scr(void);

// extern const char *dancers_str;
#include "dancer.h"

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

#define SPRITE_POS ((struct position *)0xd000)
#define SPRITE0_X (*(char *)0xd000)
#define SPRITE0_Y (*(char *)0xd001)
#define SPRITE1_X (*(char *)0xd002)
#define SPRITE1_Y (*(char *)0xd003)
#define SPRITE2_X (*(char *)0xd004)
#define SPRITE2_Y (*(char *)0xd005)
#define SPRITE3_X (*(char *)0xd006)
#define SPRITE3_Y (*(char *)0xd007)
#define SPRITE4_X (*(char *)0xd008)
#define SPRITE4_Y (*(char *)0xd009)
#define SPRITE_X9 (*(char *)0xd010)

#define SPRITE_COLOR ((char *)0xd027)
#define SPRITE0_COLOR (*(char *)0xd027)
#define SPRITE1_COLOR (*(char *)0xd028)
#define SPRITE2_COLOR (*(char *)0xd029)
#define SPRITE3_COLOR (*(char *)0xd02a)
#define SPRITE4_COLOR (*(char *)0xd02b)

#define SPRITE_MASK (*(char *)0xd015)

#define SPRITE_PTR ((char *)0x07f8)

#define SPRITE_BASE 128

#define SCREEN ((char *)(0x0400))

#define BG_COLOR  (*(char *)0xd021)
#define SCREEN_COLOR ((char *) 0xd800)

volatile unsigned char irq_flag = 0;
volatile short time_counter = 0;

char arrow[] = {220, 220, 220, 220, 220};
// char arrow[] = {60, 60, 60, 60, 60};

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
    int bg_flash_timer = 0;
    int view_timer = 0;

    init_irq();
    clear_scr();
    init_sprites();

    // memcpy((char *)(0x0400 + 40*1 + 13), "hello, world!", 13);
    memcpy(SCREEN, disco_str1, 25 * 40);
    BG_COLOR = COLOR_PURPLE;
    memset(SCREEN_COLOR, COLOR_BLACK, 1000);

    init_arrows();

    while (1) {
        while (!irq_flag);
        irq_flag = 0;
        bg_flash_timer++;
        view_timer++;

        if (bg_flash_timer == 40)
        {
            BG_COLOR = COLOR_LIGHTGREEN;
            memcpy(SCREEN, disco_str2, 25 * 40);
        }
        else if (bg_flash_timer == 80)
        {
            BG_COLOR = COLOR_ORANGE;
            memcpy(SCREEN, disco_str1, 25 * 40);
        }
        else if (bg_flash_timer == 120)
        {
            BG_COLOR = COLOR_CYAN;
            memcpy(SCREEN, disco_str2, 25 * 40);
        }
        else if (bg_flash_timer == 160)
        {
            BG_COLOR = COLOR_LIGHTRED;
            memcpy(SCREEN, disco_str1, 25 * 40);
        }
        else if (bg_flash_timer == 200)
        {
            BG_COLOR = COLOR_LIGHTBLUE;
            memcpy(SCREEN, disco_str2, 25 * 40);
        }
        else if (bg_flash_timer == 240)
        {
            BG_COLOR = COLOR_PURPLE;
            memcpy(SCREEN, disco_str1, 25 * 40);
            bg_flash_timer = 0;
        }
        else if (view_timer == 240)
        {
            memcpy(SCREEN, dancer_str, 25 * 40);
            view_timer = 0;
        }
    }

    return 0;
}

void update_arrows() {

    char sprite_mask = 0x00;

    if (arrow[0] < 56) {
        arrow[0] = 255; 
    } else if (arrow[0] <= 64) {
        sprite_mask |= (1 << 0);
        SPRITE_POS[0].y = 64;
        SPRITE_COLOR[0] = COLOR_WHITE;
        SPRITE_PTR[0] = SPRITE_BASE + FILLED_DOWN_LEFT; // Filled version (+1 regular)
    } else if (arrow[0] <= 220) {
        sprite_mask |= (1 << 0);
        SPRITE_COLOR[0] = COLOR_BLUE;
        SPRITE_PTR[0] = SPRITE_BASE + DOWN_LEFT;
        SPRITE_POS[0].y = arrow[0];
    }

    if (arrow[1] < 56)
    {
        arrow[1] = 255;
    }
    else if (arrow[1] <= 64)
    {
        sprite_mask |= (1 << 1);
        SPRITE_POS[1].y = 64;
        SPRITE_COLOR[1] = COLOR_WHITE;
        SPRITE_PTR[1] = SPRITE_BASE + FILLED_UP_LEFT; // Filled version (+1 regular)
    }
    else if (arrow[1] <= 220)
    {
        sprite_mask |= (1 << 1);
        SPRITE_COLOR[1] = COLOR_RED;
        SPRITE_PTR[1] = SPRITE_BASE + UP_LEFT;
        SPRITE_POS[1].y = arrow[1];
    }

    if (arrow[2] < 56)
    {
        arrow[2] = 255;
    }
    else if (arrow[2] <= 64)
    {
        sprite_mask |= (1 << 2);
        SPRITE_POS[2].y = 64;
        SPRITE_COLOR[2] = COLOR_WHITE;
        SPRITE_PTR[2] = SPRITE_BASE + FILLED_CENTER; // Filled version (+1 regular)
    }
    else if (arrow[2] <= 220)
    {
        sprite_mask |= (1 << 2);
        SPRITE_COLOR[2] = COLOR_YELLOW;
        SPRITE_PTR[2] = SPRITE_BASE + CENTER;
        SPRITE_POS[2].y = arrow[2];
    }

    if (arrow[3] < 56)
    {
        arrow[3] = 255;
    }
    else if (arrow[3] <= 64)
    {
        sprite_mask |= (1 << 3);
        SPRITE_POS[3].y = 64;
        SPRITE_COLOR[3] = COLOR_WHITE;
        SPRITE_PTR[3] = SPRITE_BASE + FILLED_UP_RIGHT; // Filled version (+1 regular)
    }
    else if (arrow[3] <= 220)
    {
        sprite_mask |= (1 << 3);
        SPRITE_COLOR[3] = COLOR_RED;
        SPRITE_PTR[3] = SPRITE_BASE + UP_RIGHT;
        SPRITE_POS[3].y = arrow[3];
    }

    if (arrow[4] < 56)
    {
        arrow[4] = 255;
    }
    else if (arrow[4] <= 64)
    {
        sprite_mask |= (1 << 4);
        SPRITE_POS[4].y = 64;
        SPRITE_COLOR[4] = COLOR_WHITE;
        SPRITE_PTR[4] = SPRITE_BASE + FILLED_DOWN_RIGHT; // Filled version (+1 regular)
    }
    else if (arrow[4] <= 220)
    {
        sprite_mask |= (1 << 4);
        SPRITE_COLOR[4] = COLOR_BLUE;
        SPRITE_PTR[4] = SPRITE_BASE + DOWN_RIGHT;
        SPRITE_POS[4].y = arrow[4];
    }

    SPRITE_MASK = sprite_mask;
}

void irq_handler(void) {
    static char x = 0;

    irq_flag = 1;
    time_counter++;

    // *(char *)(0xd020) = x++ >> 4; // Border changing colors

    update_arrows();

    arrow[0]--;
    arrow[1]--;
    arrow[2]--;
    arrow[3]--;
    arrow[4]--;

    return;
}

