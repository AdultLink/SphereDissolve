using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OscillateY : MonoBehaviour {

	// Use this for initialization
	public float amplitude;
	public float freq;
	
	// Update is called once per frame
	void FixedUpdate () {
		transform.Translate(0,amplitude*Mathf.Sin(Time.time*freq),0);
	}
}
