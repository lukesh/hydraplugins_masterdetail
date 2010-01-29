/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.masterDetail.data.interfaces {
	import com.hydraframework.core.registries.delegate.interfaces.IDelegate
	import mx.collections.ArrayCollection;

	public interface IMasterDelegate extends IDelegate {
		function get keyField():String;
		function get recordFactory():Function;
		function retrieveList():void;
		function createObject(object:Object):void;
		function retrieveObject(key:Object):void;
		function updateObject(object:Object):void;
		function deleteObject(object:Object):void;
	}
}