describe GOVUKDesignSystemFormBuilder::FormBuilder do
  include_context 'setup builder'
  include_context 'setup examples'

  describe 'configuration' do
    after { GOVUKDesignSystemFormBuilder.reset! }

    describe 'legend config' do
      include_context 'setup radios'
      let(:method) { :govuk_collection_radio_buttons }
      let(:colours) { Array.wrap(OpenStruct.new(id: 'red', name: 'Red')) }
      let(:args) { [method, attribute, colours, :id, :name, legend: { text: legend_text }] }
      let(:legend_text) { 'Choose a colour' }

      subject { builder.send(*args) }

      describe 'legend tag' do
        specify 'the default tag should be h1' do
          expect(GOVUKDesignSystemFormBuilder.config.default_legend_tag).to eql('h1')
        end

        context 'overriding with h6' do
          let(:configured_tag) { 'h6' }

          before do
            GOVUKDesignSystemFormBuilder.configure do |conf|
              conf.default_legend_tag = configured_tag
            end
          end

          specify 'should create a legend header wrapped in a h6 tag' do
            expect(subject).to have_tag(
              configured_tag,
              with: {
                class: 'govuk-fieldset__heading'
              },
              text: legend_text,
            )
          end
        end
      end

      describe 'legend size' do
        specify 'the default size should be m' do
          expect(GOVUKDesignSystemFormBuilder.config.default_legend_size).to eql('m')
        end

        context 'overriding with s' do
          let(:configured_size) { 's' }

          before do
            GOVUKDesignSystemFormBuilder.configure do |conf|
              conf.default_legend_size = configured_size
            end
          end

          specify 'should create a legend header with the small class' do
            expect(subject).to have_tag('fieldset') do
              with_tag('legend', with: { class: "govuk-fieldset__legend--#{configured_size}" })
            end
          end
        end
      end
    end

    describe 'submit config' do
      specify %(the default should be 'Continue') do
        expect(GOVUKDesignSystemFormBuilder.config.default_submit_button_text).to eql('Continue')
      end

      context 'overriding with custom text' do
        let(:method) { :govuk_submit }
        let(:args) { [method] }
        let(:default_submit_button_text) { 'Make it so, number one' }

        subject { builder.send(*args) }

        before do
          GOVUKDesignSystemFormBuilder.configure do |conf|
            conf.default_submit_button_text = default_submit_button_text
          end
        end

        specify 'should use the default value when no override supplied' do
          expect(subject).to have_tag('input', with: { type: 'submit', value: default_submit_button_text })
        end

        context %(overriding with 'Engage') do
          let(:submit_button_text) { 'Engage' }
          let(:args) { [method, submit_button_text] }

          subject { builder.send(*args) }

          specify 'should use supplied value when overridden' do
            expect(subject).to have_tag('input', with: { type: 'submit', value: submit_button_text })
          end
        end
      end
    end

    describe 'radio divider config' do
      specify %(the default should be 'or') do
        expect(GOVUKDesignSystemFormBuilder.config.default_radio_divider_text).to eql('or')
      end

      context 'overriding with custom text' do
        let(:method) { :govuk_radio_divider }
        let(:args) { [method] }
        let(:default_radio_divider_text) { 'Actually, on the other hand' }

        subject { builder.send(*args) }

        before do
          GOVUKDesignSystemFormBuilder.configure do |conf|
            conf.default_radio_divider_text = default_radio_divider_text
          end
        end

        specify 'should use the default value when no override supplied' do
          expect(subject).to have_tag('div', text: default_radio_divider_text, with: { class: 'govuk-radios__divider' })
        end

        context %(overriding with 'Engage') do
          let(:radio_divider_text) { 'Alternatively' }
          let(:args) { [method, radio_divider_text] }

          subject { builder.send(*args) }

          specify 'should use supplied text when overridden' do
            expect(subject).to have_tag('div', text: radio_divider_text, with: { class: 'govuk-radios__divider' })
          end
        end
      end
    end

    describe 'error summary title' do
      let(:method) { :govuk_error_summary }
      let(:args) { [method] }
      let(:default_error_summary_title) { 'Huge, huge problems here' }

      subject { builder.send(*args) }

      before do
        GOVUKDesignSystemFormBuilder.configure do |conf|
          conf.default_error_summary_title = default_error_summary_title
        end
      end

      before { object.valid? }

      specify 'should use the default value when no override supplied' do
        expect(subject).to have_tag('h2', text: default_error_summary_title, with: { class: 'govuk-error-summary__title' })
      end

      context %(overriding with 'Engage') do
        let(:error_summary_title) { %(We've been hit!) }
        let(:args) { [method, error_summary_title] }

        subject { builder.send(*args) }

        specify 'should use supplied text when overridden' do
          expect(subject).to have_tag('h2', text: error_summary_title, with: { class: 'govuk-error-summary__title' })
        end
      end
    end
  end
end