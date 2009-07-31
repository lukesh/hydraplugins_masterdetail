package com.hydraframework.plugins.masterDetail.controller {
	import com.hydraframework.plugins.masterDetail.data.interfaces.IMasterDelegate;
	import com.hydraframework.plugins.masterDetail.MasterDetailPlugin;
	import com.hydraframework.plugins.masterDetail.model.MasterDetailProxy;
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;

	import mx.rpc.IResponder;

	public class InstantiateCommand extends SimpleCommand implements IResponder {

		public function get delegate():IMasterDelegate {
			var plugin:MasterDetailPlugin = MasterDetailPlugin(this.facade.retrievePlugin(MasterDetailPlugin.NAME));
			var retval:IMasterDelegate = this.facade.retrieveDelegate(plugin.masterDelegateInterface) as IMasterDelegate;
			retval.responder = this;
			return retval;
		}

		public function get proxy():MasterDetailProxy {
			return MasterDetailProxy(this.facade.retrieveProxy(MasterDetailProxy.NAME));
		}

		public function InstantiateCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isRequest()) {
				this.proxy.selectedItem = this.delegate.recordFactory();
			}
		}

		public function result(data:Object):void {
		}

		public function fault(data:Object):void {
		}
	}
}