using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    public bool IsRunning { get; set; }

    [SerializeField] private bool _playOnAwake = false;

    [SerializeField] private List<Transform> _targetTransforms;
    private int _currentTarget;

    [SerializeField] private float _speed;

    // Quick Hack
    [SerializeField] private MeshRenderer _windowRenderer;


    public void Awake()
    {
        _currentTarget = 0;
        IsRunning = false;

        if (_playOnAwake)
        {
            StartCoroutine(Run());
        }
    }

    public IEnumerator Run()
    {
        IsRunning = true;

        while (IsRunning)
        {
            var startPosition = transform.position;
            var elapsedTime = 0.0f;
            var travelTime = Vector3.Distance(startPosition, _targetTransforms[_currentTarget].position) /
                               _speed;

            while (elapsedTime < travelTime)
            {
                elapsedTime += Time.deltaTime;

                transform.position = Vector3.Lerp(startPosition, _targetTransforms[_currentTarget].position,
                    elapsedTime / travelTime);

                yield return null;
            }

            _currentTarget = _currentTarget + 1 >= _targetTransforms.Count ?
                0 : _currentTarget + 1;

            _windowRenderer.sharedMaterial.SetFloat("_ScaleUV",
                _windowRenderer.sharedMaterial.GetFloat("_ScaleUV") == 1.0f ? 200.0f : 1.0f);

            yield return null;
        }

        yield return null;
    }
}
