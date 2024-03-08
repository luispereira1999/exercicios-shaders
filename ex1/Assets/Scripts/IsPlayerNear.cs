using UnityEngine;

public class IsPlayerNear : MonoBehaviour
{
    public Transform player;

    void Update()
    {
        if (Vector3.Distance(player.position, transform.position) > 0.5)
        {
            this.GetComponent<Renderer>().material.SetInt("_moving", 1);
        }
        else
        {
            this.GetComponent<Renderer>().material.SetInt("_moving", 0);
        }
    }
}