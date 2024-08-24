using UnityEngine;

public class Ex34_PostProcessing : MonoBehaviour
{
    public Material _material;

    private bool _isPoint1 = false;
    private bool _isPoint2 = false;
    private bool _isPoint3 = false;

    // acontece antes do OnRenderImage
    private void Update()
    {
        // clicar com o bot�o esquerdo do mouse
        if (Input.GetMouseButtonDown(0))
        {
            Vector3 mousePosition = Input.mousePosition;

            if (!_isPoint1)
            {
                _isPoint1 = true;
                _material.SetVector("_PointA", mousePosition);
            }
            else
            {
                _material.SetVector("_PointB", mousePosition);
                _material.SetInt("_IsLineSet", 1);
                _isPoint1 = false;
                _isPoint2 = true;
            }
        }

        // clicar com o bot�o direito do mouse
        if (Input.GetMouseButtonDown(1))
        {
            Vector3 mousePosition = Input.mousePosition;

            // se os 2 primeiros pontos n�o est�o definidos
            if (!_isPoint2)
            {
                return;
            }
            else if (!_isPoint3)
            {
                _isPoint3 = true;
                _material.SetVector("_PointC", mousePosition);
                _material.SetInt("_IsTriangleSet", 1);
            }
            else
            {
                _material.SetVector("_PointC", mousePosition);
            }
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, _material);
    }
}