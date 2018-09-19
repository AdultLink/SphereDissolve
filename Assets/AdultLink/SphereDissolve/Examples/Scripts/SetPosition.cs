using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public class SetPosition : MonoBehaviour {

	public Material mat;
	// Update is called once per frame
	void Update () {
		mat.SetVector("_Position", transform.position);
	}
}
}
