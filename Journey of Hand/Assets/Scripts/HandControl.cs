using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO.Ports;//Ardrity?


public class HandControl : MonoBehaviour
{
    public float figurAddVelocity = 60;
    //速度修正
    private float fingerDa, fingerShi, fingerZhon, fingerWu, fingerXiao = 0f;
    //五个手指弯曲度输入值
    
    
    //private float  bendValueMax=100;
    //private float  bendValueMin=0;
    //根据手部运动幅度，钳制数值范围(用于后续对接arduino，将输入数值映射在这两个区间内）
    public Transform tFingerDa2;
    public Transform tFingerShi2;
    public Transform tFingerZhon2;
    public Transform tFingerWu2;
    public Transform tFingerXiao2;
    //获取模拟ik物体坐标
    //public Transform TestRotate;

    MessageManager messageManager;

    public float adjustValue = 3;
    //用于给输入数值设定取整区间

    public Rigidbody FlyQiuRib ;
    //吹球球
    public Transform QiuPenpen;
    public float flyForce = 10;
    private bool goFly = false;
    private bool goBreak = true;
    public float fingerflyLimit = 200;

    void Start()
    {   
        messageManager=GetComponent<MessageManager>();
    
    }

    void Update()
    { 
        FuZhi(); 
        QiuFly();
    }

    private void FixedUpdate()
    { FingerAct();  }//运行手指骨骼变换命令

    void FuZhi ()
    {
         float qd    = messageManager.Degree_Thumb;
         float wd = qd / adjustValue;
         float ed = Mathf.Round(wd);
         float rd = ed * adjustValue;
         if(rd < 0||rd>100)
        {
            if(rd > 100)
            {
                rd = 100;
               
            }
            if (rd < 0)
            {
                rd = 0;
            }
        }
        
 
        fingerDa = rd ;

          float qs   = messageManager.Degree_Index ;
        float ws = qs / adjustValue;
        float es = Mathf.Round(ws);
        float rs = es * adjustValue;
        if (rs < 0 || rs > 100)
        {
            if (rs > 100)
            {
                rs = 100;

            }
            if (rs < 0)
            {
                rs = 0;
            }
        }


        fingerShi = rs ;

         float qz    = messageManager.Degree_Middle ;
        float wz = qz / adjustValue;
        float ez = Mathf.Round(wz);
        float rz = ez * adjustValue;
        if (rz < 0 || rz > 100)
        {
            if (rz > 100)
            {
                rz = 100;

            }
            if (rz < 0)
            {
                rz = 0;
            }
        }


        fingerZhon = rz ;

          float qw   = messageManager.Degree_Ring ;

        float ww = qw / adjustValue;
        float ew = Mathf.Round(ww);
        float rw = ew * adjustValue;
        if (rw < 0 || rw > 100)
        {
            if (rw > 100)
            {
                rw = 100;

            }
            if (rw < 0)
            {
                rw = 0;
            }
        }

        fingerWu = rw ;

          float qx    = messageManager.Degree_Pinky ;

        float wx = qx / adjustValue;
        float ex = Mathf.Round(wx);
        float rx = ex * adjustValue;
        if (rx < 0 || rx > 100)
        {
            if (rx > 100)
            {
                rx = 100;

            }
            if (rx < 0)
            {
                rx = 0;
            }
        }

        fingerXiao = rx ;
           
       
    }

    void FingerAct()
    {
        FingerDaBend();
        FingerShiBend();
        FingerZhonBend();
        FingerWuBend();
        FingerXiaoBend();
    }//代码实现五个指头的骨骼移动

    void FingerDaBend()
    {
        //存在问题，启动unity问题坐标即归零
        tFingerDa2.transform.localRotation = Quaternion.Euler( fingerDa,0, 0f);
        
    }

    void FingerShiBend()
    {
        tFingerShi2.transform.localRotation = Quaternion.Euler(fingerShi , 0, 0f);
        //tFingerShi2.transform.localEulerAngles = new Vector3(transform.localEulerAngles.x+fingerShi, -1.811f, 15.367f);
      
    }

    void FingerZhonBend()
    {
        tFingerZhon2.transform.localRotation = Quaternion.Euler(fingerZhon, 0, 0f);
    }

    void FingerWuBend()
    {
        tFingerWu2.transform.localRotation = Quaternion.Euler(fingerWu, 0, 0f);
    }

    void FingerXiaoBend()
    {
        tFingerXiao2.transform.localRotation = Quaternion.Euler(fingerXiao, 0, 0f);
    }

    void QiuFly ()
    {
        if (FlyQiuRib != null)
        {

            if (goBreak)
            {
                if (fingerWu + fingerShi + fingerDa + fingerZhon + fingerXiao > fingerflyLimit)
                {
                    goFly = true;
                    goBreak = false;
                }
            }
            if (goFly)
            {
                FlyQiuRib.velocity = new Vector3(0, flyForce, 0f);
                goFly = false;
            }
            if (!goBreak)
            {
                if (fingerWu + fingerShi + fingerDa + fingerZhon + fingerXiao < 100F)
                {
                    goBreak = true;
                }
            }
            float qiuscale;
            float aFall, bFall, cAll;
            aFall = 20f;
            bFall = 100f;
            cAll = (fingerWu + fingerShi + fingerDa + fingerZhon + fingerXiao)/5;    
            qiuscale = 1-(cAll-aFall)/(bFall-aFall) *0.4f;
            if(qiuscale > 1)
            {
                qiuscale = 1;
            }
            if(qiuscale < 0.4f)
            {
                qiuscale = 0.4f;
            }
          QiuPenpen.transform.localScale = new Vector3(qiuscale, qiuscale, qiuscale);

        }
    }

}
