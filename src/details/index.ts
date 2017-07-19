import { alias, configurable, tag, Events, ProductTransformer, Store, Structure, Tag } from '@storefront/core';

@configurable
@alias('details')
@tag('gb-details', require('./index.html'))
class Details {

  structure: Structure = this.config.structure;
  product: Store.Product;

  init() {
    this.flux.on(Events.DETAILS_PRODUCT_UPDATED, this.updateProduct);
  }

  updateProduct = (product: Store.Product) => {
    if (product) {
      this.update({ product: ProductTransformer.transform(product, this.structure) });
    } else {
      this.update({ product: { data: {}, variants: [{}] } });
    }
  }
}

interface Details extends Tag { }

export default Details;
