using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class HandBoardCounter : MonoBehaviour
{
    private int score = 0;
    public Text YourScore;
    public TextMeshProUGUI endScore;

    
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "BoardArea")
        {
            Destroy(other.gameObject);
             score += 1;
            YourScore.text = score.ToString();
            endScore.text = score.ToString();
           
        }
    }
}
