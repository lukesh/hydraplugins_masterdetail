package com.hydraframework.plugins.masterDetail.controller {
	import com.hydraframework.plugins.masterDetail.data.interfaces.IMasterDelegate;
	import com.hydraframework.plugins.masterDetail.MasterDetailPlugin;
	import com.hydraframework.plugins.masterDetail.model.MasterDetailProxy;
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;

	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class SelectCommand extends SimpleCommand implements IResponder {
		public function get delegate():IMasterDelegate {
			var plugin:MasterDetailPlugin = MasterDetailPlugin(this.facade.retrievePlugin(MasterDetailPlugin.NAME));
			var retval:IMasterDelegate = this.facade.retrieveDelegate(plugin.masterDelegateInterface) as IMasterDelegate;
			retval.responder = this;
			return retval;
		}

		public function get proxy():MasterDetailProxy {
			return MasterDetailProxy(this.facade.retrieveProxy(MasterDetailProxy.NAME));
		}

		public function SelectCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			var d:IMasterDelegate;
			if (notification.isRequest()) {
				d = this.delegate;
				d.retrieveObject(notification.body[d.keyField]);
			}
		}

		public function result(data:Object):void {
			if (data is ResultEvent) {
				data = ResultEvent(data).result;
				if(data != null) {
					this.proxy.selectedItem = data;
				}
			}
		}

		public function fault(data:Object):void {
		}
	}
}