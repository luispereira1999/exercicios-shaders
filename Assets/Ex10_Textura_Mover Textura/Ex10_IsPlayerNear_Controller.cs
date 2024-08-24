using UnityEngine;

public class Ex10_IsPlayerNear_Controller : MonoBehaviour
{
    public Transform player;

    void Update()
    {
        if (Vector3.Distance(player.position, transform.position) < 10)
        {
            this.GetComponent<Renderer>().material.SetInt("_moving", 1);
        }
        else
        {
            this.GetComponent<Renderer>().material.SetInt("_moving", 0);
        }
    }
}