using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public class Despawn : MonoBehaviour {

	
	// Update is called once per frame

	private void OnTriggerExit(Collider other) {
			if (other.gameObject.CompareTag("Despawnable")) {
				Object.Destroy(other.gameObject);
			}
	}
}
}
