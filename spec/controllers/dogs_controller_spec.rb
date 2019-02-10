require 'rails_helper'

RSpec.describe DogsController, type: :controller do
  describe '#index' do
    it 'displays recent dogs' do
      2.times { create(:dog) }
      get :index
      expect(assigns(:dogs).size).to eq(2)
    end

    context "for pagination" do
      context "for 10 dogs" do
        before(:each) do
          10.times { create(:dog) }
        end

        context "for page 1" do
          it "5 dogs are displayed" do
            get :index

            expect(assigns(:dogs).size).to eq(5)
          end
        end

        context "for page 2" do
          it "5 dogs are displayed" do
            get :index, params: { "page" => "2" }

            expect(assigns(:dogs).size).to eq(5)
          end
        end

        # TODO - Make this test work
        xcontext "for page 3" do
          it "0 dogs are displayed" do
            get :index, params: { "page" => "3" }

            expect(assigns(:dogs).size).to eq(0)
          end
        end
      end
    end
  end
end
