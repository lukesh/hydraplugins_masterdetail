/*
   HydraFramework - Copyright (c) 2009 andCulture, Inc. Some rights reserved.
   Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package com.hydraframework.plugins.masterDetail {
	import com.hydraframework.plugins.masterDetail.data.interfaces.IMasterDelegate;
	import com.hydraframework.plugins.masterDetail.controller.*;
	import com.hydraframework.plugins.masterDetail.data.delegates.MockMasterDelegate;
	import com.hydraframework.plugins.masterDetail.model.MasterDetailProxy;
	import com.hydraframework.core.mvc.patterns.plugin.Plugin;

	public class MasterDetailPlugin extends Plugin {
		public static const NAME:String = "MasterDetailPlugin";

		public static const INSTANTIATE:String = "adeptiv.plugins.masterDetail.instantiate";
		public static const RETRIEVE_LIST:String = "adeptiv.plugins.masterDetail.retrieveList";
		public static const SELECT:String = "adeptiv.plugins.masterDetail.select";
		public static const CREATE:String = "adeptiv.plugins.masterDetail.create";
		public static const UPDATE:String = "adeptiv.plugins.masterDetail.update";
		public static const DELETE:String = "adeptiv.plugins.masterDetail.delete";

		public function MasterDetailPlugin(masterDelegateInterface:Class, masterDelegate:Class = null) {
			super(NAME);
			this.masterDelegateInterface = masterDelegateInterface;
			if (masterDelegate) {
				this.masterDelegate = masterDelegate;
			}
		}

		/**
		 * Default Master delegate interface
		 */
		private var _masterDelegateInterface:Class = IMasterDelegate;

		public function set masterDelegateInterface(value:Class):void {
			if (value != _masterDelegateInterface) {
				_masterDelegateInterface = value;
			}
		}

		public function get masterDelegateInterface():Class {
			return _masterDelegateInterface;
		}

		/**
		 * Default Master delegate
		 */
		private var _masterDelegate:Class = MockMasterDelegate;

		public function set masterDelegate(value:Class):void {
			if (value != _masterDelegate) {
				if (this.facade) {
					this.facade.removeDelegate(_masterDelegate);
					this.facade.registerDelegate(value);
				}
				_masterDelegate = value;
			}
		}

		public function get masterDelegate():Class {
			return _masterDelegate;
		}

		override public function preinitialize():void {
			super.preinitialize();
			/*
			   Delegates
			 */
			this.facade.registerDelegate(_masterDelegate);
			/*
			   Proxies
			 */
			this.facade.registerProxy(new MasterDetailProxy());
			/*
			   Commands
			 */
			this.facade.registerCommand(MasterDetailPlugin.INSTANTIATE, InstantiateCommand);
			this.facade.registerCommand(MasterDetailPlugin.RETRIEVE_LIST, RetrieveListCommand);
			this.facade.registerCommand(MasterDetailPlugin.SELECT, SelectCommand);
			this.facade.registerCommand(MasterDetailPlugin.CREATE, CreateCommand);
			this.facade.registerCommand(MasterDetailPlugin.UPDATE, UpdateCommand);
			this.facade.registerCommand(MasterDetailPlugin.DELETE, DeleteCommand);
		}
	}
}