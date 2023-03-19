using UnityEngine;
using System.IO.Ports;

public class ArdityTest : MonoBehaviour
{
    SerialPort stream = new SerialPort("COM8", 9600); // 将串口连接到COM3端口，波特率为9600
    void Start()
    {
        stream.Open(); // 打开串口
    }
    void Update()
    {
        if (stream.IsOpen)
        {
            string value = stream.ReadLine(); // 读取串口数据
            Debug.Log(value); // 输出数据到控制台
        }
    }
    void OnApplicationQuit()
    {
        stream.Close(); // 关闭串口
    }
}
