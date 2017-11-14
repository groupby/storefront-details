import { alias, configurable, tag, CoreSelectors, Events, Store, Tag } from '@storefront/core';

@configurable
@alias('details')
@tag('gb-details', require('./index.html'))
class Details {

  product: Store.Product;

  init() {
    this.updateProduct(this.select(CoreSelectors.transformedDetailsProduct));
    this.flux.on(Events.DETAILS_PRODUCT_UPDATED, this.updateProduct);
  }

  updateProduct = (product: Store.Product) => {
    if (product) {
      this.update({ product });
    } else {
      this.update({ product: { data: {}, variants: [{}] } });
    }
  }
}

interface Details extends Tag { }

export default Details;
