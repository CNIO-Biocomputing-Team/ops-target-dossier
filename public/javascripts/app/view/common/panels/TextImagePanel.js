
/**
 * A panel splited in text side and image side (if image is defined...) by using a hbox layout.
 * Specifically built to be used as information dispaly when a graph node is clicked.
 * In such a case, the component in used as content area for a window component
 */
Ext.define ('TDGUI.view.common.panels.TextImagePanel', {
	extend: 'Ext.panel.Panel',
  alias: 'widget.tdgui-textimagepanel',

	layout: {
		type: 'hbox',
		align: 'strech'
	},

	imagePath: 'images/target_placeholder.png',
	tpl: undefined,
	data: undefined,

  targetStore: null,

//	height: 150,
	bodyPadding: '2 2 2 2',
//	margin: '2 2 2 2',

	initComponent: function () {
		var me = this
		var displayWidth = this.width-15

		this.items = [{
			xtype: 'displayfield',
			tpl: me.tpl,
			data: me.data,
      height: '97%',
      autoScroll: true,
			flex: 2
		}, {
			xtype: 'image',
			src: me.imagePath,
			flex: 1,
			width: 150,
			height: 150
		}]

		this.tpl = undefined
		this.data = undefined

    var store = Ext.create ('TDGUI.store.Targets')
    this.targetStore = store // store loaded afterrender on controller
    this.targetStore.addListener('load', this.showData, this)

		this.callParent (arguments)
	},



  showData: function(store, records, succesful) {
    if (succesful) {
      if (records.length > 0) {
        var numConn = this.data.numconnections
        var targetRec = store.first()
        var targetData = targetRec.data

        var data = {
          nodename: targetData['target_name'],
          nodedesc: targetData['description'],
          numconnections: numConn
        }

        this.data = data
        var displayField = this.items[0]
        this.tpl.overwrite(displayField.bodyEl, this.data)
      }
    }
  }

})