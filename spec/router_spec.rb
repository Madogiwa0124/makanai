# frozen_string_literal: true

require 'makanai/router'

RSpec.describe Makanai::Router do
  describe '#get' do
    let(:router) { Makanai::Router.new }
    before { router.get('/') { 'Hello World' } }

    it 'registered one route' do
      expect(router.routes.length).to eq 1
    end

    it 'return GET route object' do
      expect(router.routes.first.path).to eq '/'
      expect(router.routes.first.method).to eq 'GET'
      expect(router.routes.first.process.call).to eq 'Hello World'
    end
  end

  describe '#post' do
    let(:router) { Makanai::Router.new }
    before { router.post('/') { 'Hello World' } }

    it 'return POST route object' do
      expect(router.routes.first.method).to eq 'POST'
    end
  end

  describe '#put' do
    let(:router) { Makanai::Router.new }
    before { router.put('/') { 'Hello World' } }

    it 'return PUT route object' do
      expect(router.routes.first.method).to eq 'PUT'
    end
  end

  describe '#delete' do
    let(:router) { Makanai::Router.new }
    before { router.delete('/') { 'Hello World' } }

    it 'return DELETE route object' do
      expect(router.routes.first.method).to eq 'DELETE'
    end
  end

  describe '#bind!' do
    let(:router) { Makanai::Router.new }

    context 'found route' do
      context 'root path' do
        before { router.get('/') { 'Hello World' } }

        it 'return found route object' do
          route = router.bind!(url: '/', method: 'GET')
          expect(route.process.call).to eq 'Hello World'
        end
      end

      context 'with dinamic path' do
        context 'with :id' do
          before { router.get('/resouces/:id') { 'Hello World' } }

          it 'return found route object' do
            route = router.bind!(url: '/resouces/1', method: 'GET')
            expect(route.url_args).to eq({ 'id' => '1' })
            expect(route.process.call).to eq 'Hello World'
          end
        end

        context 'with :parent_id, :id' do
          before { router.get('/parents/:parent_id/children/:id') { 'Hello World' } }

          it 'return found route object' do
            route = router.bind!(url: '/parents/1/children/2', method: 'GET')
            expect(route.url_args).to eq({ 'parent_id' => '1', 'id' => '2' })
            expect(route.process.call).to eq 'Hello World'
          end
        end
      end
    end

    context 'not found route' do
      it 'raise NotFound' do
        not_found = Makanai::Router::NotFound
        expect { router.bind!(url: '/', method: 'GET') }.to raise_error not_found
      end
    end
  end
end
