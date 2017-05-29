import { view, Component, Events, Store } from '@storefront/core';

@view('gb-details', require('./index.html'))
class Details extends Component {
  product: Store.Product;

  constructor() {
    super();
    this.flux.on(Events.DETAILS_PRODUCT_UPDATED, this.updateProduct);
  }

  updateProduct = (product: Store.Product) => this.update({ product });
}

export default Details;
