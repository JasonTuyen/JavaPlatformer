//aka game class
//if i ever come back, clean code and "finalize game" (scores, music, etc.)
//can def do animation, make an animation class that inherits spirte class and add enemies which will also inherit these classes
//https://www.kenney.nl/assets

//globals
Sprite p;
PImage red_brick, crate;
ArrayList<Sprite> platforms;

float view_x = 0;
float view_y = 0;

final static float MOVE_SPEED = 5;
final static float SPIRTE_SCALE = 50.0/128;
final static float SPRITE_SIZE = 50;
final static float GRAVITY = 0.6;
final static float JUMP_SPEED = 10;

final static float RIGHT_MARGIN = 250;
final static float LEFT_MARGIN = 50;
final static float VERTICAL_MARGIN = 50;

//init
void setup(){
    size(800,600);
    imageMode(CENTER);
    p = new Sprite("character.png", 1.0, 100, 300);
    p.change_x = 0;
    p.change_y = 0;
    platforms = new ArrayList<Sprite>();
    red_brick = loadImage("red_brick.png");
    crate = loadImage("crate.png");
    createPlatforms("map.csv");
}

//modify and updates
void draw(){
    background(255);
    scroll();
    p.display();
    resolvePlatformCollisions(p, platforms);

    for(Sprite s: platforms)
        s.display();
}

void scroll(){
    float right_boundary = view_x + width - RIGHT_MARGIN;
    if(p.getRight() > right_boundary){
        view_x += p.getRight() - right_boundary;
    }

    float left_boundary = view_x + LEFT_MARGIN;
    if(p.getLeft() < left_boundary){
        view_x -= left_boundary - p.getLeft();
    }

    float bottom_boundary = view_y + height - VERTICAL_MARGIN;
    if(p.getBottom() > bottom_boundary){
        view_y += p.getBottom() - bottom_boundary;
    }

    float top_boundary = view_y + VERTICAL_MARGIN;
    if(p.getTop() < top_boundary){
        view_y -= top_boundary - p.getTop();
    }

    translate(-view_x, -view_y);
}

public boolean isOnPlatform(Sprite s, ArrayList<Sprite> walls){
    s.center_y += 5;
    ArrayList<Sprite> col_list = checkCollisionList(s, walls);
    s.center_y -= 5;
    if(col_list.size() > 0){
        return true;
    }else
    return false;
}

public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls){
    //add gravity to change_y
    s.change_y += GRAVITY;
    //determine collisions in y direction
    s.center_y += s.change_y;
    ArrayList<Sprite> col_list = checkCollisionList(s, walls);
    if(col_list.size() > 0){
        Sprite collided = col_list.get(0);
        if(s.change_y > 0){
            s.setBottom(collided.getTop());
        }
        else if(s.change_y < 0){
            s.setTop(collided.getBottom());
        }
        s.change_y = 0;
    }
    //determin collisions in x direcetion
    s.center_x += s.change_x;
    col_list = checkCollisionList(s, walls);
    if(col_list.size() > 0){
        Sprite collided = col_list.get(0);
        if(s.change_x > 0){
            s.setRight(collided.getLeft());
        }
        else if(s.change_x < 0){
            s.setLeft(collided.getRight());
        }
    }
}

//Four Check Cases for collisions
boolean checkCollision(Sprite s1, Sprite s2){
    boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
    boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
    if(noXOverlap || noYOverlap){
        return false;
    }else{
        return true;
    }
}

public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
    ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
    for (Sprite p: list){
        if(checkCollision(s,p)){
            collision_list.add(p);
        }
    }
    return collision_list;
}

void createPlatforms(String filename){
    String[] lines = loadStrings(filename);
    for(int row=0; row < lines.length; row++){
        String[] values = split(lines[row], ",");
        for(int col=0; col < values.length; col++){
            if(values[col].equals("1")){
                Sprite s = new Sprite(red_brick, SPIRTE_SCALE);
                s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
                s.center_y = SPRITE_SIZE/2 + row *SPRITE_SIZE;
                platforms.add(s);
            }
            else if(values[col].equals("2")){
                Sprite s = new Sprite(crate, SPIRTE_SCALE);
                s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
                s.center_y = SPRITE_SIZE/2 + row *SPRITE_SIZE;
                platforms.add(s);
            }
        }
    }
}

//controller
void keyPressed(){
    if(keyCode == RIGHT){
        p.change_x = MOVE_SPEED;
    }
    else if(keyCode == LEFT){
        p.change_x = -MOVE_SPEED;
    }
    else if(keyCode == UP && isOnPlatform(p, platforms)){
         p.change_y = -JUMP_SPEED;
    }
    else if(keyCode == DOWN){
        p.change_y = MOVE_SPEED;
    }
}

void keyReleased() {
    if(keyCode == RIGHT){
        p.change_x = 0;
    }
    else if(keyCode == LEFT){
        p.change_x = 0;
    }
    else if(keyCode == UP){
        p.change_y = 0;
    }
    else if(keyCode == DOWN){
        p.change_y = 0;
    }
}