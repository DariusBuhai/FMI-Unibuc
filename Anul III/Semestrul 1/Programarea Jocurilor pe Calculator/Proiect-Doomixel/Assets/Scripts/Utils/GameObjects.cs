using System.Collections.Generic;
using UnityEngine;

struct Vector2Int
{
    public Vector2Int(int x, int z)
    {
        this.x = x;
        this.z = z;
    }

    public static Vector2Int operator +(Vector2Int a, Vector2Int b)
    {
        a.x += b.x;
        a.z += b.z;
        return a;
    }

    public int x;
    public int z;
}

struct RoomTile
{
    public Vector2Int Position { get; set; }
    public GameObject Floor { get; set; }
    public List<GameObject> Walls { get; set; }
    public List<Vector2Int> PositionsBehindWalls { get; set; }
    public GameObject Ceiling { get; set; }
}

class Room
{
    public List<RoomTile> RoomTiles { get; set; }
    public GameObject ClosedDoor { get; set; }
    public Vector2Int? ClosedNextTilePosition { get; set; }
    public GameObject Door { get; set; }
    public Vector2Int NextTilePosition { get; set; }
    public Vector2Int DoorPosition { get; set; }
    public List<GameObject> Enemies { get; set; }
}