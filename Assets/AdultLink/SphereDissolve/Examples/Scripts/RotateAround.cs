using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public class RotateAround : MonoBehaviour {
	public Transform pivotPoint;
	public float rotationSpeed = -500f;
	public Vector3 axis;
	// Update is called once per frame
	private float initialSpeed;
	public float slowdownSpeed = 1f;
	private float initialSpeedSign;
	private float initialSpeedAbs;
	void Start()
	{
		initialSpeed = rotationSpeed;
		initialSpeedSign = Mathf.Sign(initialSpeed);
		initialSpeedAbs = Mathf.Abs(initialSpeed);
	}
	void Update () {
		transform.RotateAround(pivotPoint.transform.position, axis, rotationSpeed*Time.deltaTime);
	}
	private void FixedUpdate() {
		rotationSpeed -= initialSpeedSign * slowdownSpeed*Time.deltaTime;
		rotationSpeed = initialSpeedSign * Mathf.Max(initialSpeedAbs , Mathf.Abs(rotationSpeed));
	}
}
}