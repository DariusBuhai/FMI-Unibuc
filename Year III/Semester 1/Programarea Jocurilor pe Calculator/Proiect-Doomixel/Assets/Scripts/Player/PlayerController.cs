using UnityEngine;
using TMPro;

public class PlayerController : MonoBehaviour
{
    private const float MIN_MOVEMENT_BIAS = 0.01f;
    private const float MAX_SWING_VAL = 40.0f;

    public float mouseSensitivity = 300.0f;
    public float movementSpeed = 10.0f;
    public float timeToShootBullet = 0.1f;
    public float bulletSpeed = 25.0f;

    public GameObject bulletsPrefab;

    private Rigidbody _rigidbody;
    private Collider _collider;
    private float _accumulatedShootTime;

    public float lives = 5;

    public int boolStart = 0;
    public GameObject weapon;
    private Vector3 weaponOrigin;
    private float weaponPos = 0.0f;
    private int swingOrientation = -1;
    private float swingSpeed = 150.0f;
    
    private float moveDelay = 0.0f; 

    public GameObject gameLogicInstance;
    private GameLogic gameLogic;

    private const float IMMUNITY_DURATION = 2.0f;
    private bool immune = false;
    private float flicker_interval = 0.15f;

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("BulletsEnemy"))
        {
            DecreaseLife();
        }
    }

    float calculateMovePath(float x) {
        return 0.0025f * Mathf.Pow(x, 2);
    }

    void Start()
    {
        _rigidbody = GetComponent<Rigidbody>();
        _collider = GetComponent<Collider>();
        weaponOrigin = weapon.transform.position;

        gameLogic = gameLogicInstance.GetComponent<GameLogic>();

        Cursor.lockState = CursorLockMode.Locked;
        _accumulatedShootTime = 0.0f;
        
        if ((int) Settings.GetDifficulty() == 2)
            timeToShootBullet += 0.1f;
        else if ((int) Settings.GetDifficulty() == 3)
            timeToShootBullet += 0.2f;
    }

    void Update()
    {
        if (Cursor.lockState == CursorLockMode.None)
            return;
        
        var diffMouseX = Input.GetAxis("Mouse X");
        transform.Rotate(new Vector3(0.0f, diffMouseX * mouseSensitivity, 0.0f) * Time.deltaTime);

        if (Input.GetButton("Fire1"))
        {
            weapon.transform.position = weaponOrigin;
            moveDelay = 0.25f;
            weaponPos = 0.0f;
            boolStart = 1;

            _accumulatedShootTime += Time.deltaTime;

            while (_accumulatedShootTime >= timeToShootBullet)
            {
                SpawnBullet();
               
                _accumulatedShootTime -= timeToShootBullet;
            }
        }
    }

    void MoveWeapon() {
        float new_pos_y = calculateMovePath(weaponPos);
        var posVector = new Vector3(weaponPos, new_pos_y, 0.0f);

        weaponPos += swingSpeed * swingOrientation * Time.deltaTime;
        if(Mathf.Abs(weaponPos) > MAX_SWING_VAL) {
            weaponPos = MAX_SWING_VAL * swingOrientation;
            swingOrientation *= -1;
        }

        weapon.transform.position = weaponOrigin + posVector;
    }

    void FixedUpdate()
    {
        var horizontal = Input.GetAxis("Horizontal");
        var vertical = Input.GetAxis("Vertical");

        var inputVector = new Vector3(horizontal, 0.0f, vertical);

        _rigidbody.angularVelocity = Vector3.zero;

        if (inputVector.magnitude < MIN_MOVEMENT_BIAS)
        {
            _rigidbody.velocity = Vector3.zero;
            return;
        }

        var rotatedVector = GetCurrentAngleAxis() * inputVector;

        _rigidbody.velocity = rotatedVector * movementSpeed;
        if(moveDelay == 0)
        {
            MoveWeapon();
        }
        else
        {
            moveDelay = Mathf.Max(0.0f, moveDelay - Time.deltaTime);
        }
        
    }

    void SpawnBullet()
    {
        if (bulletsPrefab is null)
            return;

        if (Control.selectedBullet is null)
        {
            SoundManagerScript.PlaySound("gunshot_empty");
            return;
        }

        var bullets = Instantiate(bulletsPrefab, transform.position, Quaternion.identity);
        Physics.IgnoreCollision(bullets.GetComponent<Collider>(), _collider);
        bullets.GetComponent<Bullets>().velocity = GetCurrentAngleAxis() * Vector3.forward * bulletSpeed;

        if (Control.selectedBullet != null)
        {
            if (Control.selectedBullet.GetAmmo() >= 1)
            {
                SoundManagerScript.PlaySound("gunshot");

                if (Control.selectedBullet.id != 0)
                {  
                    Control.selectedBullet.ammo -= 1;
                    Control.selectedBorder.GetChild(0).GetChild(1).GetComponent<TextMeshProUGUI>().text = Control.selectedBullet.GetAmmo().ToString("0");
                }
                else
                    Control.selectedBorder.GetChild(0).GetChild(1).GetComponent<TextMeshProUGUI>().text = "\u221E";
               
                bullets.GetComponent<MeshRenderer>().material = Control.selectedBullet.GetMaterial();
            }
            else 
            { 
                bullets.GetComponent<MeshRenderer>().material = null;
                Debug.Log("DAfaq?");
            }
        }
        else 
        { 
            bullets.GetComponent<MeshRenderer>().material = null;
            Debug.Log("Dafaq2?");
        }
    }

    private Quaternion GetCurrentAngleAxis()
    {
        return Quaternion.AngleAxis(transform.rotation.eulerAngles.y, Vector3.up);
    }

    private void DisableImmunity()
    {
        immune = false;
        weapon.SetActive(true);
        CancelInvoke("WeaponFlicker");
    }

    private void WeaponFlicker()
    {
        weapon.SetActive(!weapon.activeSelf);
    }

    public void DecreaseLife()
    {
        if(!immune)
        {
            lives -= 1;
            immune = true;
            InvokeRepeating("WeaponFlicker", 0, flicker_interval);
            Invoke("DisableImmunity", IMMUNITY_DURATION);
            if (lives <= 0)
                gameLogic.GameOver();
        }
    }
}
