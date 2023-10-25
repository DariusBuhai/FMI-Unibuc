using UnityEngine;

public class Door : MonoBehaviour
{
    public bool open = false;
    public float openSpeed = 2.0f;
    public float roomTileScale = 1.0f;
    public float panelSize = 1.0f;

    private bool _opening = false;
    private float _initialY = 0.0f;
    
    public void Open()
    {
        open = true;
        _opening = true;
    }

    void Start()
    {
    }

    void Update()
    {
        if (_opening)
        {
            if (transform.localPosition.y < _initialY + roomTileScale * panelSize * 2.0f) 
                transform.localPosition = transform.localPosition + new Vector3(0.0f, Time.deltaTime * openSpeed, 0.0f);
        }
        else
        {
            _initialY = transform.localPosition.y;
        }
    }
}
