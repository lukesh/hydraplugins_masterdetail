/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.masterDetail.data.interfaces {
	import com.hydraframework.core.registries.delegate.interfaces.IDelegate
	import mx.collections.ArrayCollection;

	public interface IMasterDelegate extends IDelegate {
		function get keyField():String;
		function get collection():ArrayCollection;
		function get recordFactory():Function;
		function get mockRecordFactory():Function;
		function get mockIDFactory():Function;
		function retrieveList():void;
		function createObject(object:Object):void;
		function retrieveObject(key:Object):void;
		function updateObject(object:Object):void;
		function deleteObject(object:Object):void;
	}
}