// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/SimpleFresnel"
{
	Properties
	{
		_Power("Power", Float) = 5
		_Scale("Scale", Float) = 1
		_Bias("Bias", Float) = 0
		_Color("Color", Color) = (0.75,0.8862069,1,1)
		_Opacity("Opacity", Range( 0 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _Color;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNDotV1 = dot( normalize( ase_worldNormal ), ase_worldViewDir );
			float fresnelNode1 = ( _Bias + _Scale * pow( 1.0 - fresnelNDotV1, _Power ) );
			o.Emission = ( _Color * fresnelNode1 ).rgb;
			o.Alpha = ( fresnelNode1 * _Opacity );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
657;92;955;759;818.6623;476.5039;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;4;-524.3824,121.3651;Float;False;Property;_Scale;Scale;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-528.3824,48.36514;Float;False;Property;_Bias;Bias;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-519.3824,199.3651;Float;False;Property;_Power;Power;0;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-289.3992,-8.8976;Float;False;Tangent;4;0;FLOAT3;0,0,1;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-322.5507,-207.0896;Float;False;Property;_Color;Color;3;0;Create;True;0;0;False;0;0.75,0.8862069,1,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-345.4621,264.4961;Float;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-84.14832,-108.7068;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-80.26235,61.69601;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;104.6,-195.2462;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AdultLink/SimpleFresnel;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;1;3;0
WireConnection;1;2;4;0
WireConnection;1;3;5;0
WireConnection;6;0;7;0
WireConnection;6;1;1;0
WireConnection;23;0;1;0
WireConnection;23;1;22;0
WireConnection;0;2;6;0
WireConnection;0;9;23;0
ASEEND*/
//CHKSM=2D902708091C25DEF351A32844B6788A0F367973