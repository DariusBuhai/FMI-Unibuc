using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.AI;

public class EnemyAI : MonoBehaviour
{
    private NavMeshAgent agent;
    private Transform playerTransform;
    
    // Walk around
    Vector3 walkPoint;
    bool walkPointSet;
    
    // Attack
    public float attackCooldown;
    // Enemy Bullet
    public bool shooter = false;
    public float bulletSpeed = 10.0f;
    public GameObject bullet = null;
    private Vector3 velocity = Vector3.zero;
    private MonsterFrames _monsterFrames;
    bool attacked;

    public float attackRadius;
    bool playerInSightRange, playerInAttackRange;

    public Vector3[] waypointPositions = null;
    private int waypointIndex = 0;

    public int maxWalkTilesRange = 15;
    public int minPathLength = 3;
    public int maxPathLength = 10;

    public int raysNumber = 5;
    public float rayAngle = 10.0f;
    public float rayDistance = 10.0f;

    private List<Vector3> _rays = null;

    private GameObject player;
    private PlayerController playerController;

    private MonsterFrames.MonsterFrame? monsterFrameFront = null;

    private void Start()
    {
        if ((int) Settings.GetDifficulty() == 2)
            attackCooldown -= 1;
        else if ((int) Settings.GetDifficulty() == 3)
            attackCooldown -= 2;
    }

    void Awake()
    {
        player = GameObject.Find("Player");
        playerController = player.GetComponent<PlayerController>();
        playerTransform = player.transform;
        agent = GetComponent<NavMeshAgent>();
        _monsterFrames = GetComponent<MonsterFrames>();
        setMonsterFrontFrame();
    }

    // Update is called once per frame
    void Update()
    {
        playerInSightRange = CheckPlayerInSight(); // use some raycasting using the orientation and radius
        playerInAttackRange = Vector3.Distance(playerTransform.position, this.transform.position) <= attackRadius; // use some raycasting or euclidian distance (because the enemy is already facing the player)

        if(!playerInSightRange && !playerInAttackRange)
        { 
            MoveAround();
        }
        if(playerInSightRange && !playerInAttackRange) 
        { 
            ChasePlayer();
        }
        if(playerInAttackRange && playerInAttackRange) 
        {
            AttackPlayer();
        }
    }

    void OnDrawGizmos()
    {
        if (_rays is null)
            return;

        foreach (var ray in _rays)
            Gizmos.DrawLine(transform.position, transform.position + ray * rayDistance);
    }

    private void setMonsterFrontFrame()
    {
        if(_monsterFrames == null) 
        {
            return;
        }
        foreach(var f in _monsterFrames.frames) 
        {
            if(f.isFront)
            {
                monsterFrameFront = f;
            }
        }
    }

    private bool CheckPlayerInSight()
    {
        var forward = (walkPoint - transform.position).normalized;
        Quaternion l = Quaternion.Euler(0.0f, -rayAngle, 0.0f);
        Quaternion r = Quaternion.Euler(0.0f, rayAngle, 0.0f);

        List<Vector3> directions = new List<Vector3>() { forward };
        
        var currentDirection = forward;
        for (int leftRay = 0; leftRay < raysNumber; leftRay++)
        {
            currentDirection = l * currentDirection;
            directions.Add(currentDirection);
        }

        currentDirection = forward;
        for (int rightRay = 0; rightRay < raysNumber; rightRay++)
        {
            currentDirection = r * currentDirection;
            directions.Add(currentDirection);
        }

        _rays = directions;

        foreach (var direction in directions)
        {
            RaycastHit hit;
            if (Physics.Raycast(transform.position, transform.TransformDirection(direction), out hit))
                if (hit.distance < rayDistance)
                    if (hit.transform.CompareTag("Player"))
                        return true;
        }

        return false;
    }

    private void MoveAround() 
    {
        if (!walkPointSet)
        {
            SearchWalkPoint();
        }
        else
        {
            agent.SetDestination(walkPoint);
        }

        Vector3 distanceLeft = transform.position - walkPoint;

        if(distanceLeft.magnitude < 5f)
        {
            walkPointSet = false;
        }
    }

    private void SearchWalkPoint()
    {
        if (waypointPositions is null)
            return;

        walkPoint = waypointPositions[waypointIndex++];
        waypointIndex %= waypointPositions.Length;

        walkPointSet = true;
    }

    private void ChasePlayer() 
    {
        agent.SetDestination(playerTransform.position);
    }

    private void shootPlayer()
    {
        var bullets = Instantiate(bullet, transform.position, Quaternion.identity);
        Physics.IgnoreCollision(bullets.GetComponent<Collider>(), GetComponent<Collider>());
        bullets.GetComponent<Bullets>().velocity = (playerTransform.position - transform.position).normalized * bulletSpeed;
        if(_monsterFrames != null && monsterFrameFront.HasValue)
        {
            GetComponent<MeshRenderer>().material = monsterFrameFront.Value.material;
        }
    }

    private void hurtPlayer()
    {
        playerController.DecreaseLife();
    }

    private void AttackPlayer() 
    {
        agent.SetDestination(transform.position);
        if(!attacked)
        {
            attacked = true;
            if(shooter) {
                shootPlayer();
            } else {
                hurtPlayer();
            }
            Invoke(nameof(AttackAgain), attackCooldown);
        }
    }

    private void AttackAgain()
    {
        attacked = false;
        Debug.Log("attacked");
    }
}
