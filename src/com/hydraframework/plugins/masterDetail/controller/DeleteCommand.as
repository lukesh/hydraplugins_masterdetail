/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
package com.hydraframework.plugins.masterDetail.controller {
	import com.hydraframework.plugins.masterDetail.data.interfaces.IMasterDelegate;
	import com.hydraframework.plugins.masterDetail.MasterDetailPlugin;
	import com.hydraframework.plugins.masterDetail.model.MasterDetailProxy;
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;

	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class DeleteCommand extends SimpleCommand implements IResponder {
		public function get delegate():IMasterDelegate {
			var plugin:MasterDetailPlugin = MasterDetailPlugin(this.facade.retrievePlugin(MasterDetailPlugin.NAME));
			var retval:IMasterDelegate = this.facade.retrieveDelegate(plugin.masterDelegateInterface) as IMasterDelegate;
			retval.responder = this;
			return retval;
		}

		public function get proxy():MasterDetailProxy {
			return MasterDetailProxy(this.facade.retrieveProxy(MasterDetailProxy.NAME));
		}

		public function DeleteCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isRequest()) {
				this.delegate.deleteObject(notification.body);
			}
		}

		public function result(data:Object):void {
			if (data is ResultEvent) {
				data = ResultEvent(data).result;
				if (data != null) {
					this.facade.sendNotification(new Notification(MasterDetailPlugin.DELETE, data, Phase.RESPONSE));
					this.facade.sendNotification(new Notification(MasterDetailPlugin.RETRIEVE_LIST));
				} else {
					this.facade.sendNotification(new Notification(MasterDetailPlugin.DELETE, data, Phase.CANCEL));
				}
			} else {
				throw new Error("MasterDetail Plugin Error: DeleteCommand received a result that was not a ResultEvent. Check your delegate's deleteObject() method to ensure that it sends a ResultEvent to responder.result().");
			}
		}

		public function fault(data:Object):void {
			this.facade.sendNotification(new Notification(MasterDetailPlugin.DELETE, data, Phase.CANCEL));
		}
	}
}