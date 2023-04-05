using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SceneMove : MonoBehaviour
{
    public float movingSpeed;
    private float initialSpeed ;
    public Slider slider ;
    float defultSpeed = 0;
    // Start is called before the first frame update
    void Start()
    {
         defultSpeed = movingSpeed;
        slider.onValueChanged.AddListener(SliderValueChanged);
    }
    
    // Update is called once per frame
    void Update()
    {

        transform.position = new Vector3( 0 , 0,initialSpeed);
   
    }
    private void FixedUpdate()
    {
        initialSpeed = initialSpeed + movingSpeed;
    }

    void SliderValueChanged(float newValue)
    {
        movingSpeed = defultSpeed;
        movingSpeed += newValue/50;
    }

}



