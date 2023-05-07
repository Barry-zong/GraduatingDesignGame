using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class CommanSceneStart : MonoBehaviour
{
    [SerializeField]
    StartComDataScriptObject startComDataScriptObject;
    public GameObject startUI1;
    public GameObject otherStartObject1;
    public GameObject otherStartObject2;
    public GameObject mirroOtherStartObject2;

    

    // Update is called once per frame
    void Update()
    {
         if(startComDataScriptObject.FingertotalNumber>450)
        {
           OpenGame();
        }
    }

    public void OpenGame()
    {
        startUI1.SetActive(false);
        otherStartObject1.SetActive(true);
        if(otherStartObject2 != null )
        {otherStartObject2.SetActive(true);}
        if(mirroOtherStartObject2 != null)
        {
            mirroOtherStartObject2.SetActive(false);
        }
    }
}
