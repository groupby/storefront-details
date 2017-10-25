import { alias, configurable, tag, Events,
         ProductTransformer, Selectors, Store, Structure, Tag } from '@storefront/core';

@configurable
@alias('details')
@tag('gb-details', require('./index.html'))
class Details {

  structure: Structure = this.config.structure;
  product: Store.Product;

  init() {
    const details = this.select(Selectors.details);
    if (details && details.product) {
      this.updateProduct(details.product);
    }
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
