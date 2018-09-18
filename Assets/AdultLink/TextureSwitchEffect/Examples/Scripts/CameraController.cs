using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour {

	public Transform pivotPoint;
	public Transform cam;
	public float rotationAmplitude = 1f;
	private float angle = 0f;
	public float rotationSpeed = 2f;
	private bool oscillate = true;

	private void Update() {
		if (oscillate) {
			angle = rotationSpeed*Mathf.Sin(Time.time/rotationAmplitude)*Time.deltaTime;
			cam.transform.RotateAround(pivotPoint.transform.position, Vector3.up, angle);
		}
	}
}
