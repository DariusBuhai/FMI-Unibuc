using UnityEngine;
using UnityEngine.AI;
using UnityEngine.UI;
using System;

public class Killable : MonoBehaviour
{

    public int lives, maxLives;
    private GameObject human;
    private bool _isDead = false;
    public bool IsDead() => _isDead;
    public Slider slider;

    void Start()
    {
        if((int)Settings.GetDifficulty()==1)
            lives = 4;
        else if((int)Settings.GetDifficulty()==2)
            lives = 6;
        else if((int)Settings.GetDifficulty()==3)
            lives = 8;
        maxLives = lives;
        SetMaxHealth(lives);
        human = gameObject;
    }

    public void SetMaxHealth(int health)
    {
        slider.maxValue = health;
        slider.value = health;
    }

    public void SetHealth(int health)
    {
        slider.value = health;
    }

    void OnTriggerEnter(Collider other)
    {
        if (_isDead)
            return;

        if (other.gameObject.CompareTag("Bullets"))
        {
            int aux = 0;

            Int32.TryParse(other.gameObject.GetComponent<MeshRenderer>().material.name.Split()[0].Split('_')[1], out aux);
          
            Decrease(aux, name.Split('(')[0]);
            if(aux!=1)
                Destroy(other.gameObject);
        }

    }

    private void Update()
    {
        transform.position = new Vector3(transform.position.x, 1.0f, transform.position.z);
    }

    void Decrease(int bulletIndex, string enemyName)
    {
        if(bulletIndex == 0 )
            DecreaseLife(1);

        else if (bulletIndex == 1 && enemyName.Equals("Monster_1"))
             DecreaseLife((int)((maxLives*3)/4));

        else if (bulletIndex == 2 && enemyName.Equals("Human_1"))
            DecreaseLife(maxLives);

        else if (bulletIndex == 3)
            DecreaseLife(2);

        else if (bulletIndex == 4)
        {
            gameObject.GetComponent<NavMeshAgent>().speed = 2f;
        }

        else if (bulletIndex == 5 && enemyName.Equals("Human_3"))
            DecreaseLife(maxLives);

        else if (bulletIndex == 6 && enemyName.Equals("Turret_1"))
                    DecreaseLife((int)(maxLives/2));

        else
            DecreaseLife(1);
    }


    void DecreaseLife(int number)
    {
        lives = lives - number;
        if (lives < 0)
            SetHealth(0);
        else 
            SetHealth(lives);
        
        if (lives <= 0)
            Kill();
    }

    public void Kill()
    {
        SoundManagerScript.PlaySound("death");
        Control.Reward(UnityEngine.Random.Range(1, 7));
        _isDead = true;
        ScoreScript.AddScore(10);

    }
}