using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public class Spawner : MonoBehaviour {

	// Use this for initialization
	public Transform ballPrefab;
	public Vector3 spawnDirection;
	public float pushStrength;
	public float spawnPeriod = 1f;
	private float lastTimeSpawned = 0f;
	public Color[] colors;
	public Transform ballParent;
	
	void FixedUpdate () {
		if (Time.time - lastTimeSpawned > spawnPeriod) {
			spawn();
			lastTimeSpawned = Time.time;
		}
	}

	private void spawn() {
		Transform ball = Instantiate(ballPrefab, transform.position, Quaternion.identity, ballParent);
		Material mat = ball.GetComponent<Renderer>().material;
		Color color = colors[Random.Range(0,colors.Length)];
		mat.SetColor("_Color", color);
		mat.SetColor("_EmissionColor", color);
		ball.GetComponent<Rigidbody>().AddForce((spawnDirection+Vector3.one*Random.Range(-0.1f,0.1f))*pushStrength*Random.Range(0.8f,1.3f), ForceMode.Impulse);
	}
}
}
