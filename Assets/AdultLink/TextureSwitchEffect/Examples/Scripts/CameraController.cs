using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour {

	public Transform pivotPoint;	
	public float rotationAmplitude = 1f;
	private float angle = 0f;
	public float rotationSpeed = 2f;
	void FixedUpdate () {
		angle = rotationSpeed/100*Mathf.Sin(Time.time/rotationAmplitude);
		
		transform.RotateAround(pivotPoint.transform.position, Vector3.up, angle);
	}
}
