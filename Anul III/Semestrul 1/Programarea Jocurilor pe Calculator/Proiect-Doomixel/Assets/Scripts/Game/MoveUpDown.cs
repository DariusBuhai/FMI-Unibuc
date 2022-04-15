using System;
using UnityEngine;

public class MoveUpDown : MonoBehaviour
{
    private bool up;

    void OnColliderEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            int x = 0;

            Int32.TryParse(this.transform.GetComponent<MeshRenderer>().material.name.Split()[0].Split('_')[1], out x);

            Control.Reward(x);
            Destroy(gameObject);

        }

    }


    void Update()
    {
        if (this.transform.localPosition.y >= 1.3)
            up = false;

        if (up) this.transform.Translate(Vector3.up * Time.deltaTime * 2);
        else
        {
            this.transform.Translate(Vector3.down * Time.deltaTime * 2);
        }

        if (this.transform.localPosition.y <= 0.5)
        {
            up = true;
        }

    }
}