import { view, Component, Events, ProductTransformer, Store, Structure } from '@storefront/core';

@view('gb-details', require('./index.html'))
class Details extends Component {
  structure: Structure = this.config.structure;
  product: Store.Product;

  constructor() {
    super();
    this.flux.on(Events.DETAILS_PRODUCT_UPDATED, this.updateProduct);
  }

  updateProduct = (product: Store.Product) =>
    this.update({ product: ProductTransformer.transform(product, this.structure) })
}

export default Details;
