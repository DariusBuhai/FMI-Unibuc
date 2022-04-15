using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClosedDoor : MonoBehaviour
{
    public float panelSize = 10.0f;
    public float tileScale = 1.0f;
    public bool  closing = false;
    public bool  closed = false;

    public float closeSpeed = 20.0f;

    void Start()
    {       
    }

    void Update()
    {
        if (closing && !closed)
        {
            if (transform.localPosition.y <= panelSize * tileScale * 0.5f)
            {
                transform.localPosition = new Vector3(transform.localPosition.x, panelSize * tileScale * 0.5f, transform.localPosition.z);
                closed = true;
            }
            else
            {
                transform.localPosition = transform.localPosition - new Vector3(0.0f, Time.deltaTime * closeSpeed, 0.0f);
            }
        }
    }
}
