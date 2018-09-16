using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Oscillate : MonoBehaviour {

	// Use this for initialization
	public float amplitude;
	public float freq;
	public Vector3 direction;
	private Vector3 finalTranslation;
	
	// Update is called once per frame
	void FixedUpdate () {
		finalTranslation = new Vector3(direction.x*amplitude*Mathf.Sin(Time.time*freq),direction.y*amplitude*Mathf.Sin(Time.time*freq),direction.z*amplitude*Mathf.Sin(Time.time*freq));
		transform.Translate(finalTranslation.x,finalTranslation.y,finalTranslation.z, Space.World);
	}
}
