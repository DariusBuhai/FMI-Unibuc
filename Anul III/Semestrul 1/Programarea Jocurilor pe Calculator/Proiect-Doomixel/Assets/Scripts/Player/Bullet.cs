using UnityEngine;

public class Bullet
{
    public int id;
    public float bullet_Speed;
    public float timeToShoot_Bullet;
    public int ammo;
    public Material material_Bullet;
    public Sprite imag;

    public Bullet(int id, float bulletSpeed, float timeToShootBullet, Material materialBullet, Sprite imag, int ammo)
    {
        this.id = id;
        this.bullet_Speed = bulletSpeed;
        this.timeToShoot_Bullet = timeToShootBullet;
        this.material_Bullet = materialBullet;
        this.imag = imag;
        this.ammo = ammo;
    }

    public Sprite GetImage()
    {
        return this.imag;

    }


    public int GetAmmo()
    {
        return this.ammo;

    }

    public Material GetMaterial()
    {
        return this.material_Bullet;

    }

}