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