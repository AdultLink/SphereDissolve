using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public class TogglePS : MonoBehaviour {

	void OnTriggerEnter(Collider other)
	{
		if (other.gameObject.CompareTag("InteractablePS")) {
			ParticleSystem ps = other.GetComponent<ParticleSystem>();
			if (ps.isEmitting) {
				ps.Stop();
			}
			else {
				ps.Play();
			}
		}
		
	}
}
}
