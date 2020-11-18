using UnityEngine;

public class FollowCamera : MonoBehaviour
{
    Transform CameraTransform;
    Transform t;

    void Start()
    {
        CameraTransform = Camera.main.transform;
        t = this.transform;
    }

    void Update()
    {
        t.position = new Vector3(CameraTransform.position.x, t.position.y, CameraTransform.position.z);
        t.rotation = new Quaternion(t.rotation.x, CameraTransform.rotation.y, t.rotation.z, CameraTransform.rotation.w);
        t.Rotate(new Vector3(0, 1, 0), -45);
    }
}
