using UnityEngine;
using System.Collections;

namespace AdultLink {
public class PlayerController : MonoBehaviour {

    public float speed;

    private Rigidbody rb;
    private Vector3 initialPosition;

    void Start ()
    {
        initialPosition = transform.position;
        rb = GetComponent<Rigidbody>();
    }

    private void Update() {
        if (Input.GetKeyDown(KeyCode.R)) {
            resetPlayerPos();
        }
    }

    void FixedUpdate ()
    {
        float moveHorizontal = Input.GetAxis ("Horizontal");
        float moveVertical = Input.GetAxis ("Vertical");

        Vector3 movement = new Vector3 (moveHorizontal, 0.0f, moveVertical);

        rb.AddForce (movement * speed);
    }

    private void resetPlayerPos() {
        transform.position = initialPosition;
        rb.velocity = Vector3.zero;
    }
}
}