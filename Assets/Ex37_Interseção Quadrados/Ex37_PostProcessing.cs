using UnityEngine;

public class Ex37_PostProcessing : MonoBehaviour
{
    public Material _material;

    private float scrollSpeed = 10f;
    private float rotation = 0f;
    private const float maxRotation = 360f;

    private void Start()
    {
        rotation = _material.GetFloat("_Rotation");
        _material.SetFloat("_Rotation", rotation);
    }

    // acontece antes do OnRenderImage
    private void Update()
    {
        // scroll com o mouse
        float scrollValue = Input.mouseScrollDelta.y;
        if (scrollValue != 0f)
        {
            // determinar a direção do scroll e ajustar a rotação
            float scrollDirection = Mathf.Sign(scrollValue);
            rotation += scrollDirection * scrollSpeed;
            rotation = Mathf.Clamp(rotation, 0f, maxRotation);

            _material.SetFloat("_Rotation", rotation);
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, _material);
    }
}