using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalBall : MonoBehaviour {

	public Material mat;
	// Update is called once per frame
	void FixedUpdate () {
		mat.SetVector("_Position", transform.position);
	}
}
