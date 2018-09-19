using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public class SkyboxController : MonoBehaviour {

	public Material mat;
	public float rotationSpeed = 2f;
	private float rotation;

	private void Start() {
		rotation = mat.GetFloat("_Rotation");
	}

	void FixedUpdate () {
		rotation += rotationSpeed*Time.fixedDeltaTime;
		if (rotation >= 360f) { rotation = 0f;}
		else if (rotation <= 0f) {rotation = 360f;}
		mat.SetFloat("_Rotation", rotation);
	}
}
}
