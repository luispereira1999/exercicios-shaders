using UnityEngine;

public class CastleController : MonoBehaviour
{
    private float _currentBuildPercent = 0f;
    private AudioSource _audioSource;

    private void Start()
    {
        _audioSource = GetComponent<AudioSource>();
    }

    private void Update()
    {
        if (_currentBuildPercent >= 10f)
        {
            Debug.Log("Castelo construido!");
            return;
        }

        if (Input.GetKeyDown(KeyCode.B))
        {
            // constroi castelo
            _currentBuildPercent += 0.5f;
            this.gameObject.GetComponent<Renderer>().material.SetFloat("_BuildPercent", _currentBuildPercent);

            // reproduzir som
            _audioSource.Play();
        }
    }
}