using System.Collections.Generic;
using System.IO;
using UnityEngine;

public static class DataManager
{
    private static string _path;
    private static string _fileName="SavedData.json";
    private static bool _initiated = false;
    public class SavedData
    {
        public List<int> scoresHistory = new List<int>();
        public int score = 0;
    }

    public static void Init()
    {
        _path = Application.dataPath + "/Saved/";
        if (!Directory.Exists(_path))
            Directory.CreateDirectory(_path);
        _initiated = true;
    }

    public static void Save(SavedData data)
    {
        if(!_initiated)
            Init();
        string json = JsonUtility.ToJson(data,true);
        File.WriteAllText(_path+_fileName,json);
    }

    public static SavedData Load()
    {
        if(!_initiated)
            Init();
        try
        {
            string jsonString = File.ReadAllText(_path + "SavedData.json");
            return JsonUtility.FromJson<SavedData>(jsonString);
        }
        catch (FileNotFoundException)
        {
            // Debug.Log(e.ToString()); ;))))
        }
        return new SavedData();
    }
}
