using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class ScoreScript : MonoBehaviour
{
    private float realTimer = 0.0f;
    private PlayerController _playerController;
    public Text scoreText;
    public Text timerText;
    private float _displayScore;
    private float _transitionSpeed = 100;
    private static DataManager.SavedData savedData;
    private static int _score = 0;

    void Start()
    {
        _playerController = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerController>();
        savedData = DataManager.Load();
    }

    // Update is called once per frame
    void Update()
    {
        realTimer += Time.deltaTime;
        _displayScore = Mathf.MoveTowards(_displayScore, _score, _transitionSpeed * Time.deltaTime);
        UpdateScoreDisplay();
        UpdateTimeDisplay();
    }

    void UpdateScoreDisplay()
    {
        scoreText.text = string.Format("Score: {0:000000}", _displayScore);
    }

    void UpdateTimeDisplay()
    {
        string minutes = Math.Floor(realTimer / 60).ToString("00");
        string seconds = (realTimer % 60).ToString("00");
     
        timerText.text = string.Format("Time: {0}:{1}", minutes, seconds);
    }

    public static void AddScore(int points)
    {
        _score += points;
        savedData.score = _score;
        DataManager.Save(savedData);
    }

    public static void SaveScore()
    {
        if (_score == 0)
            return;
        savedData.scoresHistory.Add(_score);
        DataManager.Save(savedData);
        _score = 0;
    }
}
