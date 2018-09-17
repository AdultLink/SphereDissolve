// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/TextureSwitchEffect"
{
	Properties
	{
		[NoScaleOffset]_Set1_albedo("Set1_albedo", 2D) = "white" {}
		[NoScaleOffset]_Set1_metallic("Set1_metallic", 2D) = "black" {}
		[NoScaleOffset][Normal]_Set1_normal("Set1_normal", 2D) = "bump" {}
		[NoScaleOffset]_Set1_emission("Set1_emission", 2D) = "black" {}
		[NoScaleOffset]_Set2_albedo("Set2_albedo", 2D) = "white" {}
		_Position("_Position", Vector) = (0,2.5,0,0)
		[NoScaleOffset][Normal]_Set2_normal("Set2_normal", 2D) = "bump" {}
		[NoScaleOffset]_Set2_emission("Set2_emission", 2D) = "black" {}
		[NoScaleOffset]_Set2_metallic("Set2_metallic", 2D) = "black" {}
		_Falloffvalue("Falloff value", Float) = 0.08
		_Radius("Radius", Float) = 2.16
		_Bordernoisescale("Border noise scale", Range( 0 , 20)) = 0
		_Borderradius("Border radius", Range( 0 , 2)) = 0
		[HDR]_Bordercolor("Border color", Color) = (0.8602941,0.2087478,0.2087478,0)
		_Noisespeed("Noise speed", Vector) = (0,0,0,0)
		[HDR]_Set1_emissionColor("Set1_emissionColor", Color) = (1,1,1,1)
		[HDR]_Set2_emissionColor("Set2_emissionColor", Color) = (1,1,1,1)
		_Set2_tiling("Set2_tiling", Vector) = (1,1,0,0)
		_Set2_offset("Set2_offset", Vector) = (0,0,0,0)
		_Set1_tiling("Set1_tiling", Vector) = (1,1,0,0)
		_Set1_offset("Set1_offset", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Set1_normal;
		uniform float2 _Set1_tiling;
		uniform float2 _Set1_offset;
		uniform float3 _Position;
		uniform float _Radius;
		uniform float _Bordernoisescale;
		uniform float3 _Noisespeed;
		uniform float _Falloffvalue;
		uniform sampler2D _Set2_normal;
		uniform float2 _Set2_tiling;
		uniform float2 _Set2_offset;
		uniform sampler2D _Set1_albedo;
		uniform sampler2D _Set2_albedo;
		uniform float4 _Set1_emissionColor;
		uniform sampler2D _Set1_emission;
		uniform sampler2D _Set2_emission;
		uniform float4 _Set2_emissionColor;
		uniform float4 _Bordercolor;
		uniform float _Borderradius;
		uniform sampler2D _Set1_metallic;
		uniform sampler2D _Set2_metallic;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord90 = i.uv_texcoord * _Set1_tiling + _Set1_offset;
			float3 ase_worldPos = i.worldPos;
			float temp_output_15_0 = distance( _Position , ase_worldPos );
			float simplePerlin3D26 = snoise( ( _Bordernoisescale * ( ase_worldPos + ( _Noisespeed * _Time.y ) ) ) );
			float temp_output_39_0 = ( _Radius + simplePerlin3D26 );
			float temp_output_14_0 = ( 1.0 - saturate( ( temp_output_15_0 / temp_output_39_0 ) ) );
			float temp_output_5_0 = step( temp_output_14_0 , _Falloffvalue );
			float Set1Mask51 = temp_output_5_0;
			float Set2Mask52 = step( _Falloffvalue , temp_output_14_0 );
			float2 uv_TexCoord96 = i.uv_texcoord * _Set2_tiling + _Set2_offset;
			o.Normal = ( ( UnpackNormal( tex2D( _Set1_normal, uv_TexCoord90 ) ) * Set1Mask51 ) + ( Set2Mask52 * UnpackNormal( tex2D( _Set2_normal, uv_TexCoord96 ) ) ) );
			o.Albedo = ( ( tex2D( _Set1_albedo, uv_TexCoord90 ) * Set1Mask51 ) + ( Set2Mask52 * tex2D( _Set2_albedo, uv_TexCoord96 ) ) ).rgb;
			float Border49 = ( temp_output_5_0 - step( ( 1.0 - saturate( ( temp_output_15_0 / ( _Borderradius + temp_output_39_0 ) ) ) ) , _Falloffvalue ) );
			o.Emission = ( ( _Set1_emissionColor * tex2D( _Set1_emission, uv_TexCoord90 ) * Set1Mask51 ) + ( Set2Mask52 * tex2D( _Set2_emission, uv_TexCoord96 ) * _Set2_emissionColor ) + ( _Bordercolor * Border49 ) ).rgb;
			o.Metallic = ( ( tex2D( _Set1_metallic, uv_TexCoord90 ) * Set1Mask51 ) + ( Set2Mask52 * tex2D( _Set2_metallic, uv_TexCoord96 ) ) ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
461;92;1140;598;4287.607;-243.6162;1;True;False
Node;AmplifyShaderEditor.Vector3Node;41;-4563.146,1328.272;Float;False;Property;_Noisespeed;Noise speed;14;0;Create;True;0;0;False;0;0,0,0;0,0.2,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;42;-4555.896,1487.593;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-4357.582,1355.791;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-4300.112,1181.774;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-4046.644,1258.913;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-4166.796,1080.221;Float;False;Property;_Bordernoisescale;Border noise scale;11;0;Create;True;0;0;False;0;0;1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-3900.322,1236.272;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-3710.652,1102.839;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3676.98,957.0943;Float;False;Property;_Radius;Radius;10;0;Create;True;0;0;False;0;2.16;12.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-3468.51,1015.98;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;10;-3868.821,588.7518;Float;False;Property;_Position;_Position;5;0;Create;True;0;0;False;0;0,2.5,0;0,2.5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;19;-3321.475,808.6704;Float;False;Property;_Borderradius;Border radius;12;0;Create;True;0;0;False;0;0;0.35;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-3870.092,774.1802;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-3028.343,820.5614;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;15;-3607.74,794.8361;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;12;-3160.858,1007.251;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;-3262.71,574.4978;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-3003.411,1006.094;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;32;-3101.878,563.1851;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-2799.739,997.1792;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2831.109,700.0889;Float;False;Property;_Falloffvalue;Falloff value;9;0;Create;True;0;0;False;0;0.08;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-2901.59,564.426;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;94;-868.1752,703.8401;Float;False;Property;_Set2_tiling;Set2_tiling;17;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;92;-881.1916,271.6074;Float;False;Property;_Set1_offset;Set1_offset;20;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;95;-869.4753,840.3397;Float;False;Property;_Set2_offset;Set2_offset;18;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;5;-2404.314,741.9278;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;23;-2404.487,505.8439;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;91;-879.8915,135.1081;Float;False;Property;_Set1_tiling;Set1_tiling;19;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-2144.864,482.5906;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;96;-674.4749,735.0396;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;90;-686.1912,166.3075;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;4;-2396.287,976.7197;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;1038.733,-1053.574;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;1046.335,-449.0117;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;87;849.5775,4.511616;Float;False;Property;_Set1_emissionColor;Set1_emissionColor;15;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;78;1194.084,264.8302;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;1196.056,359.9723;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;62;914.4825,1370.277;Float;True;Property;_Set1_metallic;Set1_metallic;1;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;34;839.6127,949.6295;Float;False;Property;_Bordercolor;Border color;13;1;[HDR];Create;True;0;0;False;0;0.8602941,0.2087478,0.2087478,0;0,0.881138,2.323001,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;50;858.331,1131.06;Float;False;49;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-2001.957,477.4751;Float;False;Border;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-2171.427,759.529;Float;False;Set1Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-2188.358,974.4181;Float;False;Set2Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;832.1533,185.4846;Float;True;Property;_Set1_emission;Set1_emission;3;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;938.4197,-876.8811;Float;True;Property;_Set2_albedo;Set2_albedo;4;1;[NoScaleOffset];Create;True;0;0;False;0;None;019d98742919c3248be0a995d4730f22;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;57;946.0211,-272.3187;Float;True;Property;_Set2_normal;Set2_normal;6;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;81;840.6989,431.5989;Float;True;Property;_Set2_emission;Set2_emission;7;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;63;919.2047,1748.927;Float;True;Property;_Set2_metallic;Set2_metallic;8;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;65;1019.518,1572.234;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;88;868.4716,640.1307;Float;False;Property;_Set2_emissionColor;Set2_emissionColor;16;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;933.6979,-1255.531;Float;True;Property;_Set1_albedo;Set1_albedo;0;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;54;1030.826,-958.4321;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;61;941.2991,-650.9692;Float;True;Property;_Set1_normal;Set1_normal;2;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;58;1038.428,-353.8697;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;1011.611,1667.376;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;1107.894,1032.203;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;1280.522,-289.9138;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;1413.384,414.0038;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;1253.706,1731.333;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;1272.921,-894.4762;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;1275.955,-515.6668;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;1405.668,167.779;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;1249.139,1505.579;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;1268.354,-1120.229;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;1470.218,-1080.079;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;1461.784,-416.7224;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;1434.969,1604.524;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;1704.648,391.9015;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2236.143,464.4567;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AdultLink/TextureSwitchEffect;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;89;0;41;0
WireConnection;89;1;42;0
WireConnection;40;0;27;0
WireConnection;40;1;89;0
WireConnection;28;0;29;0
WireConnection;28;1;40;0
WireConnection;26;0;28;0
WireConnection;39;0;13;0
WireConnection;39;1;26;0
WireConnection;18;0;19;0
WireConnection;18;1;39;0
WireConnection;15;0;10;0
WireConnection;15;1;16;0
WireConnection;12;0;15;0
WireConnection;12;1;39;0
WireConnection;31;0;15;0
WireConnection;31;1;18;0
WireConnection;11;0;12;0
WireConnection;32;0;31;0
WireConnection;14;0;11;0
WireConnection;33;0;32;0
WireConnection;5;0;14;0
WireConnection;5;1;3;0
WireConnection;23;0;33;0
WireConnection;23;1;3;0
WireConnection;24;0;5;0
WireConnection;24;1;23;0
WireConnection;96;0;94;0
WireConnection;96;1;95;0
WireConnection;90;0;91;0
WireConnection;90;1;92;0
WireConnection;4;0;3;0
WireConnection;4;1;14;0
WireConnection;62;1;90;0
WireConnection;49;0;24;0
WireConnection;51;0;5;0
WireConnection;52;0;4;0
WireConnection;80;1;90;0
WireConnection;2;1;96;0
WireConnection;57;1;96;0
WireConnection;81;1;96;0
WireConnection;63;1;96;0
WireConnection;1;1;90;0
WireConnection;61;1;90;0
WireConnection;35;0;34;0
WireConnection;35;1;50;0
WireConnection;60;0;58;0
WireConnection;60;1;57;0
WireConnection;82;0;79;0
WireConnection;82;1;81;0
WireConnection;82;2;88;0
WireConnection;67;0;64;0
WireConnection;67;1;63;0
WireConnection;7;0;54;0
WireConnection;7;1;2;0
WireConnection;56;0;61;0
WireConnection;56;1;59;0
WireConnection;83;0;87;0
WireConnection;83;1;80;0
WireConnection;83;2;78;0
WireConnection;66;0;62;0
WireConnection;66;1;65;0
WireConnection;8;0;1;0
WireConnection;8;1;53;0
WireConnection;9;0;8;0
WireConnection;9;1;7;0
WireConnection;55;0;56;0
WireConnection;55;1;60;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;84;0;83;0
WireConnection;84;1;82;0
WireConnection;84;2;35;0
WireConnection;0;0;9;0
WireConnection;0;1;55;0
WireConnection;0;2;84;0
WireConnection;0;3;68;0
ASEEND*/
//CHKSM=7B28B866BC6D942DF7AA0F4C8AD4C9D835BE455D