using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MonsterFrames : MonoBehaviour
{
    private Vector3 _lastPosition;
    private GameObject _playerObject;
    private MeshRenderer _meshRenderer;

    [Serializable]
    public struct MonsterFrame
    {
        public Material material;
        public Vector3 direction;
        public bool isFront;
    }

    public MonsterFrame[] frames;

    void Start()
    {
        _lastPosition = transform.position;
        _playerObject = GameObject.FindGameObjectWithTag("Player");
        _meshRenderer = GetComponent<MeshRenderer>();
    }

    void Update()
    {
        Vector3 deltaPosition = transform.position - _lastPosition;

        if (deltaPosition.magnitude < 0.0001f)
            return;

        if (frames.Length == 0)
            return;

        Vector3 moveDir = deltaPosition.normalized;

        Vector3 dirInView = Quaternion.Inverse(transform.rotation) * moveDir;

        MonsterFrame chosenFrame = frames[0];

        foreach (var frame in frames)
        {
            float prevDot = Vector3.Dot(chosenFrame.direction, dirInView);
            float currentDot = Vector3.Dot(frame.direction, dirInView);
            if (currentDot > prevDot)
                chosenFrame = frame;
        }
        
        _meshRenderer.material = chosenFrame.material;

        _lastPosition = transform.position;
    }
}
