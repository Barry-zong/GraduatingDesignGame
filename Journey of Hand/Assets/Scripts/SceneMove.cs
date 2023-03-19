using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SceneMove : MonoBehaviour
{
    public float movingSpeed;
    private float initialSpeed ;
    // Start is called before the first frame update
    void Start()
    {
        
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



}



