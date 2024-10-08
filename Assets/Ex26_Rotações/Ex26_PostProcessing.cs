using UnityEngine;

public class Ex26_PostProcessing : MonoBehaviour
{
    public Material _material;

    [SerializeField] private Vector2 _center;

    // acontece antes do OnRenderImage
    private void FixedUpdate()
    {
        // se clicar com o bot�o esquerdo do mouse
        if (Input.GetButton("Fire1"))
        {
            Debug.Log("Clicou no bot�o esquerdo do mouse.");
            Vector3 mousePosition = Input.mousePosition;

            _center = mousePosition;
            _material.SetVector("_Center", _center);
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, _material);
    }
}