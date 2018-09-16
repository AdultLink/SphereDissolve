using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateAround : MonoBehaviour {
	public Transform pivotPoint;
	public float rotationSpeed;
	// Update is called once per frame
	void FixedUpdate () {
		transform.RotateAround(pivotPoint.transform.position, Vector3.up, rotationSpeed);
	}
}
