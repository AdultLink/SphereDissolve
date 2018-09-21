# SphereDissolve [![Follow](https://img.shields.io/github/followers/adultlink.svg?style=social&label=Follow)](https://github.com/adultlink) ![Size](https://img.shields.io/github/repo-size/adultlink/radialprogressbar.svg) [![License](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](http://adultlink.mit-license.org) [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/adultlink/5usd) 

![IntroImage](Media/Rocks.gif)

This shader works in a similar way to a typical dissolve shader, albeit with two big differences:

- It makes use of 3D noise instead of a texture, which means:
   - We don't need to care about UVs and seams.
   - The effect is consistent among different objects. They are all affected equally. Quality is also scale-independent.
   - It is a more computationally expensive method.

- The dissolve effect follows a spherical shape, meaning it can be controlled by setting the center and radius of a virtual sphere. This opens up a lot of possibilities.

The shader can be edited through [Amplify Shader Editor](http://amplify.pt/unity/amplify-shader-editor) and contributions to the project are always welcome!

---

Project developed using **Unity 2017.4.8f1**. Please use this version if you are planning on contributing. You can work on your own branch and send a pull request with your changes.

---

You can also just download a **unitypackage** from the [releases tab](https://github.com/AdultLink/SphereDissolve/releases) and easily import everything to your project. This will not download the _media_ folder.

_Disclaimer: The scripts controlling the behavior of the examples provided are not optimized in any way and should only be taken as quick & dirty examples._

# Table of contents
1. [Getting started](#getting-started)
2. [Parameters list](#parameters-list)
3. [Donate](#donate)
4. [License](#license)

# Getting started



<p align="center">
   <img src="Screenshots/BasicSetup.png">
</p>


# Parameters list

<details><summary>"Standard" version - Click to expand</summary><p>
 
```C#

//MAIN SETTINGS
_Position
_Radius
_Invert

//BORDER SETTINGS
_Bordercolor
_Borderradius
_Bordernoisescale
_Noisespeed

//TEXTURE SET1 SETTINGS
_Set1_albedo
_Set1_albedo_tint
_Set1_normal
_Set1_emission
_Set1_emission_tint
_Set1_metallic
_Set1_metallic_multiplier
_Set1_smoothness
_Set1_tiling
_Set1_offset

//TEXTURE SET2 SETTINGS
_Set2_albedo
_Set2_albedo_tint
_Set2_normal
_Set2_emission
_Set2_emission_tint
_Set2_metallic
_Set2_metallic_multiplier
_Set2_smoothness
_Set2_tiling
_Set2_offset

```

</p></details>

<details><summary>"Cutout" version - Click to expand</summary><p>

```C#

//MAIN SETTINGS
_Position
_Radius
_Invert

//BORDER SETTINGS
_Bordercolor
_Borderradius
_Bordernoisescale
_Noisespeed

//TEXTURE SETTINGS
_Albedo
_Albedo_tint
_Normal
_Emission
_Emission_tint
_Metallic
_Metallic_multiplier
_Smoothness
_Tiling
_Offset

```

</p></details>

# Donate [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/adultlink/5usd)

This piece of software is offered for free because I believe the gamedev community can benefit from it, and it should not be behind a paywall. I learned from the community, and now I am giving back.

If you would like to support me, donations are very much appreciated, since they help me create more software that I can offer for free.

Thank you very much :)

# License
MIT License

Copyright (c) 2018 Guillermo Angel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
