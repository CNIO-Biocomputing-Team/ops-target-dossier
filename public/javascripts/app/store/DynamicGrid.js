
/**
 * @class TDGUI.store.DynamicGrid
 *
 * This is the store which is used with TDGUI.view.grid.DynamicGrid. The store is filled on the fly
 */
Ext.define('TDGUI.store.DynamicGrid', {
  extend:'Ext.data.Store',
  model:'TDGUI.model.DynamicGrid',
  fields:[],

  proxy:{
      type:'ajax',
      timeout:'180000',
      suaptest:'REMOVE',
      api:{
        read:''  // We configure this in the form controller
      },
      reader:{
        type:'json',
        suaptest2:'REMOVE2',
        totalProperty:'totalCount'
      }
    }
});