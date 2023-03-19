using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;


public class ComPortAutoTest : MonoBehaviour
{
    [SerializeField]
    StartComDataScriptObject startComDataScriptObject;

    public TextMeshProUGUI ComText;
    public int Com_port;
    public float com_allnumber;
    public GameObject serialcomport;
    public GameObject addcomvalueButton;
    public GameObject succecedIcon;

    // Start is called before the first frame update
    void Start()
    {

        Com_port = startComDataScriptObject.ComPort_Record;
        ComText.text = Com_port + " ";
    }
    void Update()
    {
        com_allnumber = startComDataScriptObject.FingertotalNumber;
        if (com_allnumber!=0)
        {
            addcomvalueButton.gameObject.SetActive(false);
            succecedIcon.gameObject.SetActive(true);
            Debug.Log("COM conected ");
            startComDataScriptObject.ComPort_Record = Com_port;//同步数据
            SceneManager.LoadSceneAsync("1_Menu");
        }
        
    }
    private void FixedUpdate()
    {
        serialcomport.GetComponent<SerialController>().enabled = true;
    }

    public void restThePortnumber()
    {
        Com_port = 0;
        ComText.text = Com_port + " ";
        Debug.Log(Com_port);
        startComDataScriptObject.ComPort_Record = Com_port;//同步数据
    }
    public void combuttonGetDown()
    {

        serialcomport.GetComponent<SerialController>().enabled = false;
        Com_port = startComDataScriptObject.ComPort_Record;
       

        
            if (com_allnumber == 0)
            //如果为0代表端口连接错误
            //com数加一，最大20
            //重启serial的开关
            {
                

                    if (Com_port < 150)
                    {
                        Com_port += 1;
                    }
                    else
                    {
                        Com_port = 0;
                    }
                   
                    startComDataScriptObject.ComPort_Record = Com_port;//同步数据
                    
                
            }
           
        ComText.text = Com_port + " ";
        Debug.Log(Com_port);

    }
   
    
}
