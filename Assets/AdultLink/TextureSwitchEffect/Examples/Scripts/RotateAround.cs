using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateAround : MonoBehaviour {
	public Transform pivotPoint;
	public float rotationSpeed;
	public Vector3 axis;
	// Update is called once per frame
	void Update () {
		transform.RotateAround(pivotPoint.transform.position, axis, rotationSpeed*Time.deltaTime);
	}
}
