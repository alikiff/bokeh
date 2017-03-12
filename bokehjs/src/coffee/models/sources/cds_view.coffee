import {Model} from "../../model"
import * as p from "core/properties"
import {intersection} from "core/util/array"

export class CDSView extends Model
  type: 'CDSView'

  initialize: (options) ->
    super(options)

    @compute_indices()

    @listenTo @, 'change:filters', @compute_indices

  @define {
     filters: [ p.Array, [] ]
     source:  [ p.Instance  ]
    }

  @internal {
      indices: [p.Array, [] ]
    }

  compute_indices: () ->
    if @filters.length == 0
      @indices = @source.get_indices()
    else
      indices = (filter.get_indices(@source) for filter in @filters)
      console.log indices
      @indices = intersection.apply(this, indices)

  convert_selection: (selection) ->
    indices_1d = (@indices[i] for i in selection['1d']['indices'])
    selection['1d']['indices'] = indices_1d
    return selection

  convert_indices: (indices) ->
    return (@indices[i] for i in indices)
