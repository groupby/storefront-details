import { Events } from '@storefront/core';
import Details from '../../src/details';
import suite from './_suite';

suite('Details', ({ expect, spy }) => {
  let details: Details;

  beforeEach(() => {
    Details.prototype.config = <any>{};
    details = new Details();
  });
  afterEach(() => delete Details.prototype.config);

  describe('init()', () => {
    it('should listen for DETAILS_PRODUCT_UPDATED', () => {
      const on = spy();
      details.flux = <any>{ on };

      details.init();

      expect(on.calledWith(Events.DETAILS_PRODUCT_UPDATED, details.updateProduct));
    });
  });

  describe('updateProduct()', () => {
    it('should update product');
  });
});
