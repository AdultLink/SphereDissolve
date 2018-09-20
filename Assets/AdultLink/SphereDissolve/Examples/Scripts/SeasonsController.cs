using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public enum SeasonStatus {
	winter,
	spring,
}
public class SeasonsController : MonoBehaviour {

	// Use this for initialization
	public ParticleSystem snowPS;
	public ParticleSystem[] riverPS;
	public Transform center;
	public Material[] mats;
	private Material[] mats_initial;
	private SeasonStatus seasonStatus = SeasonStatus.spring;
	public Color winterBorderColor;
	public Color springBorderColor;
	public float transitionTime = 1f;
	public float initialRadius;
	public float targetRadius;
	private bool inTransition = false;
	private float transitionStartTime = 0f;
	private float transitionAmount;
	private float radius;
	private Material centerMat;
	public RotateAround rodRotator;

	void Start () {
		centerMat = center.GetComponent<Renderer>().material;
		mats_initial = new Material[mats.Length];
		radius = initialRadius;
		transitionAmount = (targetRadius - initialRadius) * Time.deltaTime / transitionTime;
		setPosition(center);
		setRadius(initialRadius);
		copyInitialMats();
	}
	
	// Update is called once per frame


	private void Update() {
		transitionAmount = (targetRadius - initialRadius) * Time.deltaTime / transitionTime;


		if (Input.GetKeyDown(KeyCode.Space) && !inTransition) {
			switch (seasonStatus) {
				case SeasonStatus.winter:
					seasonStatus = SeasonStatus.spring;
					switchToSpring();
					break;
				case SeasonStatus.spring:
					seasonStatus = SeasonStatus.winter;
					switchToWinter();
					break;
				default:
					Debug.Log("Transition defaulted");
					break;
			}
			rodRotator.rotationSpeed *= 3f;
		}

		if (inTransition) {
			if (Time.time - transitionStartTime < transitionTime) {
				radius += transitionAmount;
				radius = Mathf.Clamp(radius, initialRadius, targetRadius);
				setRadius(radius);
				centerMat.SetFloat("_Opacity",(1-((radius-initialRadius)/(targetRadius-initialRadius)))/2f);
			}
			else {
				inTransition = false;
				radius = initialRadius;
				setRadius(radius);
				toggleInvert();
				if (seasonStatus == SeasonStatus.winter) snowPS.Play();
			}
		}
	}

	private void switchToWinter() {
		setColors(winterBorderColor);
		inTransition = true;
		transitionStartTime = Time.time;
	}

	private void switchToSpring() {
		setColors(springBorderColor);
		inTransition = true;
		transitionStartTime = Time.time;
		snowPS.Stop();
	}

	private void setColors(Color _color) {
		for (int i = 0; i < mats.Length; i++) {
			mats[i].SetColor("_Bordercolor", _color);
		}
		centerMat.SetColor("_Color", _color);
	}

	private void setPosition(Transform _position) {
		for (int i = 0; i < mats.Length; i++) {
			mats[i].SetVector("_Position", _position.position);
		}
	}

	private void setRadius(float _radius) {
		for (int i = 0; i < mats.Length; i++) {
			mats[i].SetFloat("_Radius", _radius);
		}
		center.localScale = Vector3.one*_radius/2f;
	}
	private void copyInitialMats() {
		for (int i = 0; i < mats.Length; i++) {
			mats_initial[i] = new Material(mats[i]);
		}
	}

	private void restoreMats() {
		for (int i = 0; i < mats_initial.Length; i++) {
			mats[i].CopyPropertiesFromMaterial(mats_initial[i]);
		}
	}

	private void OnApplicationQuit() {
		restoreMats();
	}

	private void startRiverPS() {
		for (int i = 0; i < riverPS.Length; i++) {
			riverPS[i].Play();
		}
	}

	private void stopRiverPS() {
		for (int i = 0; i < riverPS.Length; i++) {
			riverPS[i].Stop();
		}
	}

	private void toggleInvert() {
		for (int i = 0; i < mats.Length; i++) {
			mats[i].SetFloat("_Invert", 1f - mats[i].GetFloat("_Invert"));
		}
	}
}
}