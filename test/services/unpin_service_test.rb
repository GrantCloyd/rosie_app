# frozen_string_literal: true

class UnpinServiceTest < ActiveSupport::TestCase
  describe '#call' do
    describe 'remove pin index from a section' do
      let(:group) { create(:group) }
      let(:sections) do
        build_list(:section, 3, group:) do |section, idx|
          section.pin_index = idx
          section.save
        end
      end
      let(:lowest_pin_index_section) { sections.first }
      subject { UnpinService.new(pinnable: lowest_pin_index_section, belongs_to_assoc: group) }

      it 'removes the index and reindexes every element with a higher pin_index' do
        subject.call

        assert_nil lowest_pin_index_section.pin_index
        # second (previously with pin index 1) and third
        # (previously with pin index 2) sections are now 0 and 1 respectively
        sections[1..2].each_with_index do |section, idx|
          section.reload
          assert_equal idx, section.pin_index
        end
      end
    end

    describe 'remove pin index from a post' do
      let(:section) { create(:section) }
      let(:user) { create(:user) }
      let(:posts) do
        build_list(:post, 3, section:, user:) do |post, idx|
          post.pin_index = idx
          post.save
        end
      end
      let(:highest_pin_index_post) { posts.last }
      subject { UnpinService.new(pinnable: highest_pin_index_post, belongs_to_assoc: section) }

      it 'removes the pin index and does not change any elements lower than the current amount' do
        subject.call

        assert_nil highest_pin_index_post.pin_index
        posts[0..1].each_with_index do |post, idx|
          post.reload # not neccessary, but confirms no change
          assert_equal idx, post.pin_index
        end
      end
    end
  end
end
