using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public class FollowTarget : MonoBehaviour {

	// Use this for initialization
	public Transform target;
	public Vector3 offset;
	
	// Update is called once per frame
	void Update () {
		transform.position = target.position + offset;
	}
}
}
