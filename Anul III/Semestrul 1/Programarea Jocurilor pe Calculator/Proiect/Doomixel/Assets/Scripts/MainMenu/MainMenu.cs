using System;
using UnityEngine;

public class MainMenu : MonoBehaviour
{
    public static float MUSIC_VOLUME_MULTIPLIER = 0.2f;
    public static DataManager.SavedData savedData;
    public static AudioSource musicSource;
    void Start()
    {
        savedData = DataManager.Load();
        
        musicSource = GetComponent<AudioSource>();
        musicSource.volume = MUSIC_VOLUME_MULTIPLIER * Settings.GetSoundVolume();
    }
}