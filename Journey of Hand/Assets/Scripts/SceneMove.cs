using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SceneMove : MonoBehaviour
{
    public bool ZtrueXfales = true ;
    public float movingSpeed;
    private float initialSpeed ;
    public Slider slider ;
    float defultSpeed = 0;
    // Start is called before the first frame update
    void Start()
    {
         defultSpeed = movingSpeed;
         if(slider!=null)
        {slider.onValueChanged.AddListener(SliderValueChanged);}
    }
    
    // Update is called once per frame
    void Update()
    {
        if(ZtrueXfales)
        { transform.position = new Vector3( 0 , 0,initialSpeed);}
        else
        { transform.position = new Vector3(initialSpeed, 0 , 0);}
   
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



