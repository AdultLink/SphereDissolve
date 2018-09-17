using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum SeasonStatus {
	winter,
	spring,
}
public class SeasonsController : MonoBehaviour {

	// Use this for initialization
	public ParticleSystem snowPS;
	public Transform center;
	public Material[] mats;
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

	void Start () {
		radius = initialRadius;
		transitionAmount = (targetRadius - initialRadius) * Time.fixedDeltaTime / transitionTime;
		setPosition(center);
		setRadius(initialRadius);
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		if (inTransition) {
			if (Time.time - transitionStartTime < transitionTime) {
				radius += transitionAmount;
				radius = Mathf.Clamp(radius, initialRadius, targetRadius);
				setRadius(radius);
			}
			else {
				inTransition = false;
			}
		}
	}

	private void Update() {
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
					Debug.Log("Defaulted");
					break;
			}

		}
	}

	private void switchToWinter() {
		setupMatForWinter();
		inTransition = true;
		transitionStartTime = Time.time;
		snowPS.Play();
	}

	private void switchToSpring() {
		setupMatForSpring();
		inTransition = true;
		transitionStartTime = Time.time;
		snowPS.Stop();
	}

	private void setupMatForWinter() {
		setBorderColor(winterBorderColor);
	}

	private void setupMatForSpring() {
		setBorderColor(springBorderColor);
	}

	private void setBorderColor(Color color) {
		for (int i = 0; i < mats.Length; i++) {
			mats[i].SetColor("_Bordercolor", color);
		}
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
}
