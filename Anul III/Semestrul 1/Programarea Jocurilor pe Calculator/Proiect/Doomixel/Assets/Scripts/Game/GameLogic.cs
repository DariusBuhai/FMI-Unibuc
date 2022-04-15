using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;
using Random = UnityEngine.Random;

public class GameLogic : MonoBehaviour
{
    [Serializable]
    public struct EnemyType
    {
        public GameObject prefab;
        public float chance;
    }

    private const int MAX_ROOMS_IN_QUEUE = 3;
    public GameObject playerObject;
    public GameObject floorPrefab;
    public GameObject wallPrefab;
    public GameObject ceilingPrefab;
    public GameObject sparkPrefab;
    public GameObject bloodPrefab;

    public GameObject doorPrefab;
    public GameObject closedDoorPrefab;

    public List<EnemyType> enemyTypes;

    public GameObject navMesh;
    public NavMeshSurface[] surfaces;

    public int minTilesRoom;
    public int minRoomRectangleWidth;
    public int maxRoomRectangleWidth;

    public float roomTileScale = 1.0f;
    public float panelSize = 10.0f;

    public int enemiesCount;

    private LinkedList<Room> _roomsList;
    private Room _currentRoom;
    public static bool gamePaused = false;
    public static bool gameOver = false;
    public GameObject pauseMenuComponent;
    public GameObject gameOverMenuComponent;

    public Material[] doorMaterials;

    void Start()
    {
        Initiate();
    }

    void Initiate()
    {
        gamePaused = false;
        gameOver = false;
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
        Time.timeScale = 1f;
        surfaces = navMesh.GetComponents<NavMeshSurface>();
        AssignPlayer();
        _roomsList = new LinkedList<Room>();
        _currentRoom = CreateRoom(null);
        _roomsList.AddLast(_currentRoom);
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            if (gameOver)
                return;
            if (gamePaused)
                ContinueGame();
            else
                PauseGame();
            return;
        }

        if (playerObject is null)
            AssignPlayer();

        if (playerObject is null)
            return;

        ActivateEnemies();

        if (_roomsList.Last().Door.transform.GetComponentInChildren<Door>().open &&
            _roomsList.Count < MAX_ROOMS_IN_QUEUE)
            _roomsList.AddLast(CreateRoom(_roomsList.Last()));

        UpdateDeadEnemies();
        UpdateCurrentRoom();
    }

    public void PauseGame()
    {
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        gamePaused = true;
        Time.timeScale = 0f;
        pauseMenuComponent.SetActive(true);
        SoundManagerScript.PauseMusic();
    }

    public void NewGame()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }

    public void GameOver()
    {
        ScoreScript.SaveScore();
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        gameOver = true;
        Time.timeScale = 0f;
        gameOverMenuComponent.SetActive(true);
        SoundManagerScript.PauseMusic();
    }

    public void ContinueGame()
    {
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
        gamePaused = false;
        Time.timeScale = 1f;
        pauseMenuComponent.SetActive(false);
        SoundManagerScript.PlayMusic();
    }

    public void ExitGame()
    {
        ScoreScript.SaveScore();
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex - 1);
    }

    private void ActivateEnemies()
    {
        foreach (var room in _roomsList)
        {
            foreach (var enemy in room.Enemies)
            {
                var navMeshAgent = enemy.GetComponent<NavMeshAgent>();
                if (navMeshAgent != null && !navMeshAgent.enabled)
                {
                    navMeshAgent.enabled = true;
                }
            }
        }
    }

    private void BuildNavMeshSurfaces()
    {
        foreach (NavMeshSurface surface in surfaces)
        {
            surface.BuildNavMesh();
        }
    }

    private void UpdateCurrentRoom()
    {
        if (_currentRoom.Enemies.Count == 0)
        {
            if (_currentRoom.Door != null)
                _currentRoom.Door.GetComponentInChildren<Door>().Open();
        }

        var currentRoom = _roomsList.Find(_currentRoom);
        var nextRoom = currentRoom.Next == null ? null : currentRoom.Next.Value;

        if (nextRoom != null)
        {
            bool changeRoom = false;

            Vector3 currentPlayerTile = new Vector3((playerObject.transform.position.x) / (panelSize * roomTileScale),
                0.0f,
                (playerObject.transform.position.z) / (panelSize * roomTileScale));
            Vector2Int playerTilePos = new Vector2Int((int) Math.Round(currentPlayerTile.x),
                (int) Math.Round(currentPlayerTile.z));
            foreach (var tile in nextRoom.RoomTiles)
            {
                if (nextRoom.ClosedNextTilePosition.HasValue)
                    if (playerTilePos.x == tile.Position.x &&
                        playerTilePos.z == tile.Position.z &&
                        tile.Position.x != nextRoom.ClosedNextTilePosition.Value.x &&
                        tile.Position.z != nextRoom.ClosedNextTilePosition.Value.z)
                        changeRoom = true;
            }

            if (changeRoom)
            {
                _currentRoom = nextRoom;

                if (_currentRoom.ClosedDoor != null)
                    _currentRoom.ClosedDoor.GetComponentInChildren<ClosedDoor>().closing = true;
            }
        }

        _roomsList.First();

        if (_roomsList.Count >= 2)
        {
            var first = _roomsList.First;
            var second = first.Next.Value;
            if (second.ClosedDoor.GetComponentInChildren<ClosedDoor>().closed)
            {
                // navMeshSurface.BuildNavMesh();
                DestroyRoom(first.Value);
                _roomsList.RemoveFirst();
                BuildNavMeshSurfaces();
            }
        }
    }

    private void AssignPlayer()
    {
        playerObject = GameObject.FindWithTag("Player");
    }

    private Room CreateRoom(Room previousRoom)
    {
        var result = new Room();

        result.RoomTiles = new List<RoomTile>();

        HashSet<Vector2Int> chosenTiles = new HashSet<Vector2Int>();

        while (chosenTiles.Count < minTilesRoom)
        {
            Vector2Int origin = previousRoom == null ? new Vector2Int(0, 0) : previousRoom.NextTilePosition;
            if (chosenTiles.Count > 0)
                origin = chosenTiles.ElementAt(Random.Range(0, chosenTiles.Count));

            Vector2Int rectSize = new Vector2Int(Random.Range(minRoomRectangleWidth, maxRoomRectangleWidth + 1),
                Random.Range(minRoomRectangleWidth, maxRoomRectangleWidth + 1));

            Vector2Int pointsDifference = rectSize + new Vector2Int(-1, -1);

            Vector2Int topRight = origin + pointsDifference;

            if (Random.Range(0, 2) == 0)
            {
                origin = new Vector2Int(origin.x - pointsDifference.x, origin.z);
                topRight = new Vector2Int(topRight.x - pointsDifference.x, topRight.z);
            }

            if (Random.Range(0, 2) == 0)
            {
                origin = new Vector2Int(origin.x, origin.z - pointsDifference.z);
                topRight = new Vector2Int(topRight.x, topRight.z - pointsDifference.z);
            }

            bool canAddRectangle = true;
            if (previousRoom != null)
            {
                for (int x = origin.x; x <= topRight.x; x++)
                {
                    for (int z = origin.z; z <= topRight.z; z++)
                    {
                        Vector2Int newPoint = new Vector2Int(x, z);
                        if (!chosenTiles.Contains(newPoint))
                        {
                            foreach (var room in _roomsList)
                                if (room.RoomTiles
                                    .FindAll(x => x.Position.x == newPoint.x && x.Position.z == newPoint.z).Count > 0)
                                    canAddRectangle = false;
                        }
                    }
                }
            }

            if (canAddRectangle)
            {
                for (int x = origin.x; x <= topRight.x; x++)
                {
                    for (int z = origin.z; z <= topRight.z; z++)
                    {
                        Vector2Int newPoint = new Vector2Int(x, z);
                        if (!chosenTiles.Contains(newPoint))
                            chosenTiles.Add(newPoint);
                    }
                }
            }
        }

        foreach (var tile in chosenTiles)
        {
            var floor = Instantiate(floorPrefab);
            floor.transform.position = new Vector3(tile.x * panelSize * roomTileScale,
                0.0f,
                tile.z * panelSize * roomTileScale);
            floor.transform.localScale = new Vector3(roomTileScale, 1.0f, roomTileScale);

            var ceiling = Instantiate(ceilingPrefab);
            ceiling.transform.position = new Vector3(floor.transform.position.x, 0.0f, floor.transform.position.z);

            var actualCeiling = ceiling.transform.GetChild(0);
            actualCeiling.transform.localScale = new Vector3(roomTileScale, 1.0f, roomTileScale);
            actualCeiling.transform.localPosition = new Vector3(actualCeiling.transform.localPosition.x,
                actualCeiling.transform.localPosition.y * roomTileScale,
                actualCeiling.transform.localPosition.z);

            var roomTile = new RoomTile()
            {
                Position = tile,
                Floor = floor,
                Walls = new List<GameObject>(),
                PositionsBehindWalls = new List<Vector2Int>(),
                Ceiling = ceiling
            };

            result.RoomTiles.Add(roomTile);
        }

        AddWalls(chosenTiles, result, previousRoom);
        // update the navMeshSurface
        BuildNavMeshSurfaces();
        // navMeshSurface.BuildNavMesh();

        SpawnEnemies(result);

        return result;
    }

    private void SpawnEnemies(Room room)
    {
        room.Enemies = new List<GameObject>();

        while (room.Enemies.Count < enemiesCount)
        {
            var enemy = RouletteWheelSelection();
            if (enemy != null)
            {
                var enemyObject = Instantiate(enemy);

                bool exists = false;
                foreach (var otherTile in room.RoomTiles)
                    if (otherTile.Walls.Count == 0)
                        exists = true;

                var roomTile = Random.Range(0, room.RoomTiles.Count);
                var tile = room.RoomTiles[roomTile];

                if (exists)
                {
                    while (tile.Walls.Count != 0)
                    {
                        roomTile = Random.Range(0, room.RoomTiles.Count);
                        tile = room.RoomTiles[roomTile];
                    }
                }

                enemyObject.transform.position = new Vector3(tile.Floor.transform.position.x, 1.0f,
                    tile.Floor.transform.position.z);
                SetEnemyWaypoints(enemyObject, tile, room);
                room.Enemies.Add(enemyObject);
            }
        }
    }

    private void SetEnemyWaypoints(GameObject enemy, RoomTile currentTile, Room room)
    {
        var enemyAi = enemy.GetComponent<EnemyAI>();
        if (enemyAi != null)
        {
            List<Vector2Int> visitedPositions = new List<Vector2Int>();
            HashSet<Vector2Int> visitedPositionsSet = new HashSet<Vector2Int>();

            visitedPositions.Add(currentTile.Position);
            visitedPositionsSet.Add(currentTile.Position);

            int listIndex = 0;
            while (visitedPositionsSet.Count < enemyAi.maxWalkTilesRange && listIndex < visitedPositions.Count)
            {
                var currentPosition = visitedPositions[listIndex++];

                int[] dx = {0, -1, 0, 1};
                int[] dz = {-1, 0, 1, 0};

                for (int i = 0; i < dx.Length; i++)
                {
                    Vector2Int nextPos = currentPosition + new Vector2Int(dx[i], dz[i]);
                    if (!visitedPositionsSet.Contains(nextPos))
                    {
                        if (room.RoomTiles.Any(x => x.Position.x == nextPos.x && x.Position.z == nextPos.z))
                        {
                            var roomTile = room.RoomTiles.Find(x =>
                                x.Position.x == nextPos.x && x.Position.z == nextPos.z);
                            if (roomTile.Walls.Count == 0)
                            {
                                visitedPositions.Add(nextPos);
                                visitedPositionsSet.Add(nextPos);
                            }
                        }
                    }
                }
            }

            int waypointsCount = Math.Min(Random.Range(enemyAi.minPathLength, enemyAi.maxPathLength + 1),
                visitedPositions.Count);
            for (int i = 0; i < visitedPositions.Count; i++)
            {
                int otherIx = Random.Range(0, visitedPositions.Count);
                Vector2Int tmp = visitedPositions[i];
                visitedPositions[i] = visitedPositions[otherIx];
                visitedPositions[otherIx] = tmp;
            }

            visitedPositions.RemoveRange(waypointsCount, visitedPositions.Count - waypointsCount);
            Vector3[] actualPositions = new Vector3[visitedPositions.Count];
            for (int i = 0; i < visitedPositions.Count; i++)
                actualPositions[i] = new Vector3(visitedPositions[i].x * panelSize * roomTileScale, 0.0f,
                    visitedPositions[i].z * panelSize * roomTileScale);

            enemyAi.waypointPositions = actualPositions;
        }
    }

    GameObject RouletteWheelSelection()
    {
        float chancesSum = 0.0f;
        foreach (var enemyType in enemyTypes)
            chancesSum += enemyType.chance;

        float chosenPoint = Random.Range(0.0f, chancesSum);

        float accumulated = 0.0f;

        foreach (var enemyType in enemyTypes)
        {
            accumulated += enemyType.chance;
            if (accumulated >= chosenPoint)
                return enemyType.prefab;
        }

        return null;
    }

    private bool Lee(Vector2Int nextDoorPosition)
    {
        Queue<Vector2Int> testPositions = new Queue<Vector2Int>();
        HashSet<Vector2Int> goodPositions = new HashSet<Vector2Int>();
        HashSet<Vector2Int> triedPositions = new HashSet<Vector2Int>();

        testPositions.Enqueue(nextDoorPosition);
        triedPositions.Add(nextDoorPosition);

        while (testPositions.Count > 0 && goodPositions.Count < minTilesRoom)
        {
            bool goodTile = true;
            var currentPosition = testPositions.Dequeue();

            foreach (var gameRoom in _roomsList)
                if (gameRoom.RoomTiles.Any(x => x.Position.x == currentPosition.x && x.Position.z == currentPosition.z))
                    goodTile = false;

            if (goodTile)
            {
                goodPositions.Add(currentPosition);

                int[] dx = {0, -1, 0, 1};
                int[] dz = {-1, 0, 1, 0};

                for (int i = 0; i < dx.Length; i++)
                {
                    Vector2Int nextPos = currentPosition + new Vector2Int(dx[i], dz[i]);
                    if (!triedPositions.Contains(nextPos))
                    {
                        testPositions.Enqueue(nextPos);
                        triedPositions.Add(nextPos);
                    }
                }
            }
        }

        return goodPositions.Count >= minTilesRoom;
    }

    private void AddWalls(HashSet<Vector2Int> chosenTiles, Room room, Room previousRoom)
    {
        List<GameObject> addedWalls = new List<GameObject>();
        List<Vector2Int> addedWallsPositions = new List<Vector2Int>();

        room.ClosedDoor = null;
        room.ClosedNextTilePosition = null;

        foreach (var tile in room.RoomTiles)
        {
            int[] dx = {0, -1, 0, 1};
            int[] dz = {-1, 0, 1, 0};

            for (int i = 0; i < dx.Length; i++)
            {
                Vector2Int nextPos = tile.Position + new Vector2Int(dx[i], dz[i]);
                bool closedDoor = false;

                if (previousRoom == null)
                {
                    closedDoor = false;
                }
                else if (previousRoom.DoorPosition.x == nextPos.x &&
                         previousRoom.DoorPosition.z == nextPos.z &&
                         tile.Position.x == previousRoom.NextTilePosition.x &&
                         tile.Position.z == previousRoom.NextTilePosition.z)
                {
                    closedDoor = true;
                }

                if (!chosenTiles.Contains(nextPos))
                {
                    var prefab = closedDoor ? closedDoorPrefab : wallPrefab;
                    var wallObject = Instantiate(prefab);
                    wallObject.transform.position = tile.Floor.transform.position;
                    wallObject.transform.rotation = Quaternion.Euler(0.0f, i * 90.0f, 0.0f);

                    var actualWall = wallObject.transform.GetChild(0);
                    actualWall.transform.tag = closedDoor ? "Door" : "Wall";
                    actualWall.transform.localScale = new Vector3(roomTileScale, 1.0f, roomTileScale);
                    actualWall.transform.localPosition = new Vector3(actualWall.transform.localPosition.x,
                        actualWall.transform.localPosition.y * roomTileScale,
                        actualWall.transform.localPosition.z * roomTileScale);

                    if (closedDoor)
                    {
                        room.ClosedDoor = wallObject;
                        room.ClosedNextTilePosition = tile.Position;
                        actualWall.transform.localPosition = actualWall.transform.localPosition +
                                                             new Vector3(0.0f, panelSize * roomTileScale * 2.0f, 0.0f);
                        actualWall.GetComponent<ClosedDoor>().panelSize = panelSize;
                        actualWall.GetComponent<ClosedDoor>().tileScale = roomTileScale;
                        actualWall.GetComponent<MeshRenderer>().material = previousRoom.Door.GetComponentInChildren<MeshRenderer>().sharedMaterial;
                    }

                    tile.Walls.Add(wallObject);
                    tile.PositionsBehindWalls.Add(nextPos);
                    addedWalls.Add(wallObject);
                    addedWallsPositions.Add(nextPos);
                }
            }
        }

        int index = Random.Range(0, addedWalls.Count);
        var chosenWall = addedWalls[index];
        var chosenWallPosition = addedWallsPositions[index];
        bool validDoor = Lee(chosenWallPosition);

        while (chosenWall == room.ClosedDoor || !validDoor)
        {
            index = Random.Range(0, addedWalls.Count);
            chosenWall = addedWalls[index];
            chosenWallPosition = addedWallsPositions[index];
            validDoor = Lee(chosenWallPosition);
        }

        foreach (var tile in room.RoomTiles)
        {
            for (int i = 0; i < tile.Walls.Count; i++)
            {
                if (tile.Walls[i] == chosenWall)
                {
                    var doorObject = Instantiate(doorPrefab);
                    doorObject.transform.position = tile.Floor.transform.position;
                    doorObject.transform.rotation = chosenWall.transform.rotation;

                    var actualDoor = doorObject.transform.GetChild(0);
                    var actualWall = chosenWall.transform.GetChild(0);

                    actualDoor.transform.localScale = actualWall.transform.localScale;
                    actualDoor.transform.localPosition = actualWall.transform.localPosition;

                    actualDoor.GetComponent<Door>().roomTileScale = roomTileScale;
                    actualDoor.GetComponent<Door>().panelSize = panelSize;
                    actualDoor.GetComponent<MeshRenderer>().material = doorMaterials[Random.Range(0, doorMaterials.Length)];
                    //if (previousRoom == null)
                    //    actualDoor.GetComponent<Door>().Open();

                    Destroy(tile.Walls[i]);

                    tile.Walls[i] = doorObject;

                    room.Door = doorObject;
                    room.NextTilePosition = tile.PositionsBehindWalls[i];
                    room.DoorPosition = tile.Position;
                }
            }
        }
    }

    private void DestroyRoom(Room room)
    {
        foreach (var enemy in room.Enemies)
        {
            var killable = enemy.GetComponent<Killable>();
            if (killable != null)
                killable.Kill();
        }

        UpdateDeadEnemies();

        foreach (var tile in room.RoomTiles)
        {
            Destroy(tile.Floor);
            Destroy(tile.Ceiling);
            foreach (var wall in tile.Walls)
                Destroy(wall);

            tile.Walls.Clear();
            tile.PositionsBehindWalls.Clear();
        }

        room.RoomTiles.Clear();
        room.Door = null;
        room.ClosedDoor = null;
    }

    private void UpdateDeadEnemies()
    {
        HashSet<GameObject> toRemove = new HashSet<GameObject>();
        foreach (var room in _roomsList)
        foreach (var enemy in room.Enemies)
        {
            var killable = enemy.GetComponent<Killable>();
            if (killable != null)
            {
                if (killable.IsDead())
                    toRemove.Add(enemy);
            }
        }

        foreach (var room in _roomsList)
            room.Enemies.RemoveAll(x => toRemove.Contains(x));

        foreach (var enemy in toRemove)
            Destroy(enemy);
    }
}