import { CoreSelectors, Events, ProductTransformer } from '@storefront/core';
import Details from '../../src/details';
import suite from './_suite';

const STRUCTURE = { a: 'b' };

suite('Details', ({ expect, spy, stub, itShouldBeConfigurable, itShouldHaveAlias }) => {
  let details: Details;

  beforeEach(() => {
    Details.prototype.config = <any>{ structure: STRUCTURE };
    details = new Details();
  });
  afterEach(() => delete Details.prototype.config);

  itShouldBeConfigurable(Details);
  itShouldHaveAlias(Details, 'details');

  describe('init()', () => {
    it('should listen for DETAILS_PRODUCT_UPDATED', () => {
      const on = spy();
      const updateProduct = () => 1;
      stub(CoreSelectors, 'transformedDetailsProduct');
      details.flux = <any>{ on };
      details.select = spy();
      details.updateProduct = updateProduct;

      details.init();

      expect(on.calledWith(Events.DETAILS_PRODUCT_UPDATED, details.updateProduct));
    });

    it('should call transformedDetailsProduct selector and call updateProduct with product', () => {
      const on = spy();
      const product = { a: 1 };
      const updateProduct = stub(details, 'updateProduct');
      const transformedDetailsProduct = stub(CoreSelectors, 'transformedDetailsProduct').returns(product);
      const state = { b: 2 };
      details.flux = <any>{ on };
      details.select = spy((f) => (f(state)));

      details.init();

      expect(transformedDetailsProduct).to.be.calledWithExactly(state);
      expect(updateProduct).to.be.calledWithExactly(product);
    });
  });

  describe('updateProduct()', () => {
    it('should update product', () => {
      const product: any = { a: 'b' };
      const update = details.update = spy();

      details.updateProduct(product);

      expect(update).to.be.calledWith({ product });
    });

    it('should update product to be empty', () => {
      const update = details.update = spy();

      details.updateProduct(undefined);

      expect(update).to.be.calledWith({ product: { data: {}, variants: [{}] } });
    });
  });
});
