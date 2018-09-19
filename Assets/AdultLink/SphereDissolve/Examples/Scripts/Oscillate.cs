using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public class Oscillate : MonoBehaviour {

	// Use this for initialization
	public float amplitude;
	public float freq;
	public Vector3 direction;
	private Vector3 finalTranslation;
	
	// Update is called once per frame
	void Update () {
		finalTranslation = direction * amplitude * Mathf.Sin(Time.time*freq) * Time.deltaTime;
		transform.Translate(finalTranslation.x,finalTranslation.y,finalTranslation.z, Space.World);
	}
}
}
