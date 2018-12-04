using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlickeringLight : MonoBehaviour
{
    public bool IsRunning { get; set; }

    [SerializeField] private Light _light;

    [SerializeField] private bool _playOnAwake = false;

    [SerializeField] [Range(0.1f, 5.0f)] private float _minIntensity;
    [SerializeField] [Range(0.1f, 5.0f)] private float _maxIntensity;

    [SerializeField] [Range(0f, 1f)] private float _minIntensityTolerance;
    [SerializeField] [Range(0, 1f)] private float _maxIntensityTolerance;

    [SerializeField] [Range(0.1f, 1f)] private float _intensityIncreaseSpeed;
    [SerializeField] [Range(0.1f, 1f)] private float _intensityDecreaseSpeed;

    private void Awake()
    {
        IsRunning = false;

        if (_playOnAwake)
        {
            StartCoroutine(Run());
        }
    }

    private IEnumerator Run()
    {
        IsRunning = true;

        var isIntensityIncreasing = true;

        while (IsRunning)
        {
            var targetIntensity = isIntensityIncreasing ? 
                Random.Range(_maxIntensity - _maxIntensityTolerance, _maxIntensity) : 
                Random.Range(_minIntensity, _minIntensity + _minIntensityTolerance);

            yield return StartCoroutine(LerpIntensity(targetIntensity, isIntensityIncreasing));

            isIntensityIncreasing = !isIntensityIncreasing;

            yield return null;
        }

        yield return null;
    }

    private IEnumerator LerpIntensity(float targetIntensity, bool isIncreasing)
    {
        var diff = Mathf.Abs(_light.intensity - targetIntensity);
        var time = diff / (isIncreasing ? _intensityIncreaseSpeed : _intensityDecreaseSpeed);

        var startIntensity = _light.intensity;

        var elapsedTime = 0.0f;
        while (elapsedTime < time)
        {
            elapsedTime += Time.deltaTime;

            _light.intensity = Mathf.Lerp(startIntensity, targetIntensity, elapsedTime / time);

            yield return null;
        }

        yield return null;
    }
}
