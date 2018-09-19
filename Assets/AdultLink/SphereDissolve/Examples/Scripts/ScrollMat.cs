using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public class ScrollMat : MonoBehaviour {

	public Material mat;
	public string offsetPropertyName;
	public Vector4 scrollSpeed;
	private Vector4 offset;
	void Start () {
		offset = mat.GetVector(offsetPropertyName);
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		offset += scrollSpeed/1000f;
		mat.SetVector(offsetPropertyName, offset);
	}
}
}
