import { Events, ProductTransformer } from '@storefront/core';
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

  describe('constructor()', () => {
    it('should set initial values', () => {
      expect(details.structure).to.eq(STRUCTURE);
    });
  });

  describe('init()', () => {
    it('should listen for DETAILS_PRODUCT_UPDATED', () => {
      const on = spy();
      details.flux = <any>{ on };

      details.init();

      expect(on.calledWith(Events.DETAILS_PRODUCT_UPDATED, details.updateProduct));
    });
  });

  describe('updateProduct()', () => {
    it('should update product', () => {
      const product: any = { a: 'b' };
      const transformed = { c: 'd' };
      const update = details.update = spy();
      const transform = stub(ProductTransformer, 'transform').returns(transformed);

      details.updateProduct(product);

      expect(update).to.be.calledWith({ product: transformed });
      expect(transform).to.be.calledWith(product, STRUCTURE);
    });

    it('should update product to be empty', () => {
      const transformed = { c: 'd' };
      const update = details.update = spy();
      stub(ProductTransformer, 'transform', () => expect.fail());

      details.updateProduct(undefined);

      expect(update).to.be.calledWith({ product: { data: {}, variants: [{}] } });
    });
  });
});
