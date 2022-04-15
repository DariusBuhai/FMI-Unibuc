using UnityEngine;

public class Bullets : MonoBehaviour
{
    private const float DISTANCE_TO_DESPAWN = 100.0f;
    
    public Vector3 velocity = Vector3.zero;
    private float _distanceInAir;
    private GameLogic _gameLogic;

    void GenerateSpark()
    {
        var spark = Instantiate(_gameLogic.sparkPrefab);
        spark.transform.position = gameObject.transform.position;
        spark.transform.rotation =  Quaternion.Euler(0.0f, 0.0f, 0.0f);
        Destroy(spark, 1);
    }
    
    void GenerateBlood()
    {
        var blood = Instantiate(_gameLogic.bloodPrefab);
        blood.transform.position = gameObject.transform.position;
        blood.transform.rotation =  Quaternion.Euler(0.0f, 0.0f, 0.0f);
        Destroy(blood, 0.5f);
    }
    
    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Wall") || other.gameObject.CompareTag("Door"))
            GenerateSpark();
        if (other.gameObject.CompareTag("Enemy") || other.gameObject.CompareTag("Human") || other.gameObject.CompareTag("Enemy"))
            GenerateBlood();
        if(gameObject.CompareTag("BulletsEnemy") && (other.gameObject.CompareTag("Human") || other.gameObject.CompareTag("Enemy")))
            return;
        if (!other.gameObject.CompareTag("Bullets") && !other.gameObject.CompareTag("RewardAmmo") && !other.gameObject.CompareTag("BulletsEnemy"))
            Destroy(gameObject);

    }
    void Start()
    {
        _distanceInAir = 0.0f;
        var tags = GameObject.FindGameObjectsWithTag("GameController");
        _gameLogic = tags[0].GetComponent<GameLogic>();
    }

    void Update()
    {
        var movement = velocity * Time.deltaTime;
        transform.localPosition += movement;
        _distanceInAir += movement.magnitude;

        if (_distanceInAir >= DISTANCE_TO_DESPAWN)
            Destroy(gameObject);
    }
}
