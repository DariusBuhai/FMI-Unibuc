using System;
using UnityEngine;
using UnityEngine.UI;

public class Settings : MonoBehaviour
{
    public Slider soundSlider;
    public Slider difficultySlider;

    public static float GetSoundVolume()
    {
        if(PlayerPrefs.HasKey("Volume"))
            return PlayerPrefs.GetFloat("Volume");
        return 1;
    }
    public static float GetDifficulty()
    {
        if(PlayerPrefs.HasKey("GameDifficulty"))
            return PlayerPrefs.GetFloat("GameDifficulty");
        return 1;
    }
    void Start()
    {
        soundSlider.value = GetSoundVolume();
        difficultySlider.value = GetDifficulty();
    }

    public void SaveDifficulty()
    {
        PlayerPrefs.SetFloat("GameDifficulty", difficultySlider.value);
        PlayerPrefs.Save();
    }

    public void SaveVolume(float value)
    {
        if (value == 1)
            return;
        PlayerPrefs.SetFloat("Volume", soundSlider.value);
        MainMenu.musicSource.volume = MainMenu.MUSIC_VOLUME_MULTIPLIER * GetSoundVolume();
        PlayerPrefs.Save();
    }
    
}