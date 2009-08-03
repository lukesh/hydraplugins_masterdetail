/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.masterDetail.data.delegates {
	import com.hydraframework.plugins.masterDetail.data.interfaces.IMasterDelegate;
	
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.ResultEvent;
	use namespace mx_internal;

	public class MockMasterDelegate implements IMasterDelegate {
		public function MockMasterDelegate() {
		}

		private var _responder:IResponder;

		public function set responder(value:IResponder):void {
			_responder = value;
		}

		public function get responder():IResponder {
			return _responder;
		}

		public function get keyField():String {
			return "ID";
		}

		private function _recordFactory():Object {
			var obj:Object = {};
			return obj;
		}

		private function _mockRecordFactory():Object {
			var obj:Object = {};
			obj.label = "Item";
			obj.data = {};
			return obj;
		}

		private function _mockIDFactory():String {
			return String(Math.round(Math.random() * 100000))
		}

		public function get recordFactory():Function {
			return _recordFactory;
		}

		public function get mockRecordFactory():Function {
			return _mockRecordFactory;
		}
		
		public function get mockIDFactory():Function {
			return _mockIDFactory;
		}

		private var mock_list:ArrayCollection;

		public function get collection():ArrayCollection {
			if (!mock_list) {
				mock_list = new ArrayCollection();
				mock_list.addItem(mockRecordFactory());
				mock_list.addItem(mockRecordFactory());
				mock_list.addItem(mockRecordFactory());
				mock_list.addItem(mockRecordFactory());
				mock_list.addItem(mockRecordFactory());
			}
			return mock_list;
		}

		public function retrieveList():void {
			var asyncToken:AsyncToken = new AsyncToken(null);
			var collection:ArrayCollection = new ArrayCollection(this.collection.toArray());

			asyncToken.addResponder(new Responder(function(data:Object):void {
										responder.result(data);
									}, function(info:Object):void {
										responder.fault(info);
									}));

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, collection, asyncToken, null));
				}, 200);
		}

		public function createObject(object:Object):void {
			object[keyField] = mockIDFactory();

			collection.addItem(object);

			var asyncToken:AsyncToken = new AsyncToken(null);

			asyncToken.addResponder(new Responder(function(data:Object):void {
										responder.result(data);
									}, function(info:Object):void {
										responder.fault(info);
									}));

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, object, asyncToken, null));
				}, 200);
		}

		public function retrieveObject(key:Object):void {
			var object:Object;

			var cursor:IViewCursor = collection.createCursor();
			while (cursor.current) {
				if (cursor.current[keyField] == key) {
					object = cursor.current;
					break;
				}
				cursor.moveNext();
			}

			var asyncToken:AsyncToken = new AsyncToken(null);

			asyncToken.addResponder(new Responder(function(data:Object):void {
										responder.result(data);
									}, function(info:Object):void {
										responder.fault(info);
									}));

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, object, asyncToken, null));
				}, 200);
		}

		public function updateObject(object:Object):void {
			var cursor:IViewCursor = collection.createCursor();
			while (cursor.current) {
				if (cursor.current[keyField] == object[keyField]) {
					var i:int = collection.getItemIndex(cursor.current);
					collection.removeItemAt(i);
					collection.addItemAt(object, i);
					break;
				}
				cursor.moveNext();
			}

			var asyncToken:AsyncToken = new AsyncToken(null);

			asyncToken.addResponder(new Responder(function(data:Object):void {
										responder.result(data);
									}, function(info:Object):void {
										responder.fault(info);
									}));

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, object, asyncToken, null));
				}, 200);
		}

		public function deleteObject(object:Object):void {
			var cursor:IViewCursor = collection.createCursor();
			while (cursor.current) {
				if (cursor.current[keyField] == object[keyField]) {
					var i:int = collection.getItemIndex(cursor.current);
					collection.removeItemAt(i);
					break;
				}
				cursor.moveNext();
			}
			var asyncToken:AsyncToken = new AsyncToken(null);

			asyncToken.addResponder(new Responder(function(data:Object):void {
										responder.result(data);
									}, function(info:Object):void {
										responder.fault(info);
									}));

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, { success:true }, asyncToken, null));
				}, 200);
		}

	}
}