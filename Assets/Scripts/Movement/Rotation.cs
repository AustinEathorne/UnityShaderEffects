using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotation : MonoBehaviour
{
    public bool IsRunning { get; set; }

    [SerializeField] private bool _playOnAwake = false;

    [SerializeField] private List<RotationInformation> _rotationInformationList;


    private void Awake()
    {
        IsRunning = false;

        if (_playOnAwake)
        {
            StartCoroutine(Run());
        }
    }

    public IEnumerator Run()
    {
        var x = transform.eulerAngles.x;
        var y = transform.eulerAngles.y;
        var z = transform.eulerAngles.z;

        IsRunning = true;
        while (IsRunning)
        {
            foreach (var info in _rotationInformationList)
            {
                switch (info.RotationAxis)
                {
                    case Axis.X:
                        x += Time.deltaTime * info.RotationSpeed;
                        break;
                    case Axis.Y:
                        y += Time.deltaTime * info.RotationSpeed;
                        break;
                    case Axis.Z:
                        z += Time.deltaTime * info.RotationSpeed;
                        break;
                }
            }

            transform.eulerAngles = new Vector3(x, y, z);

            yield return null;
        }

        yield return null;
    }

    public void Stop()
    {
        this.IsRunning = false;
    }

    public void SetRotation(Vector3 rotation)
    {
        transform.eulerAngles = rotation;
    }
}

[Serializable]
public class RotationInformation
{
    public Axis RotationAxis;
    public float RotationSpeed;
}

public enum Axis
{
    X = 0, Y, Z
}
