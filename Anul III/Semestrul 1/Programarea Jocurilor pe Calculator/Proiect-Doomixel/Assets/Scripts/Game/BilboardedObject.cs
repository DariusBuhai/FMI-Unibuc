using UnityEngine;

public class BilboardedObject : MonoBehaviour
{
    private GameObject _gameLogic;
    private GameObject _playerObject;

    void Start()
    {
        _gameLogic = GameObject.FindGameObjectWithTag("GameController");
        _playerObject = _gameLogic.GetComponent<GameLogic>().playerObject;
    }

    void Update()
    {
        transform.forward = -_playerObject.transform.forward;
    }
}
