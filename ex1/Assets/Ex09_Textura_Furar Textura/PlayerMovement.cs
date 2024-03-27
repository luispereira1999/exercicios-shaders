using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    private Rigidbody rb;

    [Space(10)]
    [Header("Fisicas")]
    public float moveForce = 5f;
    public float jumpForce = 10f;

    [Space(10)]
    [Header("Line Render")]
    public LineRenderer laserLineRenderer;
    public float laserWidth = 2f;
    public float laserMaxLength = 100f;

    void Start()
    {
        rb = GetComponent<Rigidbody>();

        Vector3[] initLaserPositions = new Vector3[2] { Vector3.zero, Vector3.zero };
        laserLineRenderer.SetPositions(initLaserPositions);
        laserLineRenderer.startWidth = laserWidth;
    }

    void Update()
    {
        movement();
    }

    public void movement()
    {
        float h = Input.GetAxisRaw("Horizontal");
        float v = Input.GetAxisRaw("Vertical");

        rb.AddForce(Vector3.forward * (v * moveForce));
        rb.AddForce(Vector3.right * (h * moveForce));

        if (Input.GetKeyDown(KeyCode.Space))
        {
            rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
        }

        // raycast
        //if (Input.GetKey(KeyCode.LeftControl))
        //{
            ShootLaserFromTargetPosition(transform.position, Vector3.forward, laserMaxLength);
            laserLineRenderer.enabled = true;
        //}
        //else
        //{
            //laserLineRenderer.enabled = false;
        //}
    }

    void ShootLaserFromTargetPosition(Vector3 targetPosition, Vector3 direction, float length)
    {
        Ray ray = new Ray(targetPosition, direction);
        RaycastHit raycastHit;
        Vector3 endPosition = targetPosition + (length * direction);

        if (Physics.Raycast(ray, out raycastHit, length))
        {
            endPosition = raycastHit.point;
            laserLineRenderer.startColor = Color.green;
            laserLineRenderer.endColor = Color.green;

            print(raycastHit.collider.gameObject.name);
            if (raycastHit.collider.gameObject.name == "PointShoot")
            {
                this.GetComponent<Renderer>().material.SetInt("_moving", 0);
                raycastHit.collider.gameObject.GetComponent<Renderer>().material.SetVector("_ponto_teste", raycastHit.point);
            }
        }
        else
        {
            laserLineRenderer.startColor = Color.red;
            laserLineRenderer.endColor = Color.red;
        }

        laserLineRenderer.SetPosition(0, targetPosition);
        laserLineRenderer.SetPosition(1, endPosition);
    }
}