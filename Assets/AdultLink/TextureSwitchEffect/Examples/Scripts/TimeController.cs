using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeController : MonoBehaviour {

	// Use this for initialization
	private float timeScaleStep = 0.1f;
	private float timeScale;
	void Start () {
		timeScale = Time.timeScale;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown(KeyCode.Alpha1)) {
			timeScale -= timeScaleStep;
			timeScale = Mathf.Clamp(timeScale, 0f, 1f);
			Time.timeScale = timeScale;
		}

		if (Input.GetKeyDown(KeyCode.Alpha2)) {
			timeScale += timeScaleStep;
			timeScale = Mathf.Clamp(timeScale, 0f, 1f);
			Time.timeScale = timeScale;
		}
	}
}
