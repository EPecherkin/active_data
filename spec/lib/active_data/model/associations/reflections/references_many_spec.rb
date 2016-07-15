# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Model::Associations::Reflections::ReferencesMany do
  before do
    stub_class(:author, ActiveRecord::Base) do
      scope :name_starts_with_a, -> { where('name LIKE "a%"') }
    end

    stub_model(:book) do
      include ActiveData::Model::Associations

      attribute :title
      references_many :authors
    end
  end

  let(:author) { Author.create!(name: 'Rick') }
  let(:other) { Author.create!(name: 'John') }
  let(:book) { Book.new }
  let(:book_with_author) { Book.new(authors: [author]) }

  specify { expect(book.authors).to be_empty }

  context ':class_name' do
    before do
      stub_model(:book) do
        include ActiveData::Model::Associations

        attribute :title
        references_many :creators, class_name: 'Author'
      end
    end

    let(:book) { Book.new }

    specify { expect { book.creators << author }
      .to change { book.creators }.from([]).to([author]) }
    specify { expect { book.creators << author }
      .to change { book.creator_ids }.from([]).to([author.id]) }
  end

  describe ':primary_key' do
    before do
      stub_model(:book) do
        include ActiveData::Model::Associations
        collection :author_names, String
        references_many :authors, primary_key: 'name'
      end
    end

    let(:author) { Author.create!(name: 'Rick') }

    specify { expect { book.author_names = [author.name] }
      .to change { book.authors }.from([]).to([author]) }
    specify { expect { book.authors = [author] }
      .to change { book.author_names }.from([]).to([author.name]) }
  end

  describe ':reference_key' do
    before do
      stub_model(:book) do
        include ActiveData::Model::Associations
        references_many :authors, reference_key: 'identify'
      end
    end

    let(:author) { Author.create!(name: 'Rick') }

    specify { expect { book.identify = [author.id] }
      .to change { book.authors }.from([]).to([author]) }
    specify { expect { book.authors = [author] }
      .to change { book.identify }.from([]).to([author.id]) }
  end

  describe ':default' do
    shared_examples_for :persisted_default do |default|
      before do
        stub_model(:book) do
          include ActiveData::Model::Associations
          references_many :authors
          references_many :owners, class_name: 'Author', default: default
        end
      end

      let(:author) { Author.create! }
      let(:other) { Author.create! }
      let(:book) { Book.new(authors: [author]) }

      specify { expect(book.owner_ids).to eq([author.id]) }
      specify { expect(book.owners).to eq([author]) }
      specify { expect { book.owners = [other] }.to change { book.owner_ids }.from([author.id]).to([other.id]) }
      specify { expect { book.owners = [other] }.to change { book.owners }.from([author]).to([other]) }
      specify { expect { book.owner_ids = [other.id] }.to change { book.owner_ids }.from([author.id]).to([other.id]) }
      specify { expect { book.owner_ids = [other.id] }.to change { book.owners }.from([author]).to([other]) }
      specify { expect { book.owners = [] }.to change { book.owner_ids }.from([author.id]).to([]) }
      specify { expect { book.owners = [] }.to change { book.owners }.from([author]).to([]) }
      specify { expect { book.owner_ids = [] }.not_to change { book.owner_ids }.from([author.id]) }
      specify { expect { book.owner_ids = [] }.not_to change { book.owners }.from([author]) }
      specify { expect { book.owner_ids = [nil] }.to change { book.owner_ids }.from([author.id]).to([]) }
      specify { expect { book.owner_ids = [nil] }.to change { book.owners }.from([author]).to([]) }
      specify { expect { book.owner_ids = [''] }.to change { book.owner_ids }.from([author.id]).to([]) }
      specify { expect { book.owner_ids = [''] }.to change { book.owners }.from([author]).to([]) }
      specify { expect { book.owner_ids = nil }.not_to change { book.owner_ids }.from([author.id]) }
      specify { expect { book.owner_ids = nil }.not_to change { book.owners }.from([author]) }
      specify { expect { book.owner_ids = '' }.to change { book.owner_ids }.from([author.id]).to([]) }
      specify { expect { book.owner_ids = '' }.to change { book.owners }.from([author]).to([]) }
    end

    it_behaves_like :persisted_default, -> { authors.map(&:id) }
    it_behaves_like :persisted_default, -> { authors }

    shared_examples_for :new_record_default do |default|
      before do
        stub_model(:book) do
          include ActiveData::Model::Associations
          references_many :authors
          references_many :owners, class_name: 'Author', default: default
        end
      end

      let(:author) { Author.create! }
      let(:book) { Book.new }

      specify { expect(book.owner_ids).to eq([nil]) }
      specify { expect(book.owners).to match([an_instance_of(Author).and(have_attributes(name: 'Author'))]) }
      specify { expect { book.owners = [other] }.to change { book.owner_ids }.from([nil]).to([other.id]) }
      specify { expect { book.owners = [other] }.to change { book.owners }.from([an_instance_of(Author)]).to([other]) }
      specify { expect { book.owner_ids = [other.id] }.to change { book.owner_ids }.from([nil]).to([other.id]) }
      specify { expect { book.owner_ids = [other.id] }.to change { book.owners }.from([an_instance_of(Author)]).to([other]) }
      specify { expect { book.owners = [] }.to change { book.owner_ids }.from([nil]).to([]) }
      specify { expect { book.owners = [] }.to change { book.owners }.from([an_instance_of(Author)]).to([]) }
      specify { expect { book.owner_ids = [] }.not_to change { book.owner_ids }.from([nil]) }
      specify { expect { book.owner_ids = [] }.not_to change { book.owners }.from([an_instance_of(Author)]) }
      specify { expect { book.owner_ids = [nil] }.to change { book.owner_ids }.from([nil]).to([]) }
      specify { expect { book.owner_ids = [nil] }.to change { book.owners }.from([an_instance_of(Author)]).to([]) }
      specify { expect { book.owner_ids = [''] }.to change { book.owner_ids }.from([nil]).to([]) }
      specify { expect { book.owner_ids = [''] }.to change { book.owners }.from([an_instance_of(Author)]).to([]) }
      specify { expect { book.owner_ids = nil }.not_to change { book.owner_ids }.from([nil]) }
      specify { expect { book.owner_ids = nil }.not_to change { book.owners }.from([an_instance_of(Author)]) }
      specify { expect { book.owner_ids = '' }.to change { book.owner_ids }.from([nil]).to([]) }
      specify { expect { book.owner_ids = '' }.to change { book.owners }.from([an_instance_of(Author)]).to([]) }
    end

    it_behaves_like :new_record_default, name: 'Author'
    it_behaves_like :new_record_default, -> { Author.new(name: 'Author') }
  end

  describe '#scope' do
    before do
      stub_model(:book) do
        include ActiveData::Model::Associations
        references_many :authors, -> { name_starts_with_a }
      end
    end

    let!(:author1) { Author.create!(name: 'Rick') }
    let!(:author2) { Author.create!(name: 'Aaron') }
    specify { expect { book.authors = [author1, author2] }
      .to change { book.authors }.from([]).to([author1, author2]) }
    specify { expect { book.authors = [author1, author2] }
      .to change { book.author_ids }.from([]).to([author1.id, author2.id]) }

    specify { expect { book.author_ids = [author1.id, author2.id] }
      .to change { book.authors }.from([]).to([author2]) }
    specify { expect { book.author_ids = [author1.id, author2.id] }
      .to change { book.author_ids }.from([]).to([author2.id]) }

    specify { expect { book.authors = [author1, author2] }
      .to change { book.authors.reload }.from([]).to([author2]) }
    specify { expect { book.authors = [author1, author2] }
      .to change { book.authors.reload; book.author_ids }.from([]).to([author2.id]) }
  end

  describe '#author' do
    it { expect(book.authors).not_to respond_to(:build) }
    it { expect(book.authors).not_to respond_to(:create) }
    it { expect(book.authors).not_to respond_to(:create!) }

    describe '#clear' do
      it { expect { book_with_author.authors.clear }.to change { book_with_author.authors }.from([author]).to([]) }
    end

    describe '#reload' do
      before { book.authors << author.tap { |a| a.name = 'Don Juan' } }
      it { expect { book.authors.reload }.to change { book.authors.map(&:name) }.from(['Don Juan']).to(['Rick']) }
    end

    describe '#concat' do
      it { expect { book.authors.concat author }.to change { book.authors }.from([]).to([author]) }
      it { expect { book.authors << author << other }.to change { book.authors }.from([]).to([author, other]) }
      context 'no duplication' do
        before { book.authors << author }
        it { expect { book.authors.concat author }.not_to change { book.authors }.from([author]) }
      end
    end

    context 'scope missing method delegation' do
      it { expect(book_with_author.authors.scope.original_scope).to be_a ActiveRecord::Relation }
      it { expect(book_with_author.authors.where(name: 'John')).to be_a ActiveRecord::Relation }
      it { expect(book_with_author.authors.name_starts_with_a).to be_a ActiveRecord::Relation }
    end
  end

  describe '#author_ids' do
    it { expect(book_with_author.author_ids).to eq([author.id]) }
    xit { expect { book_with_author.author_ids << other.id }.to change { book_with_author.authors }.from([author]).to([author, other]) }
    it { expect { book_with_author.author_ids = [other.id] }.to change { book_with_author.authors }.from([author]).to([other]) }
  end

  describe '#authors=' do
    specify { expect { book.authors = [author] }.to change { book.authors }.from([]).to([author]) }
    specify { expect { book.authors = ['string'] }.to raise_error ActiveData::AssociationTypeMismatch }

    context do
      before { book.authors = [other] }
      specify { expect { book.authors = [author] }.to change { book.authors }.from([other]).to([author]) }
      specify { expect { book.authors = [author] }.to change { book.author_ids }.from([other.id]).to([author.id]) }
      specify { expect { book.authors = [] }.to change { book.authors }.from([other]).to([]) }
      specify { expect { book.authors = [] }.to change { book.author_ids }.from([other.id]).to([]) }
    end

    context 'model not persisted' do
      let(:author) { Author.new }
      specify { expect { book.authors = [author, other] }.to change { book.authors }.from([]).to([author, other]) }
      specify { expect { book.authors = [author, other] }.to change { book.author_ids }.from([]).to([nil, other.id]) }

      context do
        before { book.authors = [author, other] }
        specify { expect { author.save! }.to change { book.author_ids }.from([nil, other.id])
          .to(match([an_instance_of(Fixnum), other.id])) }
        specify { expect { author.save! }.not_to change { book.authors } }
      end
    end
  end

  describe '#author_ids=' do
    specify { expect { book.author_ids = [author.id] }.to change { book.author_ids }.from([]).to([author.id]) }
    specify { expect { book.author_ids = [author.id] }.to change { book.authors }.from([]).to([author]) }

    specify { expect { book.author_ids = [author.id.next.to_s] }.not_to change { book.author_ids }.from([]) }
    specify { expect { book.author_ids = [author.id.next.to_s] }.not_to change { book.authors }.from([]) }

    specify { expect { book.author_ids = [author.id.next.to_s, author.id] }.to change { book.author_ids }.from([]).to([author.id]) }
    specify { expect { book.author_ids = [author.id.next.to_s, author.id] }.to change { book.authors }.from([]).to([author]) }

    context do
      before { book.authors = [other] }
      specify { expect { book.author_ids = [author.id] }.to change { book.author_ids }.from([other.id]).to([author.id]) }
      specify { expect { book.author_ids = [author.id] }.to change { book.authors }.from([other]).to([author]) }
      specify { expect { book.author_ids = [] }.to change { book.author_ids }.from([other.id]).to([]) }
      specify { expect { book.author_ids = [] }.to change { book.authors }.from([other]).to([]) }
    end
  end
end
