using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;

public class Homepage_UI : MonoBehaviour
{
    public TextMeshProUGUI com;
    private float comnumber;
    [SerializeField]
    StartComDataScriptObject startComDataScriptObject;
    // Start is called before the first frame update
    void Start()
    {
        comnumber = startComDataScriptObject.ComPort_Record;
        com.text = comnumber+" ";
    }

    public void loadScene2_1()
    {
        SceneManager.LoadSceneAsync("2.1_test_level");
    }
    public void loadScene2_2()
    {
        SceneManager.LoadSceneAsync("2.2_test_level");
    }
    public void loadScene2_1_1()
    {
        SceneManager.LoadSceneAsync("2.1.1_demo_short_level");
    }
    public void loadScene2_2_1()
    {
        SceneManager.LoadSceneAsync("2.2.1_demo_short_level");
    }
    public void exitGame()
    {
       // UnityEditor.EditorApplication.isPlaying = false;
        Application.Quit();
    }
}

