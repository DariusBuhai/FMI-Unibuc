using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundManagerScript : MonoBehaviour
{
    private const float MUSIC_VOLUME_MULTIPLIER = 0.2f;

    public static AudioClip gunshotSound, deathSoundEffect, gunshotEmptySound, rewardSoundEffect;
    static AudioSource audioSrc;
    public GameObject playerObject;
    private static AudioSource _musicSource;

    void Start()
    {
        gunshotSound = Resources.Load<AudioClip>("gunshot");
        gunshotEmptySound = Resources.Load<AudioClip>("gunshot_empty");
        deathSoundEffect = Resources.Load<AudioClip>("deathsound");
        rewardSoundEffect = Resources.Load<AudioClip>("reward");

        audioSrc = GetComponent<AudioSource>();

        _musicSource = playerObject.GetComponent<AudioSource>();
        _musicSource.volume = MUSIC_VOLUME_MULTIPLIER * Settings.GetSoundVolume();
    }

    public static void PauseMusic()
    {
        _musicSource.Pause();
    }

    public static void PlayMusic()
    {
        _musicSource.Play();
    }

    public static void PlaySound(string clip)
    {
        audioSrc.volume = Settings.GetSoundVolume();
        if (clip == "gunshot")
            audioSrc.PlayOneShot(gunshotSound);

        else if (clip == "gunshot_empty")
            audioSrc.PlayOneShot(gunshotEmptySound);

        else if (clip == "death")
            audioSrc.PlayOneShot(deathSoundEffect);

        else if (clip == "reward")
            audioSrc.PlayOneShot(rewardSoundEffect);

    }

}
