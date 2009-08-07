/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.masterDetail.controller {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.masterDetail.MasterDetailPlugin;
	import com.hydraframework.plugins.masterDetail.data.interfaces.IMasterDelegate;
	import com.hydraframework.plugins.masterDetail.model.MasterDetailProxy;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class UpdateCommand extends SimpleCommand implements IResponder {
		public function get delegate():IMasterDelegate {
			var plugin:MasterDetailPlugin = MasterDetailPlugin(this.facade.retrievePlugin(MasterDetailPlugin.NAME));
			var retval:IMasterDelegate = this.facade.retrieveDelegate(plugin.masterDelegateInterface) as IMasterDelegate;
			retval.responder = this;
			return retval;
		}

		public function get proxy():MasterDetailProxy {
			return MasterDetailProxy(this.facade.retrieveProxy(MasterDetailProxy.NAME));
		}

		public function UpdateCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isRequest()) {
				this.delegate.updateObject(notification.body);
			}
		}

		public function result(data:Object):void {
			if (data is ResultEvent) {
				this.facade.sendNotification(new Notification(MasterDetailPlugin.UPDATE, data, Phase.RESPONSE));
				this.facade.sendNotification(new Notification(MasterDetailPlugin.RETRIEVE_LIST));
			} else {
				throw new Error("MasterDetail Plugin Error: UpdateCommand received a result that was not a ResultEvent. Check your delegate's updateObject() method to ensure that it sends a ResultEvent to responder.result().");
			}
		}

		public function fault(data:Object):void {
			this.facade.sendNotification(new Notification(MasterDetailPlugin.UPDATE, data, Phase.CANCEL));
		}
	}
}