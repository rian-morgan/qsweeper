// minesweeper

howToPlay:{
   "
    // mkGrid[int a;int b] -- create a new minesweeper grid
    //  @param a : grid length, no. of cells a*a 
    //  @param b : no. of bombs
    //  @example : mkGrid[10;15] - make a 10x10 grid with 15 bombs
    
    // showGrid[boolean x] -- show the current game grid state
    //  @param x : 0b - current grid state, 1b - current grid state with bombs (no cheating!)
    
    // chkSq[int x;int y] -- 'click' a square, reveals bomb/no neighbouring bombs / propagates empty squares
    //  @param x : cartesian x co-ordinate, starting from lhs
    //  @param y : cartesian y co-ordinate, starting from top 
    
    // addFlag[int x; int y] -- flag a square as containing a bomb
    //  @param x : cartesian x co-ordinate, starting from lhs
    //  @param y : cartesian y co-ordinate, starting from top 
    
    // removeFlag[int x; int y] -- remove flag from square
    //  @param x : cartesian x co-ordinate, starting from lhs
    //  @param y : cartesian y co-ordinate, starting from top
    
    // Game is won when all bombs have been correctly flagged. Good luck!
    "
    };
    
// grid list with random bombs
mkGrid:{[gl;b]
    .g.gl:gl;
    .g.b:b;
    .g.gs:.g.gl*.g.gl;
    .g.g:(neg .g.gs)?(b#1),(.g.gs-.g.b)#0;
    .g.c:.g.gs#0b;
    .g.n:.g.gs#0;
    .g.f:.g.gs#0;
    .g.i:{(x-1)+(y-1)*.g.gl};
    .g.ii:{[i](1+i mod .g.gl;ceiling(i+1)%.g.gl)};
    showGrid[0b]
    };

chkSq:{[x;y] //check if square is a bomb, if it is, return game over, else run func to recursively check for neighbouring bombs
    //convert x y input to list index
    i:.g.i[x;y];
    $[.g.g[i];:`$"Game Over! You placed ",string[sum[.g.f]]," flags. ",string[sum[?[0<.g.f;1b;0b]*?[0<.g.g;1b;0b]]]," flags were placed correctly!" ;
    chkSq0[i]
    ];
    showGrid[0b]
    };    

chkSq0:{[i]
    //i:.g.i[x;y];
    xy:.g.ii[i];
    x:xy[0];
    y:xy[1];
    if[(i>=0)&(i<.g.gs)&(not .g.c[i]); // if sq isnt outside bounds and hasnt been checked, check surrounding squares for bombs
        .g.c[i]:1b;
        // check all 8 surrounding sqs starting at top right and going clockwise
        c:(x-1;y-1;x-1;y;x-1;y+1;x;y-1;x;y+1;x+1;y-1;x+1;y;x+1;y+1);
        d:2 cut c;
        e:{.g.i[x[0];x[1]]}'[d];
        s:sum ?[.g.g[e where (dd:first each d) within(1;.g.gl)]>0;1;0];
        .g.n[i]:s;
        
        if[s=0;
            if[0<i mod .g.gl; // lhs grid 
                if[.g.g[e[0]]=0;.z.s[e[0]]];
                if[.g.g[e[1]]=0;.z.s[e[1]]];
                if[.g.g[e[2]]=0;.z.s[e[2]]];
                ];
            if[.g.g[e[3]]=0;.z.s[e[3]]];
            if[.g.g[e[4]]=0;.z.s[e[4]]];
            if[(.g.gl-1)>i mod .g.gl; // rhs grid
                if[.g.g[e[5]]=0;.z.s[e[5]]];
                if[.g.g[e[6]]=0;.z.s[e[6]]];
                if[.g.g[e[7]]=0;.z.s[e[7]]];
                ];
            ];
        ];
    };

addFlag:{[x;y]
    i:.g.i[x;y];
    $[.g.c[i];"Square has already been checked";[.g.f[i]:1;
        $[.g.b=sum ?[0<.g.f;1b;0b]*?[0<.g.g;1b;0b];
            "You Win";
            showGrid[0b]
            ]]
        ]
    };
    
removeFlag:{[x;y]
    i:.g.i[x;y];
    .g.f[i]:0;
    showGrid[0b]
    };

showGrid:{[x]
    sb:0b;if[not(::)~x;sb:x];
    g:(.g.gs#10)^?[0<.g.c;.g.n;0N]^$[sb;?[0<.g.g;-1;0N];.g.gs#0N]^?[0<.g.f;9;0N];
    //enlist[((2*.g.gl)#" _")," "],
    enlist[raze -2#'" ",'string 1+til .g.gl],((.g.gl;2*.g.gl)#raze{ssr/[x;("10";"9";"-1");("_";">";"*")]}'["|",'string g]),'"| ",/:string 1+til .g.gl
    };
    
 .z.po:{howToPlay[]};
 .z.pg:{k:value x};
