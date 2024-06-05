using UnityEngine;

public class Ex32_PostProcessing : MonoBehaviour
{
    public Material _material;

    [SerializeField] private Vector2 _center;

    // acontece antes do OnRenderImage
    private void FixedUpdate()
    {
        // se clicar com o botão esquerdo do mouse
        if (Input.GetButton("Fire1"))
        {
            Debug.Log("Clicou no botão esquerdo do mouse.");

            Vector3 mousePosition = Input.mousePosition;
            // usar isto se tiver a usar as uvs e não o vertex
            //mousePosition.x = mousePosition.x / Screen.width;
            //mousePosition.y = mousePosition.y / Screen.height;

            _center = mousePosition;
            _material.SetVector("_Center", _center);
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, _material);
    }
}