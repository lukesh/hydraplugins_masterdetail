/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the MIT License (http://www.opensource.org/licenses/mit-license.php)
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
				} else {
					this.facade.sendNotification(new Notification(MasterDetailPlugin.SELECT, data, Phase.CANCEL));
				}
			} else {
				throw new Error("MasterDetail Plugin Error: SelectCommand received a result that was not a ResultEvent. Check your delegate's retrieveObject() method to ensure that it sends a ResultEvent to responder.result().");
			}
		}

		public function fault(data:Object):void {
			this.facade.sendNotification(new Notification(MasterDetailPlugin.SELECT, data, Phase.CANCEL));
		}
	}
}