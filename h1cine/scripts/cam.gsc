/*
 *      H1Cine
 *      Camera functions
 */

//#include scripts\maths;
#include scripts\utils;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

camsavenode( args )
{
    i = int(args[0]);
    deletecamprev();

    level.cam["origin"][i]  = self getorigin();
    level.cam["orgpath"][i] = self getorigin() + (0,0,58);
    level.cam["angles"][i]  = self getplayerangles();

    if( isDefined(level.cam["obj"][i]) ) level.cam["obj"][i] delete();
    level.cam["obj"][i] = spawn( "script_model", level.cam["orgpath"][i] );
    level.cam["obj"][i] setmodel( "tag_origin" );
    level.cam["obj"][i].angles = self getplayerangles();
    level.cam["obj"][i] hudoutlineenable( "outlinefill_nodepth_green" );

    if( level.cam["count"] <= i || !isdefined( level.cam["count"] ) )
        level.cam["count"] = i;

    createcamprev();
    self iprintln("[^2H1CAM^7] * ^3Position ^7" + i + " saved " + self.origin );
}

camsetmode( args )
{
    level.cam["type"] = args[0];
    deletecamprev();

    if( ( level.cam["type"] == "bezier" && level.cam["count"] > 13 ) )
        self iprintln("[^2H1CAM^7] * ^113 points max for bezier" );

    if( ( level.cam["type"] == "bezier" && level.cam["count"] <= 13 ) || level.cam["type"] == "linear" ) {
        self iprintln("[^2H1CAM^7] * ^3" + level.cam["type"] + " ^7mode" );
        createcamprev();
    }

    else {
        self iprintln("[^2H1CAM^7] * ^1Invalid mode - must be bezier/linear" );
        level.cam["type"] = "bezier";
        createcamprev();
    }
}

createcamprev() 
{
    if( level.cam["count"] < 2 ) return;

    if( level.cam["type"] == "bezier" )
    {
        n = 0;
        pathsteps = ( 2000 * level.cam["count"] / 400 );

        for( j = 0; j < pathsteps ; j++ )
        {
            t = j / (pathsteps - 1);
            pos[0] = 0; pos[1] = 0; pos[2] = 0;
            ang[0] = 0; ang[1] = 0; ang[2] = 0;
            for( i = 1; i <= level.cam["count"]; i++ )
            {
                for(z = 0; z < 3; z++)
                {
                    pos[z] += float( diff( i-1, level.cam["count"]-1) * pow( (1-t), level.cam["count"]-i ) * pow( t, i-1 ) * level.cam["orgpath"][i][z] );
                    ang[z] += float( diff( i-1, level.cam["count"]-1) * pow( (1-t), level.cam["count"]-i ) * pow( t, i-1 ) * level.cam["angles"][i][z] );
                }
            }

            level.cam["path"][n] = spawn( "script_model", (pos[0],pos[1],pos[2]) );
            level.cam["path"][n] setModel( "tag_origin" );
            level.cam["path"][n].angles = (ang[0], ang[1], ang[2] + 90);
            level.cam["path"][n] hudoutlineenable( "outlinefill_nodepth_red" );
            n++;
        }
    }
    else if( level.cam["type"] == "linear" )
         self iprintln("[^2H1CAM^7] * ^1Preview for linear not implemented yet" );
    else self iprintln("[^2H1CAM^7] * ^1Can't create preview for '" + level.cam["type"] + "' mode" );
}


camstartpath( args )
{
    speed = int(args[0]);

    camera = spawn( "script_model", level.cam["origin"][1] );
    camera setmodel( "tag_origin" );
    camera enablelinkto();
    camera rotateto( level.cam["angles"][1], .05 );

    self setplayerangles( ( self getplayerangles()[0], self getplayerangles()[1], 0 ) ); // In case cam_rot is not 0
    self playerlinktodelta( camera, "tag_origin", 1, 0, 0, 0, 0, true );
    self iprintlnbold( "Mode: " + level.cam["type"] + " / Speed: " + speed + " / Nodes: " + level.cam["count"] );
    preparenodedistances();

    if( level.cam["type"] != "bezier" && level.cam["type"] != "linear" ) 
        self iprintln( "[^2H1CAM^7] * ^1Invalid path type" );
    
    if( level.cam["type"] == "bezier" && level.cam["count"] < 3 ) 
        self iprintln( "[^2H1CAM^7] * ^1Bezier needs atleast 3 nodes" );

    wait 2;
    hidecamprev();
    setdvar( "cg_drawGun", 0 );
    setdvar( "cg_drawCrosshair", 0 );
    self playerhide();
    setDvar( "cg_draw2d", 0 );

    if( level.cam["type"] == "linear" )
    {
        travel_time = int( speed / int(level.cam["count"]) );
        for ( i = 2; i < level.cam["count"] + 1; i++ )
        {
            camera rotateto( level.cam["angles"][i], travel_time, 0, 0 );
            camera moveto( level.cam["origin"][i], travel_time, 0, 0 );
            wait travel_time;
        }
    }
    else if( level.cam["type"] == "bezier" && level.cam["count"] >= 3 )
    {
        mult = 0.2; // "sv_fps / 10"

        for( j = 0; j <= ( level.total_distance * 10 * mult / speed ); j++ )
        {
            t = ( j * speed / (level.total_distance * 10 * mult) );

            pos[0] = 0; pos[1] = 0; pos[2] = 0;
            ang[0] = 0; ang[1] = 0; ang[2] = 0;

            for( i = 1; i <= level.cam["count"]; i++ )
            {
                for( z = 0; z < 3; z++ )
                {
                    pos[z] += float( diff( i-1, level.cam["count"]-1) * pow( (1-t), level.cam["count"]-i ) * pow( t, i-1 ) * level.cam["origin"][i][z] );
                    ang[z] += float( diff( i-1, level.cam["count"]-1) * pow( (1-t), level.cam["count"]-i ) * pow( t, i-1 ) * level.cam["angles"][i][z] );
                }
            }
            camera moveto( (pos[0] ,pos[1], pos[2]), .1, 0, 0 );
            camera rotateto( (ang[0], ang[1], ang[2]), .1, 0, 0 );
            wait 0.05;
        }
    }

    showcamprev();
    setDvar( "cg_draw2d", 1 );
    setdvar( "cg_drawGun", 1 );
    setdvar( "cg_drawCrosshair", 1 );
    self unlink();
    //self playershow();
    camera delete();
}

preparenodedistances() 
{
    level.total_distance = 0;
    for( k = 1; k < level.cam["count"]; k++ )
    {
        x = level.cam["angles"][k][1];
        y = level.cam["angles"][k+1][1];
        
        if( y - x >= 180 )
            level.cam["angles"][k] += (0,360,0);
        else if( y - x <= -180 )
            level.cam["angles"][k+1] += (0,360,0);

        level.mov_distance[k]   = distance( level.cam["origin"][k], level.cam["origin"][k+1] );
        level.ang_distance[k]   = distance( level.cam["angles"][k], level.cam["angles"][k+1] );
        level.total_distance    += level.mov_distance[k];
        level.total_distance    += level.ang_distance[k];
    }
}

camsetrot( args )
{
    roll = args[0];
    angles = self.angles;
    self setPlayerAngles( ( angles[0], angles[1], int( roll ) ) );
    self iprintln("[^2H1CAM^7] * Added ^3" + roll + " deg" );
}

hidecamprev()
{
    foreach( obj in level.cam["obj"] )
        obj hide();
    foreach( path in level.cam["path"] )
        path hide();
}

showcamprev()
{
    foreach( obj in level.cam["obj"] )
        obj show();
    foreach( path in level.cam["path"] )
        path show();
}

deletecamprev()
{
    foreach( path in level.cam["path"] )
        path delete();
}

//  MATH FUNCTIONS

koeff( x, y )
{
    return ( fact( y ) / ( fact( x ) * fact( y - x ) ) );
}

diff( x, y )
{
    return ( fact( y ) / ( fact( x ) * fact( y - x ) ) );
}

fact( x )
{
    c = 1;
    if( x == 0 ) return 1;
    for( i = 1; i <= x; i++ )
        c = c * i;
    return c;
}

mod( a ) 
{
    if ( a >= 0 ) 
        return a;
    return a * ( -1 );
}

crossProduct( vecA, vecB )
{
    a = ( vecA[1] * vecB[2] ) - ( vecA[2] * vecB[1] );
    b = ( vecA[2] * vecB[0] ) - ( vecA[0] * vecB[2] );
    c = ( vecA[0] * vecB[1] ) - ( vecA[1] * vecB[0] );
    return ( a, b, c );
}

getPointOnSpline( cubic, s )
{
    return ( ( ( cubic.d * s ) + cubic.c ) * s + cubic.b ) * s + cubic.a;
}

calcCubicSpline( n, v )
{
    gamma	= []; 
    delta	= []; 
    D		= []; 

    gamma[0] = ( 0.5, 0.5, 0.5 );
    for( i = 1; i < n; i++ ) 
        gamma[i] = ( 1, 1, 1) / ( ( 4 * ( 1, 1, 1 ) ) - gamma[i-1]);
    gamma[n] = ( 1, 1, 1 ) / ( ( 2 * ( 1, 1, 1 ) ) - gamma[n-1] );

    delta[0] = 3 * ( ( v[1] - v[0] ) ) * gamma[0];
    for( i = 1; i < n; i++ ) 
        delta[i] = ( 3 * ( ( v[i + 1] - v[i-1] ) ) - delta[i-1] ) * gamma[i];
    delta[n] = ( 3 * ( ( v[n] - v[n-1] ) ) - delta[n-1] ) * gamma[n];

    D[n] = delta[n];
    for( i = n-1; i >= 0; i-- ) 
        D[i] = delta[i] - gamma[i] * D[i+1];
    

    C = [];
    for( i = 0; i < n; i++) 
        C[i] = createCubic( v[i], D[i], 3 * ( ( v[i+1] - v[i] ) ) - 2 * D[i] - D[i+1], 2 * ( ( v[i] - v[i+1] ) ) + D[i] + D[i+1] );
    
    return C;
}

createCubic( a, b, c, d )
{
    cubic   = spawnstruct();
    cubic.a = a;
    cubic.b = b;
    cubic.c = c;
    cubic.d = d;
    return cubic;
}