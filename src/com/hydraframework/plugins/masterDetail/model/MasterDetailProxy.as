package com.hydraframework.plugins.masterDetail.model {
	import com.hydraframework.plugins.masterDetail.MasterDetailPlugin;
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.patterns.proxy.Proxy;
	
	import mx.collections.ArrayCollection;

	public class MasterDetailProxy extends Proxy {
		public static const NAME:String = "MasterDetailProxy";

		public function MasterDetailProxy() {
			super(NAME);
		}

		private var _collection:ArrayCollection;

		public function set collection(value:ArrayCollection):void {
			if (value != _collection) {
				_collection = value;
				this.sendNotification(new Notification(MasterDetailPlugin.RETRIEVE_LIST, _collection, Phase.RESPONSE));
			}
		}

		public function get collection():ArrayCollection {
			return _collection;
		}

		private var _selectedItem:Object;

		public function set selectedItem(value:Object):void {
			if (value != _selectedItem) {
				_selectedItem = value;
				this.sendNotification(new Notification(MasterDetailPlugin.SELECT, _selectedItem, Phase.RESPONSE));
			}
		}

		public function get selectedItem():Object {
			return _selectedItem;
		}
	}
}