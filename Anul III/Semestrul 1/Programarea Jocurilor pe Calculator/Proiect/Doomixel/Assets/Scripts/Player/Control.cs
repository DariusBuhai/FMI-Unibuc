using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class Control : MonoBehaviour
{
    private int x = 0;
    private const int NUM_OF_SLOTS = 6; //6-1

    private static List<Bullet> _bullets = new List<Bullet>();
    private static List<Bullet> _slots = new List<Bullet>();
    private static List<Transform> _slotsView = new List<Transform>();
    private GameObject inventory;
    public static Bullet selectedBullet;
    public static Transform selectedBorder;
    
    void Awake()
    {
        _bullets = new List<Bullet>();
        for (int i = 0; i < 7; i++)
        {
            Bullet slot1 = new Bullet(i, 25.0f, 0.1f, Resources.Load<Material>("Materials/Bullets/Bullets_" + i), Resources.Load<Sprite>("Bullets/Bullets_" + i), 0);
            _bullets.Add(slot1);
        }

        _slots = new List<Bullet>();
        for (int i = 0; i < NUM_OF_SLOTS; i++)
        {
            if (i > 0)
                _slots.Add(null);
            else
            {
                Bullet aux = _bullets[i];
                aux.ammo =20;
                _slots.Add(aux);
            }

        }


        if (inventory == null)
        {
            inventory = GameObject.Find("Inventory");
        }

        int j = 0;
        _slotsView = new List<Transform>();
        foreach (Transform x in inventory.transform)
        {
            _slotsView.Add(x);
            x.GetChild(0).GetComponent<Image>().color = new Color32(255, 255, 255, 255);
            if (_slots[j] != null)
            {
                x.GetChild(0).GetChild(0).GetComponent<Image>().sprite = _slots[j].GetImage();

                if(j==0) 
                    x.GetChild(0).GetChild(1).GetComponent<TextMeshProUGUI>().text = "\u221E";
                
                else
                    x.GetChild(0).GetChild(1).GetComponent<TextMeshProUGUI>().text = _slots[j].GetAmmo().ToString("");
                x.GetChild(0).GetChild(1).GetComponent<TextMeshProUGUI>().color = new Color32(185, 20, 238, 255);
            }
            else
            {

                x.GetChild(0).GetChild(0).GetComponent<Image>().sprite = default;
                x.GetChild(0).GetChild(0).GetComponent<Image>().color = new Color32(255, 255, 255, 0);
                x.GetChild(0).GetChild(1).GetComponent<TextMeshProUGUI>().text = "";
                x.GetChild(0).GetChild(1).GetComponent<TextMeshProUGUI>().color = new Color32(185, 20, 238, 255);

            }


            j++;
        }

        selectedBorder = _slotsView[0];
        selectedBullet = _slots[0];
        SelectBullet(0);
    }

    public static int AmmoNumber(int ammoID)
    {
        switch (ammoID)
        {
            case 1:
                return Random.Range(1, 3) * (int)Settings.GetDifficulty();

            case 2:
                return Random.Range(2, 4) * (int)Settings.GetDifficulty();

            case 3:
                return Random.Range(2, 5) * (int)Settings.GetDifficulty();

            case 4:
                return Random.Range(1, 4) * (int)Settings.GetDifficulty();

            case 5:
                return Random.Range(2, 5) * (int)Settings.GetDifficulty();
                
            case 6:
                return Random.Range(1, 4) * (int)Settings.GetDifficulty();
               
            default:
                return 5;
               
        } 

    }


    public static void Reward(int x)
    {

        int freespace = 7;


        Bullet aux = _bullets[x];

        bool isfull = true;
        bool gasit = false;
        for (int i = 0; i <= 5; i++)
        {
            if (_slots[i] != null)
            {
                if (_slots[i].id == aux.id)
                {
                    _slots[i].ammo += AmmoNumber(x);
                    SoundManagerScript.PlaySound("reward");
                    _slotsView[i].GetChild(0).GetChild(1).GetComponent<TextMeshProUGUI>().text = _slots[i].GetAmmo().ToString("");
                    gasit = true;
                    break;
                }
            }
            else if (_slots[i] == null && isfull == true)
            {
                isfull = false;
                freespace = i;

            }

        }

        if (isfull == false && gasit == false)
        {

            _slots[freespace] = aux;
            _slots[freespace].ammo = AmmoNumber(x);
            SoundManagerScript.PlaySound("reward");
            _slotsView[freespace].GetChild(0).GetChild(0).GetComponent<Image>().sprite = _slots[freespace].GetImage();
            _slotsView[freespace].GetChild(0).GetChild(1).GetComponent<TextMeshProUGUI>().text = _slots[freespace].GetAmmo().ToString("");
            _slotsView[freespace].GetChild(0).GetChild(0).GetComponent<Image>().color = new Color32(255, 255, 255, 255);
        }

    }


    public void SelectBullet(int number)
    {
        // bullets[priviousnumber]= selected_bullet 
        selectedBorder.GetChild(0).GetComponent<Image>().color = new Color32(255, 255, 255, 255);
        selectedBorder.GetChild(0).GetChild(1).GetComponent<TextMeshProUGUI>().color = new Color32(185, 20, 238, 255);
      

        _slotsView[number].GetChild(0).GetComponent<Image>().color = new Color32(185, 20, 238, 255);
        _slotsView[number].GetChild(0).GetChild(1).GetComponent<TextMeshProUGUI>().color = new Color32(255, 255, 255, 255);
        if (_slots[number] == null)
            selectedBullet = null;

        else
            selectedBullet = _slots[number];

        selectedBorder = _slotsView[number];

    }

    public void SetEmptySlot(int number)
    {
        selectedBorder.GetChild(0).GetChild(1).GetComponent<TextMeshProUGUI>().text = "";
        _slotsView[number].GetChild(0).GetChild(0).GetComponent<Image>().sprite = null;
        _slotsView[number].GetChild(0).GetChild(0).GetComponent<Image>().color = new Color32(255, 255, 255, 0);
        _slots[number] = null;
    }

    private KeyCode[] numericKeyCodes = {
        KeyCode.Alpha1,
        KeyCode.Alpha2,
        KeyCode.Alpha3,
        KeyCode.Alpha4,
        KeyCode.Alpha5,
        KeyCode.Alpha6,
    };

    void Update()
    {
        if (selectedBullet != null)
        {
            if (selectedBullet.ammo <= 0)
            {

                SetEmptySlot(x);
                SoundManagerScript.PlaySound("gunshot_empty");
                if (x == 5)
                {
                    SelectBullet(0);
                    x = 0;
                }
                else
                {
                    SelectBullet(x + 1);
                    x = x + 1;
                }
            }
        }

        if (!GameLogic.gamePaused)
        {
            if (Input.GetAxis("Mouse ScrollWheel") > 0f) // forward
            {
                x = Modulo((x + 1), NUM_OF_SLOTS);
                SelectBullet(x);
            }

            if (Input.GetAxis("Mouse ScrollWheel") < 0f) // forward
            {
                x = Modulo((x - 1), NUM_OF_SLOTS);
                SelectBullet(x);
            }

            for (int i = 0; i < NUM_OF_SLOTS; i++)
            {
                if (Input.GetKeyDown(numericKeyCodes[i]))
                {
                    x = i;
                    SelectBullet(x);
                }
            }
        }
    }

    private int Modulo(int a, int b)
    {
        return ((a % b) + b) % b;
    }
}
