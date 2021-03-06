/**
 * @class TDGUI.view.panels.PharmByTarget
 * @extend Ext.panel.Panel
 * @alias widget.tdgui-pharmbytargetpanel
 *
 * This is the panel who supports the pharmacology grid. It is displayed when
 * 'Pharmacology' button is clicked from 'Target Info' panel, if enabled
 */
Ext.define ('TDGUI.view.panels.PharmByTarget', {
  extend:'Ext.panel.Panel',
  alias:'widget.tdgui-pharmbytargetpanel',

  requires: ['TDGUI.view.grid.DynamicGrid3',
            'TDGUI.view.grid.PharmByTargetScrollingGrid',
            'TDGUI.store.lda.TargetPharmacologyStore'],

  /**
   * @cfg {Object} layout see TDGUI.view.Viewport#layout
   */
  layout:{
    type:'vbox',
    align:'stretch'
  },

  /**
   * @cfg {Object} gridParams see TDGUI.view.panels.MultiTarget#gridParams
   */
  gridParams: null, // an object to set/add grid.proxy.extraParams
  closable: true,

  initComponent:function () {
    var me = this

//    this.theGrid = this.createGrid()
    this.theGrid = this.createPharmGrid();
    this.items = [this.theGrid];
    this.callParent(arguments);
  },


  /**
   * Creates an instance of dynamicgrid3 grid component an returns it.
   * (see TDGUI.view.panels.MultiTarget#createGrid)
   * @return {TDGUI.view.grid.DynamicGrid3} an instance of {@link TDGUI.view.grid.DynamicGrid3}
   */
  createGrid: function (config) {
    var myConfig = config || {
      title:'Pharmacology for target '+window.decodeURI(this.targetName),
      gridBaseTitle:'Pharmacology compounds for '+window.decodeURI(this.targetName),
      margin:'5 5 5 5',
      //      border: '1 1 1 1',
      flex:1, // needed to fit all container
      //      readUrl: 'resources/datatest/yaut.json'
      //      readUrl: 'tdgui_proxy/multiple_entries_retrieval?entries=Q13362,P0AEN2,P0AEN3'

// further (and dynamic) store configuration
//      readUrl:'/core_api_calls/pharm_by_protein_name.json',
      queryParams: this.gridParams,
      storeActionMethods: {
        read: 'GET'
      }
      //      id: 'dyngrid'+(new Date()).getMilliseconds(),
      //      itemId: 'dyngrid'+(new Date()).getMilliseconds()
    }; // EO myConfig

    var theGrid = Ext.create('widget.dynamicgrid3', myConfig);

    return theGrid;
  },


  createPharmGrid: function () {
    var me = this;

    console.log('creating LDA pharmaGrid...');
    var myConfig = {
      title:'Pharmacology for target '+window.decodeURI(this.targetName),
      gridBaseTitle:'Pharmacology compounds for '+window.decodeURI(this.targetName),
      margin:'5 5 5 5',
      //      border: '1 1 1 1',
      flex:1, // needed to fit all container
      store: Ext.create('TDGUI.store.lda.TargetPharmacologyStore'),
      protein_uri: this.gridParams.protein_uri,
      queryParams: this.gridParams

    };

    var theGrid = Ext.create('widget.tdgui-pharmbytargetscroll-grid', {
          title:'Pharmacology for target '+window.decodeURI(this.targetName),
          gridBaseTitle:'Pharmacology compounds for '+window.decodeURI(this.targetName),
          margin:'5 5 5 5',
          //      border: '1 1 1 1',
          flex:1, // needed to fit all container
          store: Ext.create('TDGUI.store.lda.TargetPharmacologyStore'),
          protein_uri: this.gridParams.protein_uri,
          queryParams: this.gridParams

        });

    return theGrid;
  }

})